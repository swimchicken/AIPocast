import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct news＿source＿selection: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var navigationState = NavigationState()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToNextScreen = false
    
    // 最大可選擇的新聞數量
    private let maxSelectionCount = 20
    
    @State private var newsItems: [NewsItem] = [
        NewsItem(title: "選龍法傳議案送出！政院盼立院受過回應各界訴求", source: "聯合報", time: 45, category: "台灣", isLiked: false),
        NewsItem(title: "中國人工智慧應用新熱點：人形機器人成為發展新戰場", source: "聯合報", time: 45, category: "台灣", isLiked: false),
        NewsItem(title: "AI 聖誕老人上線，線上互動新體驗", source: "新報", time: 66, category: "台灣", isLiked: false),
        NewsItem(title: "選龍法傳議案送出！政院盼立院受過回應各界訴求", source: "聯合報", time: 45, category: "台灣", isLiked: false),
        NewsItem(title: "中國人工智慧應用新熱點：人形機器人成為發展新戰場", source: "聯合報", time: 45, category: "台灣", isLiked: false),
        NewsItem(title: "AI 聖誕老人上線，線上互動新體驗", source: "新報", time: 66, category: "台灣", isLiked: false)
    ]
    
    // 已選擇的新聞數量
    var likedNewsCount: Int {
        newsItems.filter { $0.isLiked }.count
    }
    
    // 已選擇的分類標籤
    var selectedCategories: [NewsCategory] {
        navigationState.categories.filter { $0.isSelected }
    }
    
    // 已選擇的關注點
    var selectedFocusPoints: [NewsCategory] {
        navigationState.focusPoints.filter { $0.isSelected }
    }
    
    // 根據選擇的分類和關注點篩選新聞
    var filteredNews: [NewsItem] {
        if selectedCategories.isEmpty && selectedFocusPoints.isEmpty {
            return newsItems
        } else {
            // 實際應用中，這裡可以根據選擇的分類和關注點進行篩選
            // 這裡簡單返回所有新聞
            return newsItems
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
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
                        .stroke(Color(hex: "FF6200"), lineWidth: 1.5)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 10)
                        .frame(maxWidth: .infinity)
                        
                    
                    RoundedRectangle(cornerRadius: 8)
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
                .padding(.top, 30)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                VStack(alignment: .leading, spacing: 5) {
                    // Title
                    Text("以下為根據調查所關對的新聞")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    
                    Text("請標註你喜歡的新聞")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold))
                    
                    // 主題標籤和關注點並排放置
                    HStack(spacing: 7) {
                        // 主題標籤區塊 - 可左右滑動（改為純展示）
                        VStack(alignment: .leading, spacing: 7) {
                            Text("主題標籤")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 11))
                            
                            // 可滑動的主題標籤（純展示）
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(navigationState.categories) { category in
                                        Text(category.text)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .medium))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 8)
                                            .background(
                                                category.isSelected ?
                                                Color(hex: "FF6200") : Color.gray.opacity(0.3)
                                            )
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        
                        // 關注點區塊 - 可左右滑動（改為純展示）
                        VStack(alignment: .leading, spacing: 7) {
                            Text("關注點")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 11))
                            
                            // 可滑動的關注點標籤（純展示）
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(navigationState.focusPoints) { focusPoint in
                                        Text(focusPoint.text)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .medium))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 8)
                                            .background(
                                                focusPoint.isSelected ?
                                                Color(hex: "FF6200") : Color.gray.opacity(0.3)
                                            )
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    
                    // 分段進度條顯示已選擇的新聞數量
                    HStack(spacing: 4) {
                        // 使用 HStack 顯示 20 個小方塊，每個代表一個可選的新聞
                        HStack(spacing: 0) {
                            ForEach(0..<maxSelectionCount, id: \.self) { index in
                                // 如果索引小於已選擇的數量，顯示紅色，否則顯示灰色
                                Rectangle()
                                    .fill(index < likedNewsCount ? Color.red : Color.gray.opacity(0.3))
                                    .frame(height: 4)
                            }
                        }
                        
                        Spacer()
                        
                        // 顯示 "02/20" 格式的計數
                        HStack(spacing: 2) {
                            Image(systemName: "heart")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                            
                            Text(String(format: "%02d/%02d", likedNewsCount, maxSelectionCount))
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 12))
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    // News List
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(filteredNews) { item in
                                NewsItemRow(
                                    newsItem: $newsItems[newsItems.firstIndex(where: { $0.id == item.id })!],
                                    onDelete: { deleteNewsItem(item) },
                                    maxSelectionCount: maxSelectionCount,
                                    currentCount: likedNewsCount
                                )
                                .fixedSize(horizontal: false, vertical: true) // 允許高度自適應
                            }
                        }
                        .padding(.bottom, 8) // 底部間距
                    }
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                // Bottom buttons
                HStack {
                    Button(action: {
                        // 返回 ContentView
                        print("回到 ContentView") // 調試信息
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("回上一步")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.vertical, 18)
                            .padding(.horizontal, 24)
                    }
                    Spacer()
                    Button(action: {
                        // 檢查是否有選擇的新聞，如果有則進入下一頁
                        if likedNewsCount > 0 {
                            // 保存選中的新聞
                            navigationState.selectedNewsItems = newsItems.filter { $0.isLiked }
                            
                            // 保存選中的主題標籤
                            navigationState.selectedCategories = navigationState.categories
                            
                            // 保存選中的關注點
                            navigationState.selectedFocusPoints = navigationState.focusPoints
                            
                            print("前往 PushTimeAndPermission") // 調試信息
                            navigationState.goToNextPage()
                            navigateToNextScreen = true
                        } else {
                            // 顯示提示，要求選擇至少一則新聞
                            alertMessage = "請至少選擇一則你喜歡的新聞"
                            showAlert = true
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text("下一步")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 48)
                        .background(Color(hex: "FF6200"))
                        .cornerRadius(32)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            
            // 導航到 p41
            NavigationLink(
                destination: FocusPointView(navigationState: navigationState),
                isActive: $navigateToNextScreen
            ) {
                EmptyView()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("提示"),
                message: Text(alertMessage),
                dismissButton: .default(Text("確定"))
            )
        }
        .navigationBarHidden(true)
    }
    
    // 刪除新聞項目
    func deleteNewsItem(_ item: NewsItem) {
        if let index = newsItems.firstIndex(where: { $0.id == item.id }) {
            newsItems.remove(at: index)
        }
    }
}

