import SwiftUI
import SwiftData

struct SetView: View {
    @Bindable var flashcardSet: FlashcardSet
    @State private var isMenuExpanded = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var textFieldUpdateTrigger = false // Keep for potential TextEditor quirks
    @Environment(\.modelContext) private var modelContext

    // Use shared color scheme
    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }
    
    // Helper computed property to get flashcards as an array for ForEach
    private var flashcardsArray: [Flashcard] {
        var cards: [Flashcard] = []
        var current = flashcardSet.head
        while let card = current {
            cards.append(card)
            current = card.next
        }
        return cards
    }


    var body: some View {
        // Use GeometryReader to dismiss keyboard on tap outside
        GeometryReader { geometry in
            NavigationStack {
                ZStack(alignment: .bottom) {
                    mainContentView
                        .onTapGesture {
                           hideKeyboard() // Dismiss keyboard on tap
                        }
                    bottomMenuView

                    // Helper view for triggering updates (keep for TextEditor stability if needed)
                    Color.clear.frame(width: 0, height: 0)
                        .id(textFieldUpdateTrigger) // Use .id to trigger redraw
                }
                .background(colors.backgroundColor.ignoresSafeArea()) // Extend background
                .navigationBarBackButtonHidden(true)
//                .onAppear { // Triggering on appear might not be needed if list updates work
//                    triggerTextFieldUpdates()
//                }
            }
        }
    }

    private var mainContentView: some View {
        VStack(spacing: 0) {
            titleBarView
            cardListView // Use the list directly
            bottomCutoffView
        }
    }

    private var titleBarView: some View {
        ZStack {
            TextField("Enter Title", text: $flashcardSet.title)
                .padding(.vertical, 5)
                .background(Color.clear)
                // .border(Color.clear, width: 0) // TextField doesn't have border modifier
                .font(.system(size: 32, weight: .regular))
                .foregroundColor(colors.textColor)
                .padding(.top, 8)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60) // Ensure title doesn't overlap buttons

            HStack {
                backButton
                Spacer()
            }
            .zIndex(1) // Keep buttons above TextField if text is long
        }
        .padding(.bottom, 5) // Add some space below title
    }

    private var backButton: some View {
        Button(action: {
            saveAndDismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(colors.textColor)
                .padding()
        }
    }

    private var cardListView: some View {
        // Use the computed array to iterate
        LazyVStack {
            addNewCardButton(atTop: true)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)

            // --- Iteration Change ---
            // Iterate over the computed array using the flashcard's persistent ID
            ForEach(flashcardsArray, id: \.id) { flashcard in
//                flashcardView(
//                        questionBinding: Binding(
//                            get: { flashcard.question },
//                            set: {
//                                if let index = flashcardsArray.firstIndex(where: { $0.id == flashcard.id }) {
//                                    flashcardsArray.question = $0
//                                }
//                            }
//                        ),
//                        answerBinding: Binding(
//                            get: { flashcard.answer },
//                            set: {
//                                if let index = flashcardsArray.firstIndex(where: { $0.id == flashcard.id }) {
//                                    flashcardsArray.answer = $0
//                                }
//                            }
//                        ),
//                        cardToDelete: flashcard
//                    )
//                    .listRowSeparator(.hidden)
//                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//                    .listRowBackground(Color.clear)
            }

            addNewCardButton(atBottom: true)
                 .listRowSeparator(.hidden)
                 .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                 .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .environment(\.defaultMinListRowHeight, 0) // Keep if needed
        .scrollContentBackground(.hidden) // Make list background clear
        .background(colors.backgroundColor) // Ensure list background matches view
    }

    // --- View Function Change ---
    // Accept the actual Flashcard object, not an index or binding
    private func flashcardView(
        questionBinding: Binding<String>,
        answerBinding: Binding<String>,
        cardToDelete: Flashcard // Keep the object instance for deletion logic
    ) -> some View {
        // IMPORTANT: Use @Bindable on flashcardSet within the scope where
        // you need bindings to the flashcard's properties.
        // However, directly binding to `$flashcard.question` should work
        // if `flashcard` is a managed object observed by the view hierarchy.

        VStack(alignment: .leading, spacing: 0) {
            questionSectionView(questionBinding: questionBinding)

            // Divider
            Rectangle()
                .fill(colors.boxBorderColor)
                .frame(height: 1)
                .padding(.horizontal, 32)

            answerSectionView(answerBinding: answerBinding)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                withAnimation {
                    // Use the passed flashcard object directly
                    flashcardSet.remove(flashcard: cardToDelete, modelContext: modelContext)
                    // Optionally trigger update if list doesn't refresh automatically
                     triggerTextFieldUpdates()
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
        .background(colors.boxColor)
        .cornerRadius(12)
        .shadow(radius: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colors.boxBorderColor, lineWidth: 1)
        )
        // List row modifiers moved to ForEach item in cardListView
    }
    // --- End View Function Change ---

    // --- Section Function Change ---
    // Accept Flashcard object
    private func questionSectionView(questionBinding: Binding<String>) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("Q:")
                .padding(.top, 12) // Adjusted padding for alignment with TextEditor
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(colors.questionLabelColor)

            questionTextFieldView(questionBinding: questionBinding)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // --- TextField View Change ---
    // Accept Flashcard object
    private func questionTextFieldView(questionBinding: Binding<String>) -> some View {
         ZStack(alignment: .topLeading) {
             if questionBinding.wrappedValue.isEmpty {
                 questionPlaceholderView
             }
             // Use the passed binding
             CustomTextField(text: questionBinding, trigger: $textFieldUpdateTrigger)
        }
        // Removed extra VStack
    }
    // --- End TextField View Change ---

    private var questionPlaceholderView: some View {
        Text("Enter Question")
            .foregroundColor(Color.gray.opacity(0.6))
            .font(.system(size: 20))
            .padding(.leading, 10) // Match CustomTextField padding
            .padding(.top, 8)      // Match CustomTextField padding
            .allowsHitTesting(false)
    }

    // --- Section Function Change ---
     // Accept Flashcard object
    private func answerSectionView(answerBinding: Binding<String>) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("A:")
                .font(.system(size: 20, weight: .medium))
                .padding(.top, 12) // Adjusted padding
                .foregroundColor(colors.answerLabelColor)

            answerTextFieldView(answerBinding: answerBinding)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        // .padding(.leading, 2) // Removed potentially offsetting padding
    }

    // --- TextField View Change ---
    // Accept Flashcard object
    private func answerTextFieldView(answerBinding: Binding<String>) -> some View {
        ZStack(alignment: .topLeading) {
            // Placeholder Text
            if answerBinding.wrappedValue.isEmpty {
                answerPlaceholderView
            }
             // Use the passed binding
            CustomTextField(text: answerBinding, trigger: $textFieldUpdateTrigger)
        }
         // Removed extra VStack
    }
    // --- End TextField View Change ---


    private var answerPlaceholderView: some View {
        Text("Enter Answer")
            .foregroundColor(Color.gray.opacity(0.6))
            .font(.system(size: 20))
            .padding(.leading, 10) // Match CustomTextField padding
            .padding(.top, 8)      // Match CustomTextField padding
            .allowsHitTesting(false)
    }

    // Add new card button remains largely the same, just ensures correct list row modifiers are applied outside
    private func addNewCardButton(atTop: Bool = false, atBottom: Bool = false) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
                .shadow(radius: 5)
                .frame(height: 70)

            Button(action: {
                addNewCard(atBeginning: atTop)
            }) {
                Text("Add new Card")
                    .font(.headline)
                    .foregroundColor(colors.buttonTextColor) // Use dynamic color
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity) // Make button tappable area larger
            }
            .buttonStyle(PlainButtonStyle()) // Prevent list row selection style
        }
        // List row modifiers moved to where this button is placed in the List
    }

    private var bottomCutoffView: some View {
        // Correct gradient application
        LinearGradient(
            gradient: Gradient(colors: [colors.backgroundColor.opacity(0), colors.backgroundColor]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 80)
        .allowsHitTesting(false) // Don't let it interfere with bottom menu
    }

    // MARK: - Bottom Menu Components (Unchanged, assumed correct)
    // ... (Keep your existing bottomMenuView, expandedMenuOptions, buttonRow, searchButton, studyButton, profileButton)
    private var bottomMenuView: some View {
        VStack(spacing: 0) {
            // Menu Options
            if isMenuExpanded {
                expandedMenuOptions
                    .padding(.bottom, 10) // Add padding when expanded
            }

            // Button Row
            buttonRow
        }
        .frame(maxWidth: .infinity) // Ensure it spans width
    }

    private var expandedMenuOptions: some View {
        VStack(spacing: 10) {
             // Ensure NavigationLinks work within the current NavigationStack
            NavigationLink(destination: FlashcardView(flashcardSet: flashcardSet)) {
                 MenuOptionButton(title: "Standard", icon: "rectangle.fill")
            }
//             NavigationLink(destination: HorizontalFlashcardView(flashcardSet: flashcardSet)) {
//                 MenuOptionButton(title: "Motion", icon: "iphone.and.arrow.forward")
//            }
             Button(action: { /* Placeholder */ }) {
                MenuOptionButton(title: "Coming Soon", icon: "clock.fill")
                     .opacity(0.6) // Indicate disabled/future state
             }
             .disabled(true)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        // Removed padding here, added in bottomMenuView
    }

    private var buttonRow: some View {
        ZStack(alignment: .center) {
            // Positioning relative to center Study button
             studyButton // Center button first
             searchButton // Position relative to Study button width
             profileButton // Position relative to Study button width
        }
        .padding(.horizontal, 20)
        // Removed bottom padding here, handled in bottomMenuView
        .frame(height: 50) // Ensure consistent height
    }

     // Calculate offsets based on a fixed study button width for stability
     private let studyButtonWidth: CGFloat = UIScreen.main.bounds.width * 0.5 // Adjusted width
     private var sideButtonOffset: CGFloat {
         (studyButtonWidth / 2) + 35 // (Half study width + spacing + half icon width approx)
     }

    private var searchButton: some View {
         Button(action: { /* Search */ }) {
             Image(systemName: "magnifyingglass")
                 .font(.system(size: 20, weight: .bold))
                 .foregroundColor(colors.textColor)
                 .frame(width: 50, height: 50)
                 .background(colors.boxColor)
                 .clipShape(Circle())
                 .shadow(radius: 3) // Adjusted shadow
         }
         .offset(x: -sideButtonOffset)
    }

    private var studyButton: some View {
         Button(action: {
             withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { // Adjusted animation
                 isMenuExpanded.toggle()
             }
         }) {
             ZStack {
                 RoundedRectangle(cornerRadius: 8)
                     .fill(Color(red: 0.2, green: 0.8, blue: 0.4)) // Consider using AppColorScheme color
                     .shadow(radius: 3) // Adjusted shadow

                 Label("Study", systemImage: isMenuExpanded ? "xmark" : "book.fill")
                     .font(.title2) // Adjusted font size
                     .foregroundColor(colors.buttonTextColor) // Use dynamic color
             }
         }
         .frame(width: studyButtonWidth, height: 50) // Use calculated width
    }

    private var profileButton: some View {
         Button(action: { /* Profile */ }) {
             Image(systemName: "person.fill")
                 .font(.system(size: 20, weight: .bold))
                 .foregroundColor(colors.textColor)
                 .frame(width: 50, height: 50)
                 .background(colors.boxColor)
                 .clipShape(Circle())
                 .shadow(radius: 3) // Adjusted shadow
         }
         .offset(x: sideButtonOffset)
    }


    // MARK: - Helper Functions

    private func addNewCard(atBeginning: Bool) {
        // Create card first
        let newCard = Flashcard(question: "", answer: "") // Start empty

        // Perform insertion/append
        if atBeginning {
            flashcardSet.insert(flashcard: newCard)
        } else {
            flashcardSet.append(flashcard: newCard)
        }

        // Animate the list update
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
           // The change to flashcardSet (observed by @Bindable) should trigger UI update.
           // Triggering manually might still help if TextEditor focus is involved.
            triggerTextFieldUpdates()
        }

        // Consider automatically focusing the new card's question field later
    }

    // Function to trigger UI refresh potentially needed for TextEditor updates
    func triggerTextFieldUpdates() {
        textFieldUpdateTrigger.toggle()
    }

    // Save context and dismiss
    private func saveAndDismiss() {
        hideKeyboard() // Ensure text is committed
        // Use a do-catch block for safety, although save() on main context rarely throws fatal errors
        do {
            try modelContext.save()
        } catch {
            // Handle or log the error appropriately
            print("Error saving model context: \(error)")
        }
        dismiss()
    }

    // Function to dismiss keyboard
     private func hideKeyboard() {
         UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }
}

