import SwiftUI

struct Goal: Identifiable, Hashable {
    let id = UUID()
    var text: String
    var time: String?
}

struct ContentView: View {
    @State private var goals: [Goal] = [
        Goal(text: "new year card", time: nil),
        Goal(text: "new year card  ✴︎✴︎", time: "10:00")
    ]
    @State private var newGoalText: String = ""
    @State private var navigateToPNewsSourceSelection = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Progress bar
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "FF6200"))
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
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("What do you want to accomplish at")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("主題標籤")
                                        .foregroundColor(.white)
                                        .font(.system(size: 32, weight: .bold))
                                }
                                Spacer()
                            }
                            ForEach(goals) { goal in
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text(goal.text)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .semibold))
                                        Spacer()
                                        Button(action: {
                                            if let idx = goals.firstIndex(of: goal) {
                                                goals.remove(at: idx)
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 20))
                                        }
                                    }
                                    if let time = goal.time {
                                        Text(time)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            HStack {
                                TextField("new", text: $newGoalText)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.white.opacity(0.08))
                                    .cornerRadius(8)
                                Button(action: {
                                    if !newGoalText.trimmingCharacters(in: .whitespaces).isEmpty {
                                        goals.append(Goal(text: newGoalText, time: nil))
                                        newGoalText = ""
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color(hex: "FF6200"))
                                        .font(.system(size: 28))
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(24)
                        // 右上角小圖示
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white.opacity(0.08))
                                            .frame(width: 48, height: 48)
                                    )
                                    .padding(.top, -12)
                                    .padding(.trailing, -12)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    HStack {
                        Button(action: {}) {
                            Text("回上一步")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                                .padding(.vertical, 18)
                                .padding(.horizontal, 24)
                                .background(Color.clear)
                                .cornerRadius(16)
                        }
                        Spacer()
                        Button(action: {
                            // 進入下一頁 (p40)
                            print("下一步按鈕被點擊") // 調試信息
                            navigateToPNewsSourceSelection = true
                            print("navigateToP40 設為 true") // 調試信息
                        }) {
                            HStack {
                                Text("下一步")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
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
                
                // 導航到 p40 - 簡化版本
                NavigationLink(
                    destination: news＿source＿selection(),
                    isActive: $navigateToPNewsSourceSelection
                ) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
