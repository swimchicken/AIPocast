import SwiftUI

struct NewsItem2: Identifiable {
    let id = UUID()
    let title: String
    let source: String
    let time: Date
    let category: String
    let category2: String
    let imageUrl: String  // 新增圖片URL屬性
    var isLiked: Bool
}

// 需要在 struct 外部定義 DateFormatter
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}()

struct NewsHomeView: View {
    @State private var currentTime = Date()
    @State private var isCompactHeader = false
    @State private var showNewsImages = false // 新增控制圖片顯示的狀態
    
    @State private var newsItems: [NewsItem2] = [
        NewsItem2(
            title: "選舉法修議案送出！政院盼立院認真面對民眾訴求",
            source: "聯合報",
            time: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3, hour: 1, minute: 25))!,
            category: "政治",
            category2: "台灣",
            imageUrl: "https://picsum.photos/400/300?random=1", // 添加示例圖片
            isLiked: false
        ),
        NewsItem2(
            title: "奧特曼：OpenAI站在歷史錯誤一邊需思考開源策略",
            source: "中央社",
            time: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3, hour: 1, minute: 30))!,
            category: "美國",
            category2: "科技",
            imageUrl: "https://picsum.photos/400/300?random=2",
            isLiked: false
        ),
        NewsItem2(
            title: "AI 聖誕老人上線，線上互動新體驗",
            source: "udn",
            time: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3, hour: 2, minute: 0))!,
            category: "美國",
            category2: "科技",
            imageUrl: "https://picsum.photos/400/300?random=3",
            isLiked: false
        ),
        NewsItem2(
            title: "空難是早晚問題，華府空域宛如惡夢 前機師：幾乎犯錯餘地",
            source: "聯合報",
            time: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3, hour: 2, minute: 15))!,
            category: "美國",
            category2: "科技",
            imageUrl: "https://picsum.photos/400/300?random=4",
            isLiked: false
        ),
        NewsItem2(
            title: "中國人工智慧應用新熱點：人形機器人成為發展新戰場",
            source: "聯合報",
            time: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3, hour: 2, minute: 30))!,
            category: "美國",
            category2: "科技",
            imageUrl: "https://picsum.photos/400/300?random=5",
            isLiked: false
        ),
        NewsItem2(
            title: "AI 聖誕老人上線，線上互動新體驗",
            source: "新報",
            time: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3, hour: 3, minute: 0))!,
            category: "美國",
            category2: "科技",
            imageUrl: "https://picsum.photos/400/300?random=6",
            isLiked: false
        )
    ]
    
    var body: some View {
        ZStack {
            // 背景色
            Color.black
                .ignoresSafeArea()
            
            // 主要內容結構
            VStack(spacing: 0) {
                // 固定頂部：日期和溫度
                headerView
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                    .background(Color.black)
                    .zIndex(1)
                
                // 分隔線
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                
                // 可滾動內容
                ScrollView {
                    ZStack {
                        // 1. 底層：球形光暈 - 加入視差滾動效果
                        GeometryReader { geometry in
                            let scrollOffset = geometry.frame(in: .named("scroll")).minY
                            
                            // 檢測播放按鈕位置並更新頂部條狀態
                            let playButtonY = scrollOffset + 200
                            let threshold: CGFloat = 20
                            
                            // 檢測圖片顯示狀態 - 向下滾動超過100px時顯示圖片
                            let imageThreshold: CGFloat = -100
                            
                            Color.clear
                                .onChange(of: scrollOffset) { _, newValue in
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isCompactHeader = playButtonY <= threshold
                                        showNewsImages = newValue <= imageThreshold
                                    }
                                }
                            
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color.yellow.opacity(0.6),
                                            Color.yellow.opacity(0.5),
                                            Color.yellow.opacity(0.2),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 30,
                                        endRadius: 150
                                    )
                                )
                                .scaleEffect(x: 2.5, y: 1.3)
                                .position(
                                    x: geometry.size.width / 2 + 20,
                                    y: 110 + scrollOffset * 0.1
                                )
                            
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color.yellow.opacity(0.6),
                                            Color.yellow.opacity(0.5),
                                            Color.yellow.opacity(0.2),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 30,
                                        endRadius: 80
                                    )
                                )
                                .scaleEffect(x: 3, y: 1.8)
                                .position(
                                    x: geometry.size.width / 2 - 40,
                                    y: 170 + scrollOffset * 0.1
                                )
                        }
                        
                        // 2. 上層：黑色橢圓遮罩 - 加入視差滾動效果
                        GeometryReader { geometry in
                            let scrollOffset = geometry.frame(in: .named("scroll")).minY
                            
                            Ellipse()
                                .fill(Color.black)
                                .frame(width: geometry.size.width * 5, height: geometry.size.width * 3)
                                .position(
                                    x: geometry.size.width / 2 + 20,
                                    y: -330 + scrollOffset * 0.13
                                )
                        }
                        
                        // 內容區域
                        VStack(spacing: 20) {
                            // 主要新闻摘要卡片
                            mainNewsCard
                            
                            // 新闻列表
                            newsListView
                                .padding(.top, 30)
                                .padding(.bottom, 100)
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                    }
                }
                .coordinateSpace(name: "scroll")
                
                // 固定底部導航欄
                bottomNavigationView
            }
        }
        .onAppear {
            // 更新时间
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                currentTime = Date()
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            // 左側：日期和星期
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentTime, format: .dateTime.month(.abbreviated).day())
                        .font(isCompactHeader ? .title2 : .title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.3), value: isCompactHeader)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentTime, format: .dateTime.weekday(.wide))
                        .font(isCompactHeader ? .title2 : .title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .animation(.easeInOut(duration: 0.3), value: isCompactHeader)
                }
            }
            
            Spacer()
            
            // 右側：天氣和播放按鈕（緊湊模式時顯示）
            HStack(spacing: 12) {
                // 天氣小灰匡
                HStack(spacing: 4) {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.white)
                        .font(.caption)
                    Text("26°C")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 7)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(5)
                
                // 播放按鈕（緊湊模式時顯示）
                if isCompactHeader {
                    Button(action: {}) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .frame(width: 24, height: 24)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
    
    // MARK: - Bottom Navigation View
    private var bottomNavigationView: some View {
        HStack {
            // Today 按鈕 (固定橘色)
            bottomNavButton(
                icon: "house.fill",
                title: "Today",
                color: Color(hex: "FF6200")
            ) {
                // Today 按鈕動作
            }
            
            Spacer()
            
            // My Library 按鈕 (固定灰色)
            bottomNavButton(
                icon: "books.vertical.fill",
                title: "My Library",
                color: .gray
            ) {
                // My Library 按鈕動作
            }
            
            Spacer()
            
            // Create 按鈕 (特殊樣式)
            createButton (){
                // Create 按鈕動作
                
            }
            
            Spacer()
            
            // Live 按鈕 (固定灰色)
            bottomNavButton(
                icon: "dot.radiowaves.left.and.right",
                title: "Live",
                color: .gray
            ) {
                // Live 按鈕動作
            }
            
            Spacer()
            
            // Account 按鈕 (固定灰色)
            bottomNavButton(
                icon: "person.fill",
                title: "Account",
                color: .gray
            ) {
                // Account 按鈕動作
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, -14)
        .background(
            // 背景漸層效果
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .background(.ultraThinMaterial)
        )
        .overlay(
            // 頂部分隔線
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(height: 0),
            alignment: .top
        )
    }
    
    // MARK: - Bottom Navigation Button
    private func bottomNavButton(
        icon: String,
        title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 25))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(color)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Create Button (特殊圓形按鈕)
     private func createButton(action: @escaping () -> Void) -> some View {
         Button(action: action) {
             VStack(spacing: 4) {
                 Image(systemName: "plus")
                     .font(.system(size: 30, weight: .light))
                     .foregroundColor(.gray)
                     .frame(width: 65, height: 65)
                     .background(Color.black.opacity(0.4))
                     .clipShape(Circle())
                     .overlay(
                         Circle()
                             .stroke(Color.gray, lineWidth: 1.5)
                     )
                 
                 Text("Create")
                     .font(.caption2)
                     .foregroundColor(.gray)
             }
         }
         .buttonStyle(PlainButtonStyle())
         .offset(y: -19) // 調整 y 座標，讓按鈕稍微向上
     }
    
    // MARK: - Main News Card
    private var mainNewsCard: some View {
        VStack(alignment: .leading, spacing: 25) {
            // 问候语
            Text("早安！今日國際焦點圍繞俄烏衝突持續、美中競爭升溫、全球經濟面臨通脹挑戰與能源供應不穩的多重壓力 🔥")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, -24)
                .padding(.top, -25)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("工作日 早安新聞")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, -22)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text("8:00 AM")
                                .font(.caption2)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(8)
                        
                        
                        Text("#最新")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "FF6200").opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                        
                        Text("#焦點")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "FF6200").opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, -24)
                }
                
                Spacer()
                
                // 播放按钮
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 15))
                        Text("3:20")
                            .font(.system(size: 15))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    .cornerRadius(40)
                    .padding(.horizontal, -28)
                }
                .opacity(isCompactHeader ? 0.5 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isCompactHeader)
            }
        }
        .padding(22)
        .background(Color.clear)
    }
    
    // MARK: - News List View
    private var newsListView: some View {
        VStack(spacing: 16) {
            // 精选标题
            HStack(spacing: 0) {
                Button(action: {
                    // 精選按鈕動作
                }) {
                    Text("精選")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                               
                Button(action: {
                    // 設計按鈕動作
                }) {
                    Text("設計")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
                               
                Button(action: {
                    // 美國按鈕動作
                }) {
                    Text("美國")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
                               
                Button(action: {
                    // 兩岸按鈕動作
                }) {
                    Text("兩岸")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
                               
                Button(action: {
                // 兩岸按鈕動作
                }) {
                    Text("兩岸")
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
                               
               Button(action: {
                // 網格按鈕動作
                }) {
                    Image(systemName: "circle.grid.2x2")
                        .foregroundColor(.white)
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 新增：顯示新聞項目列表
            VStack(spacing: 12) {
                ForEach(newsItems) { item in
                    newsItem(newsItem: item) {
                        // 點擊新聞項目時的動作
                        print("點擊了新聞：\(item.title)")
                    }
                }
            }
            .padding(.top, 20)
        }
    }
       
    // MARK: - News Item Button (修改版本 - 支持圖片顯示)
    private func newsItem(newsItem: NewsItem2, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                
                VStack(alignment: .leading, spacing: 8) {
                    // 上排：來源、標籤和時間
                    HStack {
                        // 左側：來源標籤
                        Text(newsItem.source)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "FF6200"))
                        
                        // 中間：主題標籤
                        Text("#\(newsItem.category)")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: "FF6200").opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        
                        Text("#\(newsItem.category2)")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: "FF6200").opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        
                        Spacer()
                        
                        // 右側：時間
                        Text(dateFormatter.string(from: newsItem.time))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    // 下排：新聞標題
                    Text(newsItem.title)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                // 圖片部分 - 根據 showNewsImages 狀態顯示/隱藏
                if showNewsImages {
                    AsyncImage(url: URL(string: newsItem.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(8)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .cornerRadius(8)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            )
                    }
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.9)),
                        removal: .opacity.combined(with: .scale(scale: 0.9))
                    ))
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.4), value: showNewsImages) // 添加動畫效果
    }
}



#Preview {
    NewsHomeView()
}
