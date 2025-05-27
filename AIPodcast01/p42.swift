import SwiftUI

#if canImport(UIKit)
import UIKit
#endif


struct CharacterSetupView: View {
    @ObservedObject var navigationState: NavigationState
    @State private var selectedMode: String = "對話式"
    
    let modes = ["對話式", "單人"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Progress bar
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
                            .fill(Color(hex: "FF6200"))
                            .frame(height: 10)
                            .frame(maxWidth: .infinity)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "FF6200"), lineWidth: 1.5)
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
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 16)
                    
                    // 標題區域
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("What do you want to accomplish at")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            // 方塊圖標
                            Image(systemName: "square.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                        
                        Text("角色")
                            .foregroundColor(.white)
                            .font(.system(size: 36, weight: .bold))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // 模式選擇區域
                    ZStack(alignment: .topLeading) {
                        // 下拉選單
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
                                    .font(.system(size: 16))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        }
                        .menuStyle(.automatic)
                        
                        // 浮動在灰線上的文字標籤
                        Text("模式選擇")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .background(Color.black)
                            .offset(x: 10, y: -8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 127)
                    
                    // 主要內容區域
                    if selectedMode == "對話式" {
                        DialogModeView()
                    } else {
                        SingleModeView()
                    }
                    
                    Spacer()
                    
                    // 底部按鈕
                    HStack(spacing: 16) {
                        Button(action: {
                            navigationState.goToPreviousPage()
                        }) {
                            Text("回上一步")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            navigationState.currentPage = 42
                            navigationState.goToNextPage()
                        }) {
                            HStack(spacing: 8) {
                                Text("下一步")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "FF6200"))
                            .cornerRadius(25)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

// 對話式模式視圖
struct DialogModeView: View {
    var body: some View {
        VStack(spacing: 50) {
            // 兩個角色頭像
            HStack(spacing: 30) {
                ForEach(0..<2) { _ in
                    CharacterAvatar()
                }
            }
            
            // 2x2 網格按鈕
            VStack(spacing: 12) {
                // 第一排
                HStack(spacing: 12) {
                    Button(action: {
                        // 按鈕動作
                    }) {
                        Text("請選擇角色")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15) // 增加到 24，讓左邊有更多空間
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        // 按鈕動作
                    }) {
                        Text("請選擇角色")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15) // 增加到 24，讓左邊有更多空間
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
                
                // 第二排
                HStack(spacing: 12) {
                    Button(action: {
                        // 按鈕動作
                    }) {
                        Text("請選擇 講者1風格")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15) // 增加到 24，讓左邊有更多空間
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        // 按鈕動作
                    }) {
                        Text("請選擇 講者2風格")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15) // 增加到 24，讓左邊有更多空間
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// 單人模式視圖
struct SingleModeView: View {
    var body: some View {
        VStack(spacing: 50) {
            // 單一角色頭像
            CharacterAvatar()
                .scaleEffect(1.2)
            
            // 兩個按鈕
            VStack(spacing: 12) {
                ForEach(["請選擇角色", "請選擇 講者1風格"], id: \.self) { title in
                    Button(action: {
                        // 按鈕動作
                    }) {
                        Text(title)
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15) // 增加到 24，讓左邊有更多空間
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// 角色頭像視圖
struct CharacterAvatar: View {
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 150, height: 150)
            .overlay(
                // 簡單的臉部特徵
                VStack(spacing: 20) {
                    // 眼睛
                    HStack(spacing: 25) {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.black)
                            .frame(width: 15, height: 28)
                        
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.black)
                            .frame(width: 15, height: 28)
                    }
                    .offset(x: 20, y: 25)
                }
            )
    }
}




// 預覽
struct CharacterSetupView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterSetupView(navigationState: NavigationState())
            .preferredColorScheme(.dark)
    }
}
