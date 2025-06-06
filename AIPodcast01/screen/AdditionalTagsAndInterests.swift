import SwiftUI

// ChatLabel struct can be defined in a shared file or copied here if not already.
// For this example, I'm assuming it's available or you'll copy it from guide.swift.
// struct ChatLabel: Identifiable, Hashable { ... }

struct AdditionalTagsAndInterests: View {
    // State variables for guide2
    @State private var labels: [ChatLabel] = [
        // Example: Pre-populate if needed, like in the screenshot
        // ChatLabel(text: "人工智慧", time: Date(), starCount: nil, memo: nil),
        // ChatLabel(text: "產品設計", time: Date(), starCount: 2, memo: nil)
    ]
    @State private var newGoalText: String = ""
    @State private var selectedStars: Int = 0
    @State private var showMemoField: Bool = false
    @State private var memoText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isMemoFocused: Bool

    @Environment(\.dismiss) private var dismiss // For the "Back" button

    private let inputColor = Color(red: 1, green: 0.38, blue: 0) // Orange color
    private let activeSegmentFill = Color.white.opacity(0.2)
    private let inactiveSegmentFill = Color(red: 0.13, green: 0.13, blue: 0.13)

    var body: some View {
        // NavigationView should be provided by the view that navigates to guide2 (e.g., guide.swift)
        // So, we don't wrap another NavigationView here.
        ZStack(alignment: .top){
            Color.black
                .ignoresSafeArea()

            HStack{ // Background blur effect
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
                // --- Progress Bar ---
                ZStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        // Segment 1: Completed
                        Rectangle()
                            .fill(inputColor) // Solid orange for completed
                            .frame(height: 10)
                            .cornerRadius(10)

                        // Segment 2: Active
                        Rectangle()
                            .fill(activeSegmentFill)
                            .frame(height: 10)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(inputColor, lineWidth: 1) // Orange border for active
                            )

                        // Segment 3: Future
                        Rectangle()
                            .fill(inactiveSegmentFill)
                            .frame(height: 10)
                            .cornerRadius(10)

                        // Segment 4: Future
                        Rectangle()
                            .fill(inactiveSegmentFill)
                            .frame(height: 10)
                            .cornerRadius(10)

                        // Checkmark Icon (assuming 5 steps total)
                        ZStack{
                            Rectangle()
                                .fill(inactiveSegmentFill) // Match future segment
                                .frame(width: 20, height: 20) // Make it square-ish
                                .cornerRadius(10) // Consistent corner radius
                            Image("guide_done_1") // You might need a different icon or logic
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12) // Adjust icon size
                                .foregroundColor(Color.gray) // Default color for inactive checkmark
                        }
                        .padding(.leading, 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.top, 10) // Adjusted padding for visual balance with safe area

                // --- Header Text ---
                HStack(){
                    VStack(alignment: .leading, spacing: 7){
                        Text("What do you want to accomplish at")
                            .font(Font.custom("Instrument Sans", size: 13).weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 3)

                        Text("關注點") // <<<< Changed Title
                            .font(Font.custom("Instrument Sans", size: 31.79449).weight(.bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image("guide_icon") // Same icon as guide.swift
                        .padding(.bottom, 3)
                        .padding(.trailing, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 26)
                .padding(.bottom, 35)

                // --- List of Items & Input Field ---
                VStack{
                    ForEach(labels) { goal in // Using 'labels' from @State
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text(goal.text)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .semibold))
                                Spacer()
                                if let starCount = goal.starCount, starCount > 0 {
                                    HStack(spacing: 2) {
                                        ForEach(0..<min(starCount, 6), id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 12))
                                        }
                                    }
                                }
                                Button(action: {
                                    if let idx = labels.firstIndex(of: goal) {
                                        labels.remove(at: idx)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 20))
                                }
                            }
                            .frame(height: 26)
                            .padding(.top, 10)

                            if let time = goal.time {
                                Text(formatDate(time))
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .padding(.top, 4)
                            }
                            if let memo = goal.memo, !memo.isEmpty {
                               Text("備註: \(memo)")
                                   .font(.system(size: 14))
                                   .foregroundColor(.gray.opacity(0.8))
                                   .padding(.top, 2)
                           }
                            Divider()
                                .background(Color.white.opacity(0.5))
                                .padding(.top, 9)
                        }
                    }
                    HStack {
                        TextField("new focus point", text: $newGoalText) // Placeholder text updated
                            .focused($isTextFieldFocused)
                            .foregroundColor(.white)
                            .keyboardType(.default)
                            .colorScheme(.dark)
                            .font(Font.custom("Inria Sans", size: 20).weight(.bold))
                            .onSubmit { addNewItem() }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    keyboardToolbar
                                }
                            }
                    }
                    .padding(.top, 4)
                    .frame(height: 50)

                    if (!isTextFieldFocused && !isMemoFocused){ // Divider logic based on focus
                        Divider()
                            .background(Color.white.opacity(0.5))
                    } else {
                        Divider()
                            .overlay(inputColor.frame(height: 1))
                    }
                }
                .padding(.horizontal, 28)

                // --- Memo Field ---
                if showMemoField {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("備註")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        TextEditor(text: $memoText)
                            .focused($isMemoFocused)
                            .scrollContentBackground(.hidden)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .frame(minHeight: 60, maxHeight: calculateTextHeight(text: memoText))
                            .padding(.horizontal, 16)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isMemoFocused = true
                                }
                            }
                    }
                    .padding(.bottom, 8)
                    .background(Color.black)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                }

                Spacer()

                // --- Navigation Buttons ---
                HStack (spacing: 25){
                    Button(action: {
                        dismiss() // <<<< Action for "回上一步"
                    }) {
                        Text("回上一步")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }

                    NavigationLink(destination: news＿source＿selection()
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                    ) {
                        HStack(alignment: .center) {
                            Text("下一步")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .frame(width: 249, height: 60, alignment: .center)
                        .background(inputColor)
                        .cornerRadius(38)
                        .overlay(
                            RoundedRectangle(cornerRadius: 38)
                                .inset(by: 0.5)
                                .stroke(.white.opacity(0.32), lineWidth: 1)
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading,15) // Consider adjusting for centering if needed
                .padding(.bottom, 24)
            }
            // These modifiers are typically applied by the calling NavigationView or on the destination view
            // .navigationBarHidden(true)
            // .navigationBarBackButtonHidden(true)
        }
        // Crucially, if guide2 is pushed onto a NavigationView, it should NOT have its own NavigationView.
        // The .navigationBarHidden(true) should be applied on this ZStack if needed,
        // or preferably on the destination view specified in the NavigationLink from guide.swift
        // For now, assuming guide.swift's NavigationLink to guide2 handles this.
    }

    // --- Keyboard Toolbar View ---
    private var keyboardToolbar: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<6, id: \.self) { index in
                    Button(action: {
                        if selectedStars == index + 1 { selectedStars = 0 }
                        else { selectedStars = index + 1 }
                    }) {
                        Image(systemName: selectedStars > index ? "star.fill" : "star")
                            .foregroundColor(selectedStars > index ? .yellow : .gray)
                            .font(.system(size: 20))
                    }
                }
            }
            .padding(.trailing, 8)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showMemoField.toggle()
                    if !showMemoField { isTextFieldFocused = true }
                    else { isMemoFocused = true }
                }
            }) {
                Text("memo")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(showMemoField ? .black : .gray)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(showMemoField ? Color.white : Color.gray.opacity(0.2))
                    .cornerRadius(6)
            }
            Spacer()
            Button(action: { hideKeyboard() }) {
                Image(systemName: "keyboard.chevron.compact.down")
                    .foregroundColor(.gray).font(.system(size: 22))
            }
        }
        .padding(.horizontal, 8).padding(.vertical, 4)
    }

    // --- Helper Functions (identical to guide.swift) ---
    private func addNewItem() {
        guard !newGoalText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newLabel = ChatLabel(
            text: newGoalText,
            time: Date(),
            starCount: selectedStars > 0 ? selectedStars : nil,
            memo: memoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : memoText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        labels.append(newLabel)
        newGoalText = ""
        selectedStars = 0
        memoText = ""
        showMemoField = false
        isTextFieldFocused = true
    }

    private func calculateTextHeight(text: String) -> CGFloat {
        let lineCount = max(1, text.components(separatedBy: .newlines).count)
        let baseHeight: CGFloat = 60
        let lineHeight: CGFloat = 20
        return min(baseHeight + CGFloat(max(0, lineCount - 1)) * lineHeight, 120)
    }

    private func hideKeyboard() {
        isTextFieldFocused = false
        isMemoFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}

/*
// --- Placeholder for guide3.swift ---
struct guide3: View { // You'll need to create guide3.swift
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Guide 3 - Next Step")
                .foregroundColor(.white)
                .font(.largeTitle)
        }
        // .navigationBarHidden(true) // Apply if needed
        // .navigationBarBackButtonHidden(true)
    }
}
*/

// --- Preview ---
#Preview {
    // To preview guide2 correctly, embed it in a NavigationView if it relies on @Environment(\.dismiss)
    // or is meant to be pushed.
    NavigationView {
        AdditionalTagsAndInterests()
    }
}
