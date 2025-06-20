//
//  LoginScreen.swift
//  AIPodcast01
//
//  Created by swimchichen on 2025/6/20.
//

import SwiftUI

struct LoginScreen: View {
    @State private var showLoginView = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ... (其他程式碼保持不變)
                Color.black.ignoresSafeArea()

                Circle()
                    .fill(Color(red: 0.85, green: 0.31, blue: 0.18))
                    .frame(width: geo.size.width, height: geo.size.width)
                    .blur(radius: geo.size.width * 0.3)
                    .opacity(0.35)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height + (geo.size.width * 0.2)
                    )

                WaveView(size: geo.size.width)
                    .opacity(showLoginView ? 0 : 1)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height + (geo.size.width * 0.2)
                    )

                // 4. UI 介面
                VStack {
                    Text("copyright © Team NewsTune & Yuniverses 2025")
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.8))
                        .padding(.top, 16)

                    Spacer()

                    // 🔥 修改點：更新字體樣式
                    VStack(spacing: 8) {
                        Text("NewsTune")
                            // 使用 .system 來呼叫 SF Pro 是最標準的做法
                            .font(.system(size: 29.08719, weight: .bold))

                        Text("回應你獨有的好奇。")
                            // 注意：您必須將 "Inter" 字體檔加入專案才能正常顯示
                            .font(Font.custom("Inter", size: 16.33333))
                    }
                    .foregroundColor(.white)

                    Spacer()
                    
                    LoginView()
                        .opacity(showLoginView ? 1 : 0)
                        .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.7), value: showLoginView)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showLoginView = true
                }
            }
        }
    }
}

#Preview {
    LoginScreen()
}