// MARK: - CustomTextField (Modified slightly)

struct CustomTextField: View {
    @Binding var text: String
    @Binding var trigger: Bool // Add binding to trigger state
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme

    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }

    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 20))
            .foregroundColor(colors.textColor) // Ensure text color adapts
            .multilineTextAlignment(.leading)
            .background(Color.clear)
            .scrollContentBackground(.hidden) // Use this modifier
            .padding(.leading, 5) // Keep consistent padding L/R
            .padding(.trailing, 5)
            .padding(.top, 0) // Adjust top padding if needed for alignment
            .frame(minHeight: 30, maxHeight: .infinity) // Allow shrinking and growing
            // .fixedSize(horizontal: false, vertical: true) // Might not be needed with TextEditor auto-sizing
            .focused($isFocused)
            .onChange(of: text) { _, _ in
                 // If external trigger is needed:
                 // DispatchQueue.main.async { trigger.toggle() }
            }
            // Add onSubmit or other focus handling if required
    }
}

// MARK: - MenuOptionButton (Unchanged)

struct MenuOptionButton: View {
    let title: String
    let icon: String
    @Environment(\.colorScheme) var colorScheme

    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: 25, alignment: .center) // Align icons
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
        }
        .foregroundColor(colors.textColor)
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.6) // Consider making dynamic/less fixed
        .background(colors.boxColor)
        .cornerRadius(8)
        .shadow(radius: 2) // Subtle shadow
    }
}

