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
    
    // p40 的選擇項目
    @Published var selectedNewsItems: [NewsItem] = []
    @Published var selectedCategories: [NewsCategory] = []
    @Published var selectedFocusPoints: [NewsCategory] = []
    
    // p41 的選擇項目（關注點相關）
    @Published var contentDuration: String = "標準時長 （10-20分鐘）"
    @Published var selectedType: String = "routine"
    @Published var selectedHour: Int = 8
    @Published var selectedMinute: Int = 0
    @Published var selectedAmPm: String = "PM"
    @Published var selectedDays: Set<Int> = [0]
    @Published var frequency: String = "每週"
    @Published var duration2: String = "無"
    
    // p42 的選擇項目（角色設定）
    @Published var dialogMode: String = "對話式"
    @Published var reader1Name: String = "請選擇角色"
    @Published var reader1Style: String = "請選擇風格"
    @Published var reader2Name: String = "請選擇角色"
    @Published var reader2Style: String = "請選擇風格"
    
    func goToNextPage() {
        currentPage += 1
    }
    
    func goToPreviousPage() {
        if currentPage > 1 {
            currentPage -= 1
        }
    }
    
    // 便利方法來取得選中的分類名稱
    var selectedCategoryNames: [String] {
        return selectedCategories.filter { $0.isSelected }.map { $0.text }
    }
    
    // 便利方法來取得選中的關注點名稱
    var selectedFocusPointNames: [String] {
        return selectedFocusPoints.filter { $0.isSelected }.map { $0.text }
    }
    
    // 便利方法來取得選中的星期
    var selectedDayNames: [String] {
        let dayLabels = ["一", "二", "三", "四", "五", "六", "日"]
        return selectedDays.compactMap { dayLabels[$0] }
    }
    
    // 便利方法來取得完整的時間字串
    var formattedTime: String {
        return "\(selectedHour):\(String(format: "%02d", selectedMinute)) \(selectedAmPm)"
    }
}
