import SwiftUI

// TimeWheelView 組件 - 專為 Int 類型優化的滾輪視圖
struct TimeWheelView: View {
    @Binding var currentValue: Int
    let range: ClosedRange<Int>
    let format: (Int) -> String
    let width: CGFloat
    
    @State private var dragOffset: CGFloat = 0
    @State private var previousDragValue: CGFloat = 0
    @State private var accumulatedOffset: CGFloat = 0
    @State private var isDecelerating: Bool = false
    @State private var velocity: CGFloat = 0
    
    private let itemHeight: CGFloat = 60 // 增加高度，減緩滑動速度
    
    private func getNextValue(from current: Int, offset: Int) -> Int {
        let allValues = Array(range)
        guard let currentIndex = allValues.firstIndex(of: current) else { return current }
        
        let targetIndex = (currentIndex + offset) % allValues.count
        return targetIndex >= 0 ? allValues[targetIndex] : allValues[allValues.count + targetIndex]
    }
    
    private func getPreviousValue(from current: Int, offset: Int) -> Int {
        let allValues = Array(range)
        guard let currentIndex = allValues.firstIndex(of: current) else { return current }
        
        let targetIndex = (currentIndex - offset) % allValues.count
        return targetIndex >= 0 ? allValues[targetIndex] : allValues[allValues.count + targetIndex]
    }
    
    private func updateValueFromOffset() {
        // 計算從拖動開始後，值應該改變的數量
        let offset = accumulatedOffset + dragOffset
        let valueChange = Int(offset / itemHeight)
        
        if valueChange != 0 {
            // 根據valueChange來決定值如何變化
            var newValue = currentValue
            for _ in 0..<abs(valueChange) {
                if valueChange > 0 {
                    // 向下滑動，增加值
                    if newValue == range.upperBound {
                        newValue = range.lowerBound
                    } else {
                        newValue = newValue + 1
                    }
                } else {
                    // 向上滑動，減少值
                    if newValue == range.lowerBound {
                        newValue = range.upperBound
                    } else {
                        newValue = newValue - 1
                    }
                }
            }
            currentValue = newValue
            
            // 重置累計偏移量
            accumulatedOffset = offset - (CGFloat(valueChange) * itemHeight)
            dragOffset = 0
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // 上方第一個數字
            Text(format(getPreviousValue(from: currentValue, offset: 1)))
                .font(.system(size: 30, weight: .light)) // 調細字體
                .foregroundColor(.gray)
                .offset(y: dragOffset * 0.3) // 減少偏移影響
            
            // 當前選中值
            Text(format(currentValue))
                .font(.system(size: 40, weight: .regular)) // 從 .bold 改為 .regular
                .foregroundColor(.white)
                .offset(y: dragOffset * 0.6) // 減少偏移影響
            
            // 下方第一個數字
            Text(format(getNextValue(from: currentValue, offset: 1)))
                .font(.system(size: 30, weight: .light)) // 調細字體
                .foregroundColor(.gray)
                .offset(y: dragOffset * 0.3) // 減少偏移影響
        }
        .frame(width: width)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 2) // 增加最小拖動距離
                .onChanged { value in
                    if !isDecelerating {
                        // 計算當前拖動偏移量，添加阻尼效果
                        let newDragValue = value.translation.height * 0.7 // 添加阻尼係數
                        // 更新速度
                        velocity = (newDragValue - previousDragValue) * 0.5 // 減少速度影響
                        previousDragValue = newDragValue
                        dragOffset = newDragValue
                        
                        // 更新值
                        updateValueFromOffset()
                    }
                }
                .onEnded { value in
                    // 根據速度應用慣性效果
                    let finalVelocity = velocity
                    accumulatedOffset += dragOffset
                    dragOffset = 0
                    previousDragValue = 0
                    
                    // 如果速度足夠大，應用慣性效果
                    if abs(finalVelocity) > 8 { // 提高速度閾值
                        isDecelerating = true
                        
                        // 使用速度決定額外移動的距離和方向
                        let maxDeceleration: CGFloat = 120 // 減少最大慣性距離
                        let deceleration = min(abs(finalVelocity) * 2, maxDeceleration) * (finalVelocity < 0 ? -1 : 1) // 減少慣性係數
                        
                        // 動畫模擬慣性
                        withAnimation(.easeOut(duration: 0.8)) { // 增加動畫時間
                            accumulatedOffset += deceleration
                        }
                        
                        // 延遲更新值並重置狀態
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            updateValueFromOffset()
                            accumulatedOffset = 0
                            isDecelerating = false
                        }
                    } else {
                        // 無慣性，直接更新並重置
                        updateValueFromOffset()
                        accumulatedOffset = 0
                    }
                }
        )
    }
}

// AM/PM 專用輪子視圖
struct AmPmWheelView: View {
    @Binding var currentValue: String
    let width: CGFloat
    