// MARK: - AppColorScheme (Assuming this exists elsewhere)
// struct AppColorScheme {
//     let colorScheme: ColorScheme
//     var backgroundColor: Color { colorScheme == .dark ? Color.black : Color.white }
//     var textColor: Color { colorScheme == .dark ? Color.white : Color.black }
//     var boxColor: Color { colorScheme == .dark ? Color(white: 0.15) : Color(white: 0.95) }
//     var boxBorderColor: Color { colorScheme == .dark ? Color(white: 0.3) : Color(white: 0.8) }
//     var questionLabelColor: Color { .blue }
//     var answerLabelColor: Color { .green }
//     var buttonTextColor: Color { .white } // Or adapt based on button background
//     var cutoffColor: Color { colorScheme == .dark ? Color.black : Color.white } // Match background for fade
// }

// MARK: - Preview

// Make sure your Preview provider uses a sample FlashcardSet
// You might need to create a temporary in-memory model container for the preview
// Example Sample Data (Adapt as needed)
func ScienceSampleSet() -> FlashcardSet {
    let set = FlashcardSet(title: "Science Facts")
    let card1 = Flashcard(question: "What is H2O?", answer: "Water")
    let card2 = Flashcard(question: "What planet is third from the sun?", answer: "Earth")
    let card3 = Flashcard(question: "What force pulls objects towards each other?", answer: "Gravity")

    // Manually link them for the preview (in real use, append/insert handles this)
    set.head = card1
    card1.next = card2
    card2.next = card3
    set.count = 3 // Manually set count for preview consistency

    return set
}

#Preview {
    // Example using in-memory container for preview
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FlashcardSet.self, Flashcard.self, configurations: config)

        // Create sample data within the preview's context
        let sampleSet = ScienceSampleSet()
        container.mainContext.insert(sampleSet)
        // Manually insert linked cards if not handled by init/append in sample func
        if let card1 = sampleSet.head {
            container.mainContext.insert(card1)
            if let card2 = card1.next {
                container.mainContext.insert(card2)
                 if let card3 = card2.next {
                    container.mainContext.insert(card3)
                }
            }
        }


        return SetView(flashcardSet: sampleSet)
            .modelContainer(container)
            // Assuming AppColorScheme exists
             .environment(\.colorScheme, .light) // Or .dark
    } catch {
        fatalError("Failed to create model container for preview: \(error)")
    }
}

// Add this if you don't have it, useful for previews and testing
extension EdgeInsets {
    static let zero = EdgeInsets()
}
