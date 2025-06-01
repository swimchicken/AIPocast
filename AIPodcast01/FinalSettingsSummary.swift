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
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // 主題標籤 - 使用真實數據
                        if !navigationState.selectedCategoryNames.isEmpty {
                            SummarySection(title: "主題標籤") {
                                FlowLayout(items: navigationState.selectedCategoryNames, spacing: 8) { topic in
                                    TagView(text: topic, isSelected: true)
                                }
                            }
                        }
                        
                        // 關注點 - 使用真實數據
                        if !navigationState.selectedFocusPointNames.isEmpty {
                            SummarySection(title: "關注點") {
                                FlowLayout(items: navigationState.selectedFocusPointNames, spacing: 8) { point in
                                    TagView(text: point, isSelected: true)
                                }
                            }
                        }
                        
                        // 選中的新聞數量
                        if !navigationState.selectedNewsItems.isEmpty {
                            SummarySection(title: "已選新聞") {
                                Text("已選擇 \(navigationState.selectedNewsItems.count) 則新聞")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // 內容時長 - 使用真實數據
                        SummarySection(title: "內容時長") {
                            Text(navigationState.contentDuration)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                        
                        // 類型選擇
                        SummarySection(title: "類型") {
                            Text(navigationState.selectedType)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                        
                        // 時間設定
                        SummarySection(title: "時間") {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("時間：\(navigationState.formattedTime)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                
                                if !navigationState.selectedDays.isEmpty {
                                    Text("星期：\(navigationState.selectedDayNames.joined(separator: ", "))")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                }
                                
                                Text("頻率：\(navigationState.frequency)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                        }
                        
                        // 對話模式 - 使用真實數據
                        SummarySection(title: "對話模式") {
                            Text(navigationState.dialogMode)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                        
                        // 讀者設定 - 使用真實數據
                        if navigationState.dialogMode == "對話式" {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("讀者1")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                    
                                    VStack(spacing: 8) {
                                        ReaderInfoView(name: navigationState.reader1Name)
                                        ReaderInfoView(name: navigationState.reader1Style)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("讀者2")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                    
                                    VStack(spacing: 8) {
                                        ReaderInfoView(name: navigationState.reader2Name)
                                        ReaderInfoView(name: navigationState.reader2Style)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
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

// 總結區塊組件
struct SummarySection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(.horizontal, 20)
            
            content
                .padding(.horizontal, 20)
        }
    }
}

// 標籤視圖
struct TagView: View {
    let text: String
    let isSelected: Bool
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.system(size: 14, weight: .medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.gray.opacity(0.3) : Color.clear)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
}

// 讀者資訊視圖
struct ReaderInfoView: View {
    let name: String
    
    var body: some View {
        Text(name)
            .foregroundColor(.white)
            .font(.system(size: 16))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)
    }
}

// 流式佈局組件
struct FlowLayout<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: spacing) {
            let chunkedItems = items.chunked(into: calculateItemsPerRow())
            ForEach(Array(chunkedItems.enumerated()), id: \.offset) { _, chunk in
                HStack(spacing: spacing) {
                    ForEach(Array(chunk), id: \.self) { item in
                        content(item)
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func calculateItemsPerRow() -> Int {
        // 簡單的計算，實際項目中可能需要更複雜的邏輯
        return 3
    }
}

// Collection extension 用於分塊
extension Collection {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: Swift.min($0 + size, count))])
        }
    }
}

#Preview {
    FinalSettingsSummary(navigationState: NavigationState())
        .preferredColorScheme(.dark)
}
