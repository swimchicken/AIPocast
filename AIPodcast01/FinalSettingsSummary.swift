import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct FinalSettingsSummary: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var navigationState: NavigationState
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar - 全部完成
                HStack(spacing: 5) {
                    // 全部填滿的進度條
                    ForEach(0..<4) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "FF6200"))
                            .frame(height: 10)
                            .frame(maxWidth: .infinity)
                    }
                    
                    // 最右側帶勾號的圓圈，現在也是橘色
                    ZStack {
                        Circle()
                            .fill(Color(hex: "FF6200"))
                            .frame(width: 16, height: 16)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                // 標題區域
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("What do you want to accomplish at")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        Image(systemName: "sparkles")
                            .foregroundColor(.white)
                    }
                    
                    Text("最後一步")
                        .foregroundColor(.white)
                        .font(.system(size: 36, weight: .bold))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // 滾動內容區域
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // 主題標籤 - 顯示所有標籤
                        if !navigationState.categories.isEmpty {
                            SummaryTagSection(
                                title: "主題標籤",
                                items: navigationState.categories.map { $0.text }
                            )
                        }
                        
                        // 關注點 - 顯示所有標籤
                        if !navigationState.focusPoints.isEmpty {
                            SummaryTagSection(
                                title: "關注點",
                                items: navigationState.focusPoints.map { $0.text }
                            )
                        }
                        
                        // 選中的新聞數量
                        if !navigationState.selectedNewsItems.isEmpty {
                            SummaryBlockSection(
                                title: "已選新聞",
                                content: "已選擇 \(navigationState.selectedNewsItems.count) 則新聞"
                            )
                        }
                        
                        // 內容時長 - 使用真實數據
                        SummaryBlockSection(
                            title: "內容時長",
                            content: navigationState.contentDuration
                        )
                        
                        // 對話模式 - 使用真實數據
                        SummaryBlockSection(
                            title: "對話模式",
                            content: navigationState.dialogMode
                        )
                        
                        // 讀者設定 - 使用真實數據（四小塊並列，重新排序）
                        if navigationState.dialogMode == "對話式" {
                            SummaryReaderBlockSection(
                                reader1Name: navigationState.reader1Name,
                                reader1Style: navigationState.reader1Style,
                                reader2Name: navigationState.reader2Name,
                                reader2Style: navigationState.reader2Style
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // 為底部按鈕留空間
                }
                
                Spacer()
                
                // 底部按鈕
                HStack(spacing: 16) {
                    Button(action: {
                        print("返回 VoiceCharacterSelection") // 調試信息
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
                        // 完成設定，可能導航到主頁面或開始生成內容
                        navigationState.goToNextPage()
                    }) {
                        HStack(spacing: 8) {
                            Text("完成")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            
                            Image(systemName: "checkmark")
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
        .navigationBarHidden(true)
    }
}

// 新的總結標籤區塊組件（僅用於主題標籤和關注點）
struct SummaryTagSection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 11))
            
            // 可滑動的標籤
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

// 帶灰匡的文字顯示組件
struct SummaryBlockSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 11))
            
            Text(content)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

// 帶灰匡的時間設定組件
struct SummaryTimeBlockSection: View {
    let title: String
    let time: String
    let frequency: String
    let selectedDays: [String]
    let showDays: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 11))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("時間：\(time)")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
                
                if showDays {
                    Text("星期：\(selectedDays.joined(separator: ", "))")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                }
                
                Text("頻率：\(frequency)")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 6)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

// 帶灰匡的讀者設定組件（四個獨立的灰色大block，調整位置）
struct SummaryReaderBlockSection: View {
    let reader1Name: String
    let reader1Style: String
    let reader2Name: String
    let reader2Style: String
    
    var body: some View {
        VStack(spacing: 10) {
            // 第一排：讀者1 | 讀者1風格
            HStack(spacing: 8) {
                // 讀者1 block
                VStack(alignment: .leading, spacing: 7) {
                    Text("讀者1")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 11))
                    
                    Text(reader1Name)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                // 讀者1風格 block
                VStack(alignment: .leading, spacing: 7) {
                    Text("讀者1風格")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 11))
                    
                    Text(reader1Style)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            // 第二排：讀者2 | 讀者2風格
            HStack(spacing: 8) {
                // 讀者2 block
                VStack(alignment: .leading, spacing: 7) {
                    Text("讀者2")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 11))
                    
                    Text(reader2Name)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                // 讀者2風格 block
                VStack(alignment: .leading, spacing: 7) {
                    Text("讀者2風格")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 11))
                    
                    Text(reader2Style)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
    }
}

#Preview {
    FinalSettingsSummary(navigationState: NavigationState())
        .preferredColorScheme(.dark)
}