struct NewsItemRow: View {
    @Binding var newsItem: NewsItem
    var onDelete: () -> Void
    var maxSelectionCount: Int
    var currentCount: Int
    
    // 獲取帶有#的標籤
    var hashTags: [String] {
        // 根據實際需求返回帶有#的標籤
        return ["#政治", "#\(newsItem.category)"]
    }
    
    var body: some View {
        // 使用 ZStack 確保內容能夠擴展到完整大小
        ZStack {
            // 背景
            Color.gray.opacity(0.08)
                .cornerRadius(12)
            
            // 內容區塊
            HStack(spacing: 0) {
                // 左側內容區域
                VStack(alignment: .leading, spacing: 6) {
                    // 標籤部分
                    HStack(spacing: 6) {
                        // 來源標籤
                        Text(newsItem.source)
                            .foregroundColor(Color(hex: "FF6200"))
                            .font(.system(size: 12, weight: .medium))
                        
                        // 帶#的標籤
                        ForEach(hashTags, id: \.self) { tag in
                            Text(tag)
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "FF6200").opacity(0.3))
                                .cornerRadius(4)
                        }
                    }
                    
                    // 新聞標題 - 保持原有字體大小且確保完整顯示
                    Text(newsItem.title)
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                        .lineLimit(3) // 增加行數限制，確保較長標題也能顯示
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true) // 允許垂直擴展以完整顯示
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                
                Spacer()
                
                // 右側按鈕區域 - 垂直居中
                HStack(spacing: 8) {
                    // 關閉按鈕
                    Button(action: {
                        onDelete()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                    }
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                    
                    // 喜歡按鈕
                    Button(action: {
                        if !newsItem.isLiked && currentCount >= maxSelectionCount {
                            #if os(iOS)
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.warning)
                            #endif
                        } else {
                            newsItem.isLiked.toggle()
                            #if os(iOS)
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            #endif
                        }
                    }) {
                        Image(systemName: newsItem.isLiked ? "heart" : "heart")
                            .foregroundColor(newsItem.isLiked ? .red : .gray)
                            .font(.system(size: 20))
                    }
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                }
                .padding(.trailing, 16)
            }
            .frame(maxWidth: .infinity)
        }
        .fixedSize(horizontal: false, vertical: true) // 允許行高根據內容自動調整
    }
}

struct news＿source＿selection_Previews: PreviewProvider {
    static var previews: some View {
        news＿source＿selection()
            .preferredColorScheme(.dark)
    }
}
