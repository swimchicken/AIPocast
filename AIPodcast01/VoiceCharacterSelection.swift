import SwiftUI

struct CharacterSetupView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var navigationState: NavigationState
    @State private var navigateToFinalSettingsSummary = false
    
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
                                    navigationState.dialogMode = mode
                                }) {
                                    Text(mode)
                                }
                            }
                        } label: {
                            HStack {
                                Text(navigationState.dialogMode)
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
                    if navigationState.dialogMode == "對話式" {
                        DialogModeView(navigationState: navigationState)
                    } else {
                        SingleModeView(navigationState: navigationState)
                    }
                    
                    Spacer()
                    
                    // 底部按鈕
                    HStack(spacing: 16) {
                        Button(action: {
                            print("返回 p41") // 調試信息
                            presentationMode.wrappedValue.dismiss()
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
                            print("前往 p43") // 調試信息
                            navigationState.goToNextPage()
                            navigateToFinalSettingsSummary = true
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
                
                // 導航到 p43
                NavigationLink(
                    destination: FinalSettingsSummary(navigationState: navigationState),
                    isActive: $navigateToFinalSettingsSummary
                ) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// 對話式模式視圖
struct DialogModeView: View {
    @ObservedObject var navigationState: NavigationState
    
    // 角色選項
    let characterOptions = ["SHIRO", "Chicken", "小明", "小美", "Alex"]
    let styleOptions = ["輕鬆", "反駁", "專業", "幽默", "嚴肅"]
    
    var body: some View {
        VStack(spacing: 50) {
            // 兩個角色頭像
            HStack(spacing: 30) {
                // 第一個頭像 - 根據角色1和風格1的選擇狀態決定顏色
                CharacterAvatar(
                    backgroundColor: (navigationState.reader1Name != "請選擇角色" && navigationState.reader1Style != "請選擇風格") ? .white : Color.gray.opacity(0.3)
                )
                
                // 第二個頭像 - 根據角色2和風格2的選擇狀態決定顏色
                CharacterAvatar(
                    backgroundColor: (navigationState.reader2Name != "請選擇角色" && navigationState.reader2Style != "請選擇風格") ? .white : Color.gray.opacity(0.3)
                )
            }
            
            // 2x2 網格按鈕
            VStack(spacing: 12) {
                // 第一排 - 角色選擇
                HStack(spacing: 12) {
                    // 讀者1角色選擇
                    Menu {
                        ForEach(characterOptions, id: \.self) { character in
                            Button(action: {
                                navigationState.reader1Name = character
                            }) {
                                Text(character)
                            }
                        }
                    } label: {
                        Text(navigationState.reader1Name == "請選擇角色" ? "請選擇角色" : navigationState.reader1Name)
                            .foregroundColor(navigationState.reader1Name == "請選擇角色" ? .gray : .white)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15)
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    
                    // 讀者2角色選擇
                    Menu {
                        ForEach(characterOptions, id: \.self) { character in
                            Button(action: {
                                navigationState.reader2Name = character
                            }) {
                                Text(character)
                            }
                        }
                    } label: {
                        Text(navigationState.reader2Name == "請選擇角色" ? "請選擇角色" : navigationState.reader2Name)
                            .foregroundColor(navigationState.reader2Name == "請選擇角色" ? .gray : .white)
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15)
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
                
                // 第二排 - 風格選擇
                HStack(spacing: 12) {
                    // 讀者1風格選擇
                    Menu {
                        ForEach(styleOptions, id: \.self) { style in
                            Button(action: {
                                navigationState.reader1Style = style
                            }) {
                                Text(style)
                            }
                        }
                    } label: {
                        Text(navigationState.reader1Style == "請選擇風格" ? "請選擇 講者1風格" : "講者1風格：\(navigationState.reader1Style)")
                            .foregroundColor(navigationState.reader1Style == "請選擇風格" ? .gray : .white)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15)
                            .background(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    
                    // 讀者2風格選擇
                    Menu {
                        ForEach(styleOptions, id: \.self) { style in
                            Button(action: {
                                navigationState.reader2Style = style
                            }) {
                                Text(style)
                            }
                        }
                    } label: {
                        Text(navigationState.reader2Style == "請選擇風格" ? "請選擇 講者2風格" : "講者2風格：\(navigationState.reader2Style)")
                            .foregroundColor(navigationState.reader2Style == "請選擇風格" ? .gray : .white)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 15)
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
    @ObservedObject var navigationState: NavigationState
    
    // 角色選項
    let characterOptions = ["SHIRO", "Chicken", "小明", "小美", "Alex"]
    let styleOptions = ["輕鬆", "專業", "幽默", "嚴肅", "學術"]
    
    var body: some View {
        VStack(spacing: 50) {
            // 單一角色頭像 - 根據角色1和風格1的選擇狀態決定顏色
            CharacterAvatar(
                backgroundColor: (navigationState.reader1Name != "請選擇角色" && navigationState.reader1Style != "請選擇風格") ? .white : Color.gray.opacity(0.3)
            )
            .scaleEffect(1.2)
            
            // 兩個按鈕
            VStack(spacing: 12) {
                // 角色選擇
                Menu {
                    ForEach(characterOptions, id: \.self) { character in
                        Button(action: {
                            navigationState.reader1Name = character
                        }) {
                            Text(character)
                        }
                    }
                } label: {
                    Text(navigationState.reader1Name == "請選擇角色" ? "請選擇角色" : navigationState.reader1Name)
                        .foregroundColor(navigationState.reader1Name == "請選擇角色" ? .gray : .white)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 15)
                        .background(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                
                // 風格選擇
                Menu {
                    ForEach(styleOptions, id: \.self) { style in
                        Button(action: {
                            navigationState.reader1Style = style
                        }) {
                            Text(style)
                        }
                    }
                } label: {
                    Text(navigationState.reader1Style == "請選擇風格" ? "請選擇 講者1風格" : "講者1風格：\(navigationState.reader1Style)")
                        .foregroundColor(navigationState.reader1Style == "請選擇風格" ? .gray : .white)
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 15)
                        .background(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// 角色頭像視圖 - 新增背景顏色參數
struct CharacterAvatar: View {
    var backgroundColor: Color = Color.gray.opacity(0.3)
    
    var body: some View {
        Circle()
            .fill(backgroundColor)
            .frame(width: 150, height: 150)
            .overlay(
                // 簡單的臉部特徵
                VStack(spacing: 20) {
                    // 眼睛 - 根據背景顏色調整眼睛顏色
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
