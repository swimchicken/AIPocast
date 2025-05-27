import SwiftUI

struct ChatLabel: Identifiable, Hashable {
    let id = UUID()
    let text: String
//    var time: String?
    let time: Date?
    var starCount: Int?
    var memo: String?
}

struct guide: View {
    @State private var labels: [ChatLabel] = [
        ChatLabel(text: "new year card", time: nil),
//        ChatLabel(text: "new year card  ✴︎✴︎", time: "10:00")
    ]
    @State private var newGoalText: String = ""
    @State private var selectedStars: Int = 0
    @State private var showMemoField: Bool = false  // 控制備註欄位顯示
    @State private var memoText: String = ""        // 備註內容
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isMemoFocused: Bool
    
    private let inputColor = Color(red: 1, green: 0.38, blue: 0)
    
    var body: some View {
        ZStack(alignment: .top){
            Color.black
                .ignoresSafeArea()
            
            HStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 290, height: 290)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .cornerRadius(290)
                    .blur(radius: 100)
                    .opacity(0.3)
            }
            .padding(.top, 136)
                        
            VStack(spacing: 0){
                ZStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 10)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 1, green: 0.38, blue: 0), lineWidth: 1)
                            )
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 77, height: 11)
                            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
                            .cornerRadius(29)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 77, height: 11)
                            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
                            .cornerRadius(29)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 77, height: 11)
                            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
                            .cornerRadius(29)
                        
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 20, height: 20)
                                .background(Color(red: 0.13, green: 0.13, blue: 0.13))
                                .cornerRadius(29)
                            Image("guide_done_1")
                                .padding(.top, 2)
                        }
                        .padding(.leading, 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                HStack(){
                    VStack(alignment: .leading, spacing: 7){
                        Text("What do you want to accomplish at")
                          .font(
                            Font.custom("Instrument Sans", size: 13)
                              .weight(.semibold)
                          )
                          .foregroundColor(.white)
                          .padding(.leading, 3)
                        
                        Text("主題標籤")
                          .font(
                            Font.custom("Instrument Sans", size: 31.79449)
                              .weight(.bold)
                          )
                          .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    //Icon
                    Image("guide_icon")
                        .padding(.bottom, 3)
                        .padding(.trailing, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 26)
                .padding(.bottom, 35)
                
                VStack{
                    
                    ForEach(labels) { goal in
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text(goal.text)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Spacer()
                                
                                // Show Stars:
                                if selectedStars > 0 {
                                    HStack(spacing: 2) {
                                        ForEach(0..<min(selectedStars, 6), id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.white)
                                                .font(.system(size: 12))
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if let idx = labels.firstIndex(of: goal) {
                                        labels.remove(at: idx)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 20))
                                }
                            }
                            .frame(height: 26)
                            .padding(.top, 10)
                            
                            if let time = goal.time {
                                Text(formatDate(time))
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            
                            Divider()
                                .background(Color.white)
                                .padding(.top, 9)
                        }
                    }
                    HStack {
                        TextField("new", text: $newGoalText)
                            .focused($isTextFieldFocused)
                            .foregroundColor(.white)
                            .keyboardType(.default)
                            .colorScheme(.dark)
                            .font(
                                Font.custom("Inria Sans", size: 20)
                                .weight(.bold)
                            )
                            .onSubmit {
                                if !newGoalText.trimmingCharacters(in: .whitespaces).isEmpty {
                                    labels.append(ChatLabel(text: newGoalText, time: nil))
                                    newGoalText = ""
                                }
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    keyboardToolbar
//                                    // 星星按鈕
//                                    HStack {
//                                        ForEach(0..<6) { _ in
//                                            Button(action: {
//                                                // 星星按鈕邏輯
//                                                selectedStars = min(selectedStars + 1, 6)
//                                            }) {
//                                                Image(systemName: "star.fill")
//                                                    .foregroundColor(.gray)
//                                            }
//                                        }
//                                        
//                                        /*
//                                         ForEach(0..<6) { index in
//                                             Button(action: {
//                                                 selectedStars = index + 1
//                                             }) {
//                                                 Image(systemName: selectedStars > index ? "star.fill" : "star")
//                                                     .foregroundColor(selectedStars > index ? .yellow : .gray)
//                                             }
//                                         }
//                                         */
//                                        
//                                    }
//                                    
//                                    // Memo按鈕
//                                    Button(action: {
//                                        // Memo按鈕邏輯
//                                    }) {
//                                        Text("memo")
//                                            .padding(.horizontal, 10)
//                                            .padding(.vertical, 5)
//                                            .background(Color.gray.opacity(0.3))
//                                            .cornerRadius(5)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    // 隱藏鍵盤按鈕
//                                    Button(action: {
//                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                                    }) {
//                                        Image(systemName: "keyboard.chevron.compact.down")
//                                    }
                                }
                            }
                        
                        
                    }
                    .padding(.top, 4)
                    .frame(height: 50)
                    
                    if (!isTextFieldFocused){
                        Divider()
                            .background(Color.white)
                    }
                    else{
                        Divider()
                            .overlay(Color(red: 1, green: 0.38, blue: 0).frame(height: 1))
                    }
                }
//                .background(Color.blue)
                .padding(.horizontal, 28)
                
                // 備註欄位 - 只在showMemoField為true時顯示
                if showMemoField {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("備註")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        // 自適應高度的TextEditor
                        TextEditor(text: $memoText)
                            .focused($isMemoFocused)
                            .scrollContentBackground(.hidden)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .frame(minHeight: 60)
                            .frame(maxHeight: calculateTextHeight(text: memoText))
                            .padding(.horizontal, 16)
                            .onAppear {
                                // 當備註欄位出現時，自動聚焦
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isMemoFocused = true
                                }
                            }
                    }
                    .padding(.bottom, 8)
                    .background(Color.black)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                Spacer()
                
                HStack (spacing: 25){
                    Button(action: {}) {
                        Text("回上一步")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
//                            .background(Color.clear)
                    }
                    Button(action: {}) {
                        HStack(alignment: .center) {
                            Text("下一步")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .cornerRadius(38)
                        .frame(width: 249, height: 60, alignment: .center)
                        .background(Color(red: 1, green: 0.38, blue: 0))
                        .cornerRadius(38)
                        .overlay(
                          RoundedRectangle(cornerRadius: 38)
                            .inset(by: 0.5)
                            .stroke(.white.opacity(0.32), lineWidth: 1)
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading,15)
                .padding(.bottom, 24)
//                Rectangle()
//                    .fill(Color.blue) //用來檢查Stack範圍
            }
        }
    }
    
    // 鍵盤工具列
    private var keyboardToolbar: some View {
        HStack {
            // 星星按鈕
            HStack(spacing: 4) {
                ForEach(0..<6, id: \.self) { index in
                    Button(action: {
                        selectedStars = index + 1
                    }) {
                        Image(systemName: selectedStars > index ? "star.fill" : "star")
                            .foregroundColor(selectedStars > index ? .yellow : .gray)
                            .font(.system(size: 16))
                    }
                }
            }
            
            // Memo按鈕
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showMemoField.toggle()
                    
                    // 如果隱藏備註欄位，清空備註內容並回到主輸入欄位
                    if !showMemoField {
                        memoText = ""
                        isTextFieldFocused = true
                    }
                }
            }) {
                Text("memo")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(showMemoField ? .black : .gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(showMemoField ? Color.white : Color.gray.opacity(0.3))
                    .cornerRadius(6)
            }
            
            Spacer()
            
            // 隱藏鍵盤按鈕
            Button(action: {
                hideKeyboard()
            }) {
                Image(systemName: "keyboard.chevron.compact.down")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal, 8)
    }
    
    // 添加新項目
    private func addNewItem() {
        guard !newGoalText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newLabel = ChatLabel(
            text: newGoalText,
//            time: time,
            time: Date(),
            starCount: selectedStars > 0 ? selectedStars : nil,
            memo: memoText.isEmpty ? nil : memoText
        )
        
        labels.append(newLabel)
        
        // 重置輸入狀態
        newGoalText = ""
        selectedStars = 0
        memoText = ""
        showMemoField = false
    }
    
    // 計算文字高度
    private func calculateTextHeight(text: String) -> CGFloat {
        let lineCount = max(1, text.components(separatedBy: .newlines).count)
        let baseHeight: CGFloat = 60
        let lineHeight: CGFloat = 20
        return min(baseHeight + CGFloat(lineCount - 1) * lineHeight, 120) // 最大高度限制
    }
    
    // 隱藏鍵盤
    private func hideKeyboard() {
        isTextFieldFocused = false
        isMemoFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_TW") // 繁體中文
        return formatter.string(from: date)
    }
    
}

//
//// 列表項目視圖
//struct ListItemView: View {
//    let text: String
//    let starCount: Int
//    let memo: String?
//    let onDelete: () -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            // 主要內容行
//            HStack {
//                Text(text)
//                    .foregroundColor(.white)
//                    .font(.system(size: 16))
//                
//                Spacer()
//                
//                // 顯示星星
//                if starCount > 0 {
//                    HStack(spacing: 2) {
//                        ForEach(0..<min(starCount, 6), id: \.self) { _ in
//                            Image(systemName: "star.fill")
//                                .foregroundColor(.white)
//                                .font(.system(size: 12))
//                        }
//                    }
//                }
//                
//                // 刪除按鈕
//                Button(action: onDelete) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                        .font(.system(size: 18))
//                }
//            }
//            
//            // 備註內容 (如果有的話)
//            if let memo = memo, !memo.isEmpty {
//                HStack {
//                    Text("備註")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
//                
//                Text(memo)
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 8)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//            }
//        }
//        .padding(.vertical, 12)
//        .padding(.horizontal, 16)
//        .background(Color.black)
//    }
//}

#Preview {
    guide()
}
