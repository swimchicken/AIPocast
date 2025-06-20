//
//  AIPodcast01App.swift
//  AIPodcast01
//
//  Created by swimchichen on 2025/5/2.
//

import SwiftUI
import FirebaseCore // 1. 導入 Firebase 核心

// 2. 建立 AppDelegate 來設定 Firebase
//    這是讓 Firebase 在 App 一啟動時就完成配置的標準做法
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct AIPodcast01App: App {
    // 3. 使用 @UIApplicationDelegateAdaptor 來注入您剛剛建立的 AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
      @StateObject private var authViewModel = AuthViewModel() // 建立 ViewModel 實例

      var body: some Scene {
        WindowGroup {
          // 根據登入狀態決定顯示哪個畫面
          if authViewModel.userSession != nil {
              // 如果已登入，顯示主畫面 (HomeScreen)
              // Text("Welcome! You are logged in.").font(.largeTitle) // 暫用文字替代
              //   .onTapGesture { authViewModel.signOut() }
              ContentView() // 假設您有一個 HomeScreen
                  .environmentObject(authViewModel) // 將 ViewModel 傳下去
          } else {
              // 如果未登入，顯示登入畫面
              LoginScreen()
                  .environmentObject(authViewModel) // 將 ViewModel 傳下去
          }
        }
      }
}
