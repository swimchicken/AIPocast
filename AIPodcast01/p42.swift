import SwiftUI

struct CharacterSetupView: View {
    // 接收從其他視圖傳入的NavigationState
    @ObservedObject var navigationState: NavigationState
    
    // 模式選擇: "對話式" 或 "單人"
    @State private var selectedMode: String = "對話式"
    
    // 可用的模式選項
    let modes = ["對話式", "單人"]
    
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
                    
                    // 標題區域 - 改進間距
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("What do you want to accomplish at")
                                .foregroundColor(.white)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            // 方塊圖標
                            Image(systemName: "square.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                        
                        Text("角色")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    // 模式選擇文字標籤
                    VStack(alignment: .leading) {
                        Text("模式選擇")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.leading, 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // 模式選擇器 - 使用下拉菜單風格
                    Menu {
                        ForEach(modes, id: \.self) { mode in
                            Button(action: {
                                selectedMode = mode
                            }) {
                                Text(mode)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedMode)
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    
                    // 根據選擇顯示不同佈局
                    if selectedMode == "對話式" {
                        DialogModeView()
                    } else {
                        SingleModeView()
                    }
                    
                    Spacer()
                    
                    // 底部按鈕
                    HStack {
                        Button(action: {
                            // 回上一步 - 向前導航
                            navigationState.goToPreviousPage()
                        }) {
                            Text("回上一步")
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 下一步 - 導航到p42
                            navigationState.currentPage = 42 // 明確設置為p42頁
                            navigationState.goToNextPage()
                        }) {
                            HStack {
                                Text("下一步")
                                    .foregroundColor(.white)
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 40)
                            .background(Color.orange)
                            .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

// 對話式模式視圖
struct DialogModeView: View {
    var body: some View {
        VStack(spacing: 25) {
            // 兩個角色頭像
            HStack(spacing: 20) {
                ForEach(0..<2) { _ in
                    CharacterAvatar()
                }
            }
            .padding(.top, 20)
            
            // 三個按鈕
            VStack(spacing: 15) {
                Button(action: {
                    // 精選推角色的動作
                }) {
                    Text("精選推角色")
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                
                Button(action: {
                    // 精選推第1梯格的動作
                }) {
                    Text("精選推第1梯格")
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                
                Button(action: {
                    // 精選推第2梯格的動作
                }) {
                    Text("精選推第2梯格")
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
        }
    }
}

// 單人模式視圖
struct SingleModeView: View {
    var body: some View {
        VStack(spacing: 25) {
            // 單一角色頭像
            CharacterAvatar()
                .padding(.top, 20)
            
            // 兩個按鈕
            VStack(spacing: 15) {
                Button(action: {
                    // 精選推角色的動作
                }) {
                    Text("精選推角色")
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                
                Button(action: {
                    // 精選推第1梯格的動作
                }) {
                    Text("精選推第1梯格")
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
        }
    }
}

// 角色頭像視圖
struct CharacterAvatar: View {
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.5))
            .frame(width: 100, height: 100)
            .overlay(
                VStack(spacing: 4) {
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 4, height: 4)
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: 4, height: 4)
                    }
                }
                .offset(y: -10)
            )
    }
}

// NavigationState 類 - 保留但不重新定義，使用已有的類
// 如果您的應用程序中已經有此類，可以注釋或刪除這個定義
/*
class NavigationState: ObservableObject {
    @Published var currentPage: Int = 0
    
    func goToPreviousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    func goToNextPage() {
        currentPage += 1
    }
}
*/

// 預覽
struct CharacterSetupView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterSetupView(navigationState: NavigationState())
            .preferredColorScheme(.dark)
    }
}
