// AuthViewModel.swift
import SwiftUI
import FirebaseAuth
import GoogleSignIn

@MainActor // 確保所有 UI 更新都在主線程
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?

    init() {
        // 在 ViewModel 初始化時，就開始監聽登入狀態的變化
        self.userSession = Auth.auth().currentUser
    }

    // --- Google 登入 ---
    func signInWithGoogle() async -> Bool {
        // 1. 取得頂層視窗
        guard let topVC = await UIApplication.shared.keyWindow?.rootViewController else { return false }

        // 2. 透過 Google SDK 取得認證結果
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
            guard let idToken = result.user.idToken?.tokenString else {
                print("Could not get ID token from Google")
                return false
            }

            // 3. 用 Google 的 Token 向 Firebase 換取認證
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: result.user.accessToken.tokenString)

            // 4. 使用 Firebase 登入
            let firebaseResult = try await Auth.auth().signIn(with: credential)
            self.userSession = firebaseResult.user // 更新登入狀態
            print("Successfully signed in with Google: \(firebaseResult.user.uid)")
            return true

        } catch {
            print("Error signing in with Google: \(error.localizedDescription)")
            return false
        }
    }

    // --- Apple 登入 (簡化版，詳細需要 Helper) ---
    func signInWithApple() async -> Bool {
        // Apple 登入流程較複雜，需要一個輔助類來處理 Nonce 等加密事務
        // 這裡只寫出最終登入 Firebase 的部分
        // let credential = ... (從 Apple 登入結果中獲取)
        // do {
        //   let result = try await Auth.auth().signIn(with: credential)
        //   self.userSession = result.user
        //   return true
        // } catch { ... }
        print("Apple Sign In needs a helper class for nonce generation.")
        return false // 暫時返回 false
    }

    // --- Email 登入 ---
    func signInWithEmail(email: String, password: String) async -> Bool {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            print("Successfully signed in with Email: \(result.user.uid)")
            return true
        } catch {
            print("Error signing in with Email: \(error.localizedDescription)")
            return false
        }
    }

    // --- 登出 ---
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