    @State private var dragOffset: CGFloat = 0
    @State private var previousDragValue: CGFloat = 0
    @State private var isDecelerating: Bool = false
    @State private var velocity: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 13) {
            // 當選擇PM時，AM顯示在上方
            if currentValue == "PM" {
                Text("AM")
                    .font(.system(size: 30, weight: .light)) // 調細字體
                    .foregroundColor(.gray)
                    .offset(y: dragOffset * 0.5)
            }
            
            // 當前選項
            Text(currentValue)
                .font(.system(size: 40, weight: .regular)) // 從 .bold 改為 .regular
                .foregroundColor(.white)
                .offset(y: dragOffset)
            
            // 當選擇AM時，PM顯示在下方
            if currentValue == "AM" {
                Text("PM")
                    .font(.system(size: 30, weight: .light)) // 調細字體
                    .foregroundColor(.gray)
                    .offset(y: dragOffset * 0.5)
            }
        }
        .frame(width: width)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 1)
                .onChanged { value in
                    if !isDecelerating {
                        // 計算當前拖動偏移量
                        let newDragValue = value.translation.height
                        // 更新速度
                        velocity = newDragValue - previousDragValue
                        previousDragValue = newDragValue
                        // 限制偏移量範圍，使其有限制感
                        dragOffset = min(max(newDragValue, -30), 30)
                    }
                }
                .onEnded { value in
                    // 根據速度或方向決定是否切換
                    let finalVelocity = velocity
                    
                    if abs(dragOffset) > 10 || abs(finalVelocity) > 5 {
                        // 觸發切換
                        currentValue = currentValue == "AM" ? "PM" : "AM"
                    }
                    
                    // 重置狀態
                    withAnimation(.spring()) {
                        dragOffset = 0
                    }
                    previousDragValue = 0
                    isDecelerating = false
                }
        )
    }
}

// 進度條組件
struct ProgressBarView: View {
    var body: some View {
        HStack(spacing: 5) {
            // #FF6200 填滿的進度條
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "FF6200"))
                .frame(height: 10)
                .frame(maxWidth: .infinity)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "FF6200"))
                .frame(height: 10)
                .frame(maxWidth: .infinity)
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "FF6200"), lineWidth: 1.5)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 10)
                .frame(maxWidth: .infinity)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 10)
                .frame(maxWidth: .infinity)
            
            // 最右側帶勾號的灰色圓圈
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 16, height: 16)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
        .padding(.bottom,5)
    }
}

// 標題組件
struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("What do you want to accomplish at")
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .foregroundColor(.white)
            }
            
            Text("推送時間")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
    }
}

// 時長選擇器組件
struct DurationSelectorView: View {
    @Binding var duration: String
    let timeOptions: [String]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 使用 Menu 組件的標準時長選擇器
            Menu {
                ForEach(timeOptions, id: \.self) { option in
                    Button(action: {
                        duration = option
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(duration)
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 19)
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 11)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }
            .menuOrder(.fixed) // 固定菜單顯示順序
            .menuIndicator(.hidden) // 隱藏系統默認的菜單指示器
            .frame(maxWidth: .infinity, alignment: .trailing) // 讓菜單容器靠右對齊
            
            
            // 內容預覽文本浮動在灰線上
            Text("內容時長")
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.horizontal, 8)
                .background(Color.black)
                .offset(x: 10, y: -8)
        }
        .padding(.horizontal)
    }
}

// 類型選擇器組件
struct TypeSelectorView: View {
    @Binding var selectedType: String
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack(alignment: .leading) {
            // 背景容器
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 45)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            // 滑動的白色背景
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: geometry.size.width / 2 - 23, height: 40)
                .offset(x: selectedType == "routine" ? geometry.size.width / 2 - 16 : 8)
                .animation(.spring(), value: selectedType)
            
            // 文字按鈕
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        selectedType = "僅限本次"
                    }
                }) {
                    Text("僅限本次")
                        .fontWeight(.medium)
                        .frame(width: geometry.size.width / 2 - 20, height: 40)
                        .foregroundColor(selectedType == "僅限本次" ? Color.black : Color.white)
                }
                
                Button(action: {
                    withAnimation {
                        selectedType = "routine"
                    }
                }) {
                    Text("routine")
                        .fontWeight(.medium)
                        .frame(width: geometry.size.width / 2 - 20, height: 40)
                        .foregroundColor(selectedType == "routine" ? Color.black : Color.white)
                }
            }
        }
        .frame(height: 40)
        .padding(.horizontal)
    }
}

// 時間選擇器組件
struct TimePickerView: View {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    @Binding var selectedAmPm: String
    
