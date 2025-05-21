import SwiftUI

struct ChatLabel: Identifiable, Hashable {
    let id = UUID()
    var text: String
    var time: String?
}

struct guide: View {
    @State private var labels: [ChatLabel] = [
        ChatLabel(text: "new year card", time: nil),
        ChatLabel(text: "new year card  ✴︎✴︎", time: "10:00")
    ]
    @State private var newGoalText: String = ""
    @State private var selectedStars: Int = 0
    @FocusState private var isTextFieldFocused: Bool
    
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
                                Text(time)
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
                                    // 星星按鈕
                                    HStack {
                                        ForEach(0..<6) { _ in
                                            Button(action: {
                                                // 星星按鈕邏輯
                                                selectedStars = min(selectedStars + 1, 6)
                                            }) {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                        /*
                                         ForEach(0..<6) { index in
                                             Button(action: {
                                                 selectedStars = index + 1
                                             }) {
                                                 Image(systemName: selectedStars > index ? "star.fill" : "star")
                                                     .foregroundColor(selectedStars > index ? .yellow : .gray)
                                             }
                                         }
                                         */
                                        
                                    }
                                    
                                    // Memo按鈕
                                    Button(action: {
                                        // Memo按鈕邏輯
                                    }) {
                                        Text("memo")
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.gray.opacity(0.3))
                                            .cornerRadius(5)
                                    }
                                    
                                    Spacer()
                                    
                                    // 隱藏鍵盤按鈕
                                    Button(action: {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }) {
                                        Image(systemName: "keyboard.chevron.compact.down")
                                    }
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
//                .frame(height: 5)
                
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
//                    .fill(Color.blue)
            }
        }
    }
}

#Preview {
    guide()
}
