//
//  LoginView.swift
//  AIPodcast01
//
//  Created by swimchichen on 2025/6/20.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        // 🔥 修改點：我們不再使用 ZStack，而是直接對 VStack 套用背景
        // 這樣 VStack 會自動計算內容所需的高度，再通過 padding 控制留白
        // 从而实现“刚刚好”的卡片高度
        VStack(spacing: 16) {
            // Google 登入按鈕
            LoginButton(icon: .asset("Google"), text: "Continue with Google") {
                print("Google Tapped")
            }
            
            // Apple 登入按鈕
            LoginButton(icon: .system("apple.logo"), text: "Continue with Apple") {
                print("Apple Tapped")
            }
            
            // Email 登入按鈕
            LoginButton(icon: .system("envelope.fill"), text: "Continue with Email") {
                print("Email Tapped")
            }
        }
        .padding(20) // 卡片內部，按鈕與卡片邊緣的距離
        .background(Color.white.opacity(0.08)) // 卡片的背景顏色
        .cornerRadius(36) // 卡片的圓角
        .padding(.horizontal, 20) // 卡片外部，與螢幕兩側的距離
    }
}


// MARK: - 可重複使用的按鈕組件 (維持上一版的精準樣式)

enum IconType {
    case system(String)
    case asset(String)
}

struct LoginButton: View {
    let icon: IconType
    let text: String
    let action: () -> Void
    
    // 按鈕本身的背景顏色
    private let buttonBackgroundColor = Color(red: 0.2, green: 0.15, blue: 0.15).opacity(0.8)

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                switch icon {
                case .system(let name):
                    Image(systemName: name)
                        .font(.title3)
                        .frame(width: 22, height: 22)
                        .foregroundColor(.white)
                case .asset(let name):
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                }
                
                Text(text)
                    .font(Font.custom("Inter", size: 16).weight(.semibold))
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(buttonBackgroundColor)
            .foregroundColor(Color(red: 0.94, green: 0.94, blue: 0.94))
            .cornerRadius(16)
        }
    }
}


// MARK: - 預覽

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LoginView()
    }
}