    var body: some View {
        VStack {
            ZStack {
                // 中間選中行的深灰色背景
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 60)
                
                HStack(spacing: 15) {
                    // 小時選擇器
                    TimeWheelView(
                        currentValue: $selectedHour,
                        range: 1...12,
                        format: { "\($0)" },
                        width: 70
                    )
                    
                    // 冒號
                    Text(":")
                        .font(.system(size: 40, weight: .regular)) // 從 .bold 改為 .regular
                        .foregroundColor(.white)
                        .frame(width: 20)
                        .offset(y: -5)
                    
                    // 分鐘選擇器
                    TimeWheelView(
                        currentValue: $selectedMinute,
                        range: 0...59,
                        format: { String(format: "%02d", $0) },
                        width: 70
                    )
                    
                    // AM/PM選擇器
                    Spacer(minLength: 0)
                    
                    AmPmWheelView(currentValue: $selectedAmPm, width: 70)
                        .offset(x: 0, y: selectedAmPm == "AM" ? 25 : -25)
                }
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity)
            }
            .frame(height: 140)
        }
        .padding(.vertical, 10)
    }
}

// 星期選擇器組件
struct WeekSelectorView: View {
    @Binding var selectedDays: Set<Int>
    let dayLabels: [String]
    
    var body: some View {
        ZStack(alignment: .leading) {
            // 背景容器 - 灰色背景，保持原來的長條形設計
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            // 文字按鈕
            HStack(spacing: 0) {
                ForEach(0..<7) { index in
                    Button(action: {
                        // 切換選中狀態
                        if selectedDays.contains(index) {
                            selectedDays.remove(index)
                        } else {
                            selectedDays.insert(index)
                        }
                    }) {
                        ZStack {
                            // 選中時顯示白色圓形背景
                            if selectedDays.contains(index) {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 28, height: 28)
                            }
                            
                            // 文字
                            Text(dayLabels[index])
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .foregroundColor(selectedDays.contains(index) ? Color.black : Color.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// 設定項目組件
struct SettingItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

// 可選擇的設定項目組件
struct SelectableSettingItemView: View {
    let title: String
    @Binding var selectedValue: String
    let options: [String]
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedValue = option
                }) {
                    HStack {
                        Text(option)
                        Spacer()
                        if selectedValue == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 5) {
                    Text(selectedValue)
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

// 底部按鈕組件
struct BottomButtonsView: View {
    let navigationState: NavigationState
    
    var body: some View {
        HStack {
            Button(action: {
                navigationState.goToPreviousPage()
            }) {
                Text("回上一步")
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            
            Button(action: {
                navigationState.goToNextPage()
            }) {
                HStack {
                    Text("下一步")
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 50)
                .background(Color(hex: "FF6200"))
                .cornerRadius(30)
            }
        }
        .padding(.horizontal)
    }
}

struct FocusPointView: View {
    @Environment(\.presentationMode) var presentationMode
    // 接收來自p40的NavigationState
    @ObservedObject var navigationState: NavigationState
    @State private var navigateToVoiceCharacterSelection = false
    
    // 循環單位選擇選項
    let cycleOptions = ["每週", "每日"]
    
    // 標準時長可選項
    let timeOptions = [
        "短篇形式 （5-10分鐘）",
        "標準時長 （10-20分鐘）",
        "深入探討 （20-30分鐘）",
    ]
    
    let dayLabels = ["一", "二", "三", "四", "五", "六", "日"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    ProgressBarView()
                    HeaderView()
                    
                    DurationSelectorView(
                        duration: $navigationState.contentDuration,
                        timeOptions: timeOptions
                    )
                    
                    TypeSelectorView(
                        selectedType: $navigationState.selectedType,
                        geometry: geometry
                    )
                    
                    TimePickerView(
                        selectedHour: $navigationState.selectedHour,
                        selectedMinute: $navigationState.selectedMinute,
                        selectedAmPm: $navigationState.selectedAmPm
                    )
                    
                    // 星期選擇器容器 - 保持固定高度以避免布局跳動
                    ZStack {
                        // 固定高度的透明容器，高度與WeekSelectorView一致
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 40) // 與WeekSelectorView的高度一致
                        
                        // 只有選擇「每週」時才顯示星期選擇器
                        if navigationState.frequency == "每週" {
                            WeekSelectorView(
                                selectedDays: $navigationState.selectedDays,
                                dayLabels: dayLabels
                            )
                        }
                    }
                    
                    SelectableSettingItemView(
                        title: "循環單位",
                        selectedValue: $navigationState.frequency,
                        options: cycleOptions
                    )
                    
                    SettingItemView(title: "期限", value: navigationState.duration2)
                    
                    Spacer()
                    
                    // 底部按鈕 - 直接在這裡處理導航
                    HStack {
                        Button(action: {
                            print("返回 p40") // 調試信息
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("回上一步")
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 30)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            print("前往 p42") // 調試信息
                            navigationState.goToNextPage()
                            navigateToVoiceCharacterSelection = true
                        }) {
                            HStack {
                                Text("下一步")
                                    .foregroundColor(.white)
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 50)
                            .background(Color(hex: "FF6200"))
                            .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                
                // 導航到 p42
                NavigationLink(
                    destination: CharacterSetupView(navigationState: navigationState),
                    isActive: $navigateToVoiceCharacterSelection
                ) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct FocusPointView_Previews: PreviewProvider {
    static var previews: some View {
        FocusPointView(navigationState: NavigationState())
            .preferredColorScheme(.dark)
    }
}
