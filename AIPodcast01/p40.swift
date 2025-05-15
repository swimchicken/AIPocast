//
//  p40.swift
//  AIPodcast01
//
//  Created by AI Assistant on 2025/5/10.
//

import SwiftUI

struct NewsCategory: Identifiable, Hashable {
    let id = UUID()
    var text: String
    var isSelected: Bool = false
}

struct NewsItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var source: String
    var time: Int
    var category: String
    var isLiked: Bool = false
}

// 用於在 View 之間傳遞數據和導航的環境對象
class NavigationState: ObservableObject {
    @Published var currentPage: Int = 1
    @Published var selectedNewsItems: [NewsItem] = []
    
    func goToNextPage() {
        currentPage += 1
    }
    
    func goToPreviousPage() {
        if currentPage > 1 {
            currentPage -= 1
        }
    }
}

struct p40: View {
    @StateObject private var navigationState = NavigationState()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToNextScreen = false
    
    // 最大可選擇的新聞數量
    private let maxSelectionCount = 20
    
    @State private var categories: [NewsCategory] = [
        NewsCategory(text: "國際"),
        NewsCategory(text: "中國", isSelected: true),
        NewsCategory(text: "緩"),
        NewsCategory(text: "經濟廣面"),
        NewsCategory(text: "生活日常")
    ]
    
    // 關注點也使用 NewsCategory 結構體，以支持選取功能
    @State private var focusPoints: [NewsCategory] = [
        NewsCategory(text: "政治"),
        NewsCategory(text: "科技"),
        NewsCategory(text: "教育"),
        NewsCategory(text: "環保"),
        NewsCategory(text: "體育")
    ]
    
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
        categories.filter { $0.isSelected }
    }
    
    // 已選擇的關注點
    var selectedFocusPoints: [NewsCategory] {
        focusPoints.filter { $0.isSelected }
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
                
                VStack(alignment: .leading, spacing: 5) {
                    // Title
                    Text("以下為根據調查所關對的新聞")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    
                    Text("請標註你喜歡的新聞")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold))
                    
                    // 主題標籤和關注點並排放置
                    HStack(spacing: 12) {
                        // 主題標籤區塊 - 可左右滑動
                        VStack(alignment: .leading, spacing: 4) {
                            Text("主題標籤")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 14))
                            
                            // 可滑動的主題標籤
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach($categories) { $category in
                                        Button(action: {
                                            // 切換分類標籤選中狀態
                                            category.isSelected.toggle()
                                        }) {
                                            Text(category.text)
                                                .foregroundColor(.white)
                                                .font(.system(size: 14, weight: .medium))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(
                                                    category.isSelected ?
                                                    Color.orange : Color.black.opacity(0.2)
                                                )
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        
                        // 關注點區塊 - 可左右滑動和選取
                        VStack(alignment: .leading, spacing: 4) {
                            Text("關注點")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 14))
                            
                            // 可滑動的關注點標籤，現在可以選取
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach($focusPoints) { $focusPoint in
                                        Button(action: {
                                            // 切換關注點標籤選中狀態
                                            focusPoint.isSelected.toggle()
                                        }) {
                                            Text(focusPoint.text)
                                                .foregroundColor(.white)
                                                .font(.system(size: 14, weight: .medium))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(
                                                    focusPoint.isSelected ?
                                                    Color.orange : Color.black.opacity(0.2)
                                                )
                                                .cornerRadius(8)
                                        }
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
                            Image(systemName: "heart.fill")
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
                        VStack(spacing: 12) {
                            ForEach(filteredNews) { item in
                                NewsItemRow(
                                    newsItem: $newsItems[newsItems.firstIndex(where: { $0.id == item.id })!],
                                    onDelete: { deleteNewsItem(item) },
                                    maxSelectionCount: maxSelectionCount,
                                    currentCount: likedNewsCount
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Bottom buttons
                HStack {
                    Button(action: {
                        // 返回上一頁
                        navigationState.goToPreviousPage()
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
                            // 將喜歡的新聞保存到導航狀態
                            navigationState.selectedNewsItems = newsItems.filter { $0.isLiked }
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
                        .background(Color.orange)
                        .cornerRadius(32)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            
            // 導航鏈接（實際應用中會連接到下一個頁面）
            NavigationLink(
                destination: Text("下一頁 - 已選擇 \(likedNewsCount) 則新聞")
                    .foregroundColor(.white)
                    .padding(),
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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(newsItem.source)
                            .foregroundColor(.orange)
                            .font(.system(size: 12, weight: .medium))
                        Text("# \(newsItem.time)分 #")
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 12))
                        Text(newsItem.category)
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 12))
                    }
                    Text(newsItem.title)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.trailing, 8)
                
                HStack(spacing: 8) {
                    Button(action: {
                        // 執行刪除操作
                        onDelete()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                    
                    Button(action: {
                        // 檢查是否超出最大選擇數量
                        if !newsItem.isLiked && currentCount >= maxSelectionCount {
                            // 如果已經達到最大選擇數量，不允許再選擇
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.warning)
                        } else {
                            // 切換喜歡狀態
                            newsItem.isLiked.toggle()
                            
                            // 添加觸覺反饋
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                        }
                    }) {
                        Image(systemName: newsItem.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(newsItem.isLiked ? .red : .gray)
                            .font(.system(size: 16))
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(Color.gray.opacity(0.08))
            .cornerRadius(12)
        }
    }
}

struct NewsDetailView: View {
    var newsItems: [NewsItem]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                Text("已選擇的新聞")
                    .foregroundColor(.white)
                    .font(.system(size: 28, weight: .bold))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(newsItems) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.title)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold))
                                
                                HStack {
                                    Text(item.source)
                                        .foregroundColor(.orange)
                                    Text("• \(item.category)")
                                        .foregroundColor(.gray)
                                }
                                .font(.system(size: 14))
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    p40()
}
