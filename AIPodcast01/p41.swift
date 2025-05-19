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
    
    private let itemHeight: CGFloat = 40
    
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
                .font(.system(size: 30))
                .foregroundColor(.gray)
                .offset(y: dragOffset * 0.5)
            
            // 當前選中值
            Text(format(currentValue))
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .offset(y: dragOffset)
            
            // 下方第一個數字
            Text(format(getNextValue(from: currentValue, offset: 1)))
                .font(.system(size: 30))
                .foregroundColor(.gray)
                .offset(y: dragOffset * 0.5)
            

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
                    if abs(finalVelocity) > 5 {
                        isDecelerating = true
                        
                        // 使用速度決定額外移動的距離和方向
                        let maxDeceleration: CGFloat = 200 // 最大慣性距離
                        let deceleration = min(abs(finalVelocity) * 3, maxDeceleration) * (finalVelocity < 0 ? -1 : 1)
                        
                        // 動畫模擬慣性
                        withAnimation(.easeOut(duration: 0.5)) {
                            accumulatedOffset += deceleration
                        }
                        
                        // 延遲更新值並重置狀態
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                    .offset(y: dragOffset * 0.5)
            }
            
            // 當前選項
            Text(currentValue)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .offset(y: dragOffset)
            
            // 當選擇AM時，PM顯示在下方
            if currentValue == "AM" {
                Text("PM")
                    .font(.system(size: 30))
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

struct FocusPointView: View {
    // 接收來自p40的NavigationState
    @ObservedObject var navigationState: NavigationState
    
    @State private var duration = "標準時長 （10-20分鐘）"
    @State private var selectedType = "routine"
    @State private var selectedHour = 8
    @State private var selectedMinute = 0
    @State private var selectedAmPm = "PM"
    @State private var selectedDay: Int = 0 // 0表示星期一，1表示星期二，以此類推
    @State private var frequency = "每週"
    @State private var duration2 = "無"
    @State private var isTimeMenuExpanded = false
    
    // 標準時長可選項
    let timeOptions = [
        "短篇形式 （5-10分鐘）",
        "標準時長 （10-20分鐘）",
        "深入探討 （20-30分鐘）",
    ]
    
    let dayLabels = ["一", "二", "三", "四", "五", "六", "日"]
    let hours = Array(1...12)
    let minutes = [0, 1, 59]
    
    // 獲取按鈕坐標的狀態變數
    @State private var dropdownMenuYPosition: CGFloat = 0
    @State private var dropdownMenuWidth: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                // 主要內容
                VStack(spacing: 20) {
                    // Progress bar
                    HStack(spacing: 8) {
                        // 橘色邊框未填充的進度條
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange, lineWidth: 1.5)
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
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
                    .padding(.top, 32)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    // 標題
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("What do you want to accomplish at")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "sparkles")
                                .foregroundColor(.white)
                        }
                        
                        Text("關注點")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    // 標準時長選擇器和內容預覽（重疊在灰線上）
                    ZStack(alignment: .topLeading) {
                        // 標準時長選擇器
                        Button(action: {
                            // 切換下拉菜單的顯示狀態
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isTimeMenuExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Text(duration)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 20)
                                
                                Spacer()
                                
                                Image(systemName: isTimeMenuExpanded ? "chevron.up" : "chevron.down")
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
                        
                        // 內容預覽文本浮動在灰線上
                        Text("內容時長")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .background(Color.black) // 背景與主背景相同，防止灰線穿過文字
                            .offset(x: 10, y: -8) // 微調位置使其位於灰線上
                    }
                    .padding(.horizontal)
                    
                    // 類型選擇器 - 滑動動畫效果
                    ZStack(alignment: .leading) {
                        // 背景容器 - 改為灰色背景
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
                                    selectedType = "值固本次"
                                }
                            }) {
                                Text("值固本次")
                                    .fontWeight(.medium)
                                    .frame(width: geometry.size.width / 2 - 20, height: 40)
                                    .foregroundColor(selectedType == "值固本次" ? Color.black : Color.white)
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
                    
                    // 時間選擇器 - 添加流暢滑動效果
                    VStack {
                        // 整個時間選擇器
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
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 20)
                                    .offset(y: -5) // 確保冒號垂直居中
                                
                                // 分鐘選擇器
                                TimeWheelView(
                                    currentValue: $selectedMinute,
                                    range: 0...59,
                                    format: { String(format: "%02d", $0) },
                                    width: 70
                                )
                                
                                // AM/PM選擇器 - 調整對齊
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
                    
                                    // 星期選擇器 - 完全修復凸出問題
                    VStack {
                        ZStack(alignment: .leading) {
                            // 背景容器 - 灰色背景
                            RoundedRectangle(cornerRadius: 60)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 45)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                            
                            // 滑動的白色背景
                            let containerWidth = geometry.size.width - 32 // 減去左右padding
                            let buttonWidth = containerWidth / 7 // 每個按鈕的寬度
                            let indicatorWidth = containerWidth / 10 // 指示器的寬度
                            
                            RoundedRectangle(cornerRadius: 60)
                                .fill(Color.white)
                                .frame(width: indicatorWidth, height: 40)
                                .offset(x: CGFloat(selectedDay) * buttonWidth + (buttonWidth - indicatorWidth) / 2)
                                .animation(.spring(), value: selectedDay)
                            
                            // 文字按鈕
                            HStack(spacing: 0) {
                                ForEach(0..<7) { index in
                                    Button(action: {
                                        withAnimation {
                                            selectedDay = index
                                        }
                                    }) {
                                        Text(dayLabels[index])
                                            .font(.system(size: 14))
                                            .fontWeight(.medium)
                                            .frame(width: buttonWidth, height: 40)
                                            .foregroundColor(selectedDay == index ? Color.black : Color.white)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width - 32, height: 40) // 明確設置寬度與其他元素一致
                    }
                    
                    // 循環單位
                    HStack {
                        Text("循環單位")
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(frequency)
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
                    
                    // 期限
                    HStack {
                        Text("期限")
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(duration2)
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
                    
                    Spacer()
                    
                    // 底部按鈕
                    HStack {
                        Button(action: {
                            // 回上一步 - 返回p40
                            navigationState.goToPreviousPage()
                        }) {
                            Text("回上一步")
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 30)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 下一步 - 這裡可以導航到下一個畫面（如果有的話）
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
                            .background(Color.orange)
                            .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                
                // 下拉選單浮動層 - 完全獨立的覆蓋層
                if isTimeMenuExpanded {
                    ZStack {
                        // 透明背景層，用於捕獲點擊事件關閉選單
                        Color.black.opacity(0.01)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isTimeMenuExpanded = false
                                }
                            }
                        
                        // 選單容器，定位到按鈕下方
                        VStack(alignment: .leading, spacing: 0) {
                            // 空的按鈕形狀，與頂部選擇器形狀完全相同，但隱藏不顯示
                            // 這是為了在視覺上讓下方的選項看起來是從按鈕延伸出來的
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 0)
                            
                            // 只顯示非當前選中的選項
                            ForEach(timeOptions.filter { $0 != duration }, id: \.self) { option in
                                Button(action: {
                                    duration = option
                                    withAnimation {
                                        isTimeMenuExpanded = false
                                    }
                                }) {
                                    HStack {
                                        Text(option)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 12)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                }
                                
                                // 選項之間的分隔線 (除了最後一個選項)
                                if option != timeOptions.filter { $0 != duration }.last {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                        .padding(.horizontal, 8)
                                }
                            }
                        }
                        .background(Color.black) // 完全不透明的背景
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .frame(width: geometry.size.width - 32) // 減去左右各16的padding
                        .position(x: geometry.size.width / 2, y: 183) // 調整位置使其剛好在按鈕下方
                    }
                    .transition(.opacity)
                    .zIndex(100) // 確保它顯示在最上層
                }
            }
        }
    }
}

struct FocusPointView_Previews: PreviewProvider {
    static var previews: some View {
        FocusPointView(navigationState: NavigationState())
            .preferredColorScheme(.dark)
    }
}
