import SwiftUI

// ChatLabel struct (assuming it's defined as before)
struct ChatLabel: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let time: Date?
    var starCount: Int?
    var memo: String?
}

struct guide: View {
    @State private var labels: [ChatLabel] = [
        ChatLabel(text: "new year card", time: nil),
    ]
    @State private var newGoalText: String = ""
    @State private var selectedStars: Int = 0 // This will control the stars in the toolbar
    @State private var showMemoField: Bool = false
    @State private var memoText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isMemoFocused: Bool

    private let inputColor = Color(red: 1, green: 0.38, blue: 0)

    var body: some View {
        NavigationView {
            ZStack(alignment: .top){
                Color.black
                    .ignoresSafeArea()

                HStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 290, height: 290)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .cornerRadius(290)
                        .blur(radius: 100)
                        .opacity(0.3)
                }
                .padding(.top, 136)

                VStack(spacing: 0){
                    // Progress Bar (remains the same)
                    ZStack(alignment: .leading) {
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 10)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 1, green: 0.38, blue: 0), lineWidth: 1)
                                )
                            Rectangle().foregroundColor(.clear).frame(width: 77, height: 11).background(Color(red: 0.13, green: 0.13, blue: 0.13)).cornerRadius(29)
                            Rectangle().foregroundColor(.clear).frame(width: 77, height: 11).background(Color(red: 0.13, green: 0.13, blue: 0.13)).cornerRadius(29)
                            Rectangle().foregroundColor(.clear).frame(width: 77, height: 11).background(Color(red: 0.13, green: 0.13, blue: 0.13)).cornerRadius(29)
                            ZStack{
                                Rectangle().foregroundColor(.clear).frame(width: 20, height: 20).background(Color(red: 0.13, green: 0.13, blue: 0.13)).cornerRadius(29)
                                Image("guide_done_1").padding(.top, 2)
                            }.padding(.leading, 8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)

                    // Header Text (remains the same)
                    HStack(){
                        VStack(alignment: .leading, spacing: 7){
                            Text("What do you want to accomplish at")
                                .font(Font.custom("Instrument Sans", size: 13).weight(.semibold))
                                .foregroundColor(.white).padding(.leading, 3)
                            Text("主題標籤")
                                .font(Font.custom("Instrument Sans", size: 31.79449).weight(.bold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image("guide_icon").padding(.bottom, 3).padding(.trailing, 4)
                    }
                    .padding(.horizontal, 20).padding(.top, 26).padding(.bottom, 35)

                    // List of items & Input Field (remains the same, uses the new keyboardToolbar)
                    VStack{
                        ForEach(labels) { goal in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text(goal.text).foregroundColor(.white).font(.system(size: 20, weight: .semibold))
                                    Spacer()
                                    if let starCount = goal.starCount, starCount > 0 {
                                        HStack(spacing: 2) {
                                            ForEach(0..<min(starCount, 6), id: \.self) { _ in
                                                Image(systemName: "star.fill").foregroundColor(.yellow).font(.system(size: 12))
                                            }
                                        }
                                    }
                                    Button(action: {
                                        if let idx = labels.firstIndex(of: goal) { labels.remove(at: idx) }
                                    }) {
                                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray).font(.system(size: 20))
                                    }
                                }
                                .frame(height: 26).padding(.top, 10)
                                if let time = goal.time { Text(formatDate(time)).foregroundColor(.gray).font(.system(size: 14)).padding(.top, 4) }
                                if let memo = goal.memo, !memo.isEmpty { Text("備註: \(memo)").font(.system(size: 14)).foregroundColor(.gray.opacity(0.8)).padding(.top, 2) }
                                Divider().background(Color.white.opacity(0.5)).padding(.top, 9)
                            }
                        }
                        HStack {
                            TextField("new", text: $newGoalText)
                                .focused($isTextFieldFocused)
                                .foregroundColor(.white).keyboardType(.default).colorScheme(.dark)
                                .font(Font.custom("Inria Sans", size: 20).weight(.bold))
                                .onSubmit { addNewItem() }
                                .toolbar { // This is where the updated keyboardToolbar will be used
                                    ToolbarItemGroup(placement: .keyboard) {
                                        keyboardToolbar
                                    }
                                }
                        }
                        .padding(.top, 4).frame(height: 50)
                        if (!isTextFieldFocused){ Divider().background(Color.white.opacity(0.5)) }
                        else{ Divider().overlay(inputColor.frame(height: 1)) }
                    }
                    .padding(.horizontal, 28)

                    // Memo Field (remains the same)
                    if showMemoField {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack { Text("備註").font(.caption).foregroundColor(.gray); Spacer() }.padding(.horizontal, 16)
                            TextEditor(text: $memoText)
                                .focused($isMemoFocused)
                                .scrollContentBackground(.hidden).background(Color.gray.opacity(0.1)).foregroundColor(.white).cornerRadius(8)
                                .frame(minHeight: 60).frame(maxHeight: calculateTextHeight(text: memoText))
                                .padding(.horizontal, 16)
                                .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { isMemoFocused = true } }
                        }
                        .padding(.bottom, 8).background(Color.black)
                        .transition(.move(edge: .bottom).combined(with: .opacity)).zIndex(1)
                    }

                    Spacer()

                    // Navigation Buttons (remains the same)
                    HStack (spacing: 25){
                        Button(action: {}) { Text("回上一步").foregroundColor(.white).font(.system(size: 16, weight: .medium)) }
                        NavigationLink(destination: guide2().navigationBarHidden(true).navigationBarBackButtonHidden(true)) {
                            HStack(alignment: .center) {
                                Text("下一步").foregroundColor(.white).font(.system(size: 18, weight: .bold))
                                Image(systemName: "arrow.right").foregroundColor(.white)
                            }
                            .frame(width: 249, height: 60, alignment: .center).background(Color(red: 1, green: 0.38, blue: 0))
                            .cornerRadius(38).overlay(RoundedRectangle(cornerRadius: 38).inset(by: 0.5).stroke(.white.opacity(0.32), lineWidth: 1))
                        }
                    }
                    .frame(maxWidth: .infinity).padding(.leading,15).padding(.bottom, 24)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // --- Updated Keyboard Toolbar ---
    private var keyboardToolbar: some View {
        HStack(spacing: 8) { // Add spacing between main groups if needed
            // Stars Button Group
            HStack(spacing: 2) { // Spacing between individual stars
                ForEach(0..<6, id: \.self) { index in
                    Button(action: {
                        if selectedStars == index + 1 {
                            selectedStars = 0 // Deselect if tapping the same star count
                        } else {
                            selectedStars = index + 1
                        }
                    }) {
                        Image(systemName: selectedStars > index ? "star.fill" : "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22) // Adjust star size to match image
                            .foregroundColor(selectedStars > index ? Color(hex: "#FFCC00") : Color.gray.opacity(0.7)) // Yellow for selected, gray for unselected
                    }
                }
            }
            .padding(.horizontal, 10) // Padding around the star group
            .padding(.vertical, 8)   // Vertical padding for the star group
            .background(Color.white.opacity(0.1)) // Slightly lighter background for the star group container
            .cornerRadius(8)

            // Memo Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showMemoField.toggle()
                    if !showMemoField {
                        isTextFieldFocused = true // Return focus to main text field if memo is hidden
                    } else {
                        isMemoFocused = true // Focus memo field when it appears
                    }
                }
            }) {
                Text("memo")
                    .font(.system(size: 15, weight: .medium)) // Adjusted font
                    .foregroundColor(showMemoField ? .black : .white.opacity(0.8)) // Text color changes if memo is active
                    .padding(.horizontal, 18) // Adjusted padding
                    .padding(.vertical, 10)    // Adjusted padding
                    .background(showMemoField ? Color.white : Color.white.opacity(0.2)) // Background changes if memo is active
                    .cornerRadius(8)
            }

            Spacer() // Pushes the hide keyboard button to the right

            // Hide Keyboard Button
            Button(action: {
                hideKeyboard()
            }) {
                Image(systemName: "keyboard.chevron.compact.down") // Standard SF Symbol for hide keyboard
                    .font(.system(size: 24, weight: .regular)) // Adjusted size and weight
                    .foregroundColor(.gray)
                    .padding(8) // Add some padding to make it easier to tap
                    // Optional: Add a background if you want it to look more like a button
                    // .background(Color.white.opacity(0.1))
                    // .clipShape(Circle())
            }
        }
        .padding(.horizontal, 8) // Padding for the entire toolbar
        .frame(height: 50)       // Define a height for the toolbar
        .background(Color(hex: "#2C2C2E").opacity(0.8)) // Dark background similar to the image, slightly transparent
    }

    // Helper functions (addNewItem, calculateTextHeight, hideKeyboard, formatDate) remain the same
    private func addNewItem() {
        guard !newGoalText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newLabel = ChatLabel(
            text: newGoalText, time: Date(),
            starCount: selectedStars > 0 ? selectedStars : nil,
            memo: memoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : memoText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        labels.append(newLabel)
        newGoalText = ""; selectedStars = 0; memoText = ""; showMemoField = false; isTextFieldFocused = true
    }
    private func calculateTextHeight(text: String) -> CGFloat {
        let lineCount = max(1, text.components(separatedBy: .newlines).count)
        let baseHeight: CGFloat = 60; let lineHeight: CGFloat = 20
        return min(baseHeight + CGFloat(max(0, lineCount - 1)) * lineHeight, 120)
    }
    private func hideKeyboard() {
        isTextFieldFocused = false; isMemoFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMM d, HH:mm"; formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}

#Preview {
    guide()
}
