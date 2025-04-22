import SwiftUI
import SwiftData

struct SetView: View {
    @Bindable var flashcardSet: FlashcardSet
    @State private var isMenuExpanded = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var textFieldUpdateTrigger = false
    @Environment(\.modelContext) private var modelContext
    
    // Use shared color scheme
    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            mainContentView
            bottomMenuView
            
            // Helper view for triggering updates
            if textFieldUpdateTrigger {
                Color.clear.frame(width: 0, height: 0)
            } else {
                Color.clear.frame(width: 0, height: 0)
            }
        }
        .background(colors.backgroundColor)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            triggerTextFieldUpdates()
        }
    }
    
    // MARK: - Main View Components
    
    private var mainContentView: some View {
        VStack(spacing: 0) {
            titleBarView
            
            GeometryReader { _ in
                cardListView
            }
            
            // Bottom cutoff overlay
            bottomCutoffView
        }
    }
    
    private var titleBarView: some View {
        ZStack {
            TextField("Enter Title", text: $flashcardSet.title)
                .padding(.vertical, 5)
                .background(Color.clear)
                .border(Color.clear, width: 0)
                .font(.system(size: 32, weight: .regular))
                .foregroundColor(colors.textColor)
                .padding(.top, 8)
                .multilineTextAlignment(.center)
            
            HStack {
                backButton
                Spacer()
            }
            .zIndex(1)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            flashcardSet.reindex()
            try? modelContext.save()
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(colors.textColor)
                .padding()
        }
    }
    
    private var cardListView: some View {
        
        ZStack {

            
            List ($flashcardSet.flashcards, editActions: .move) { flashcard in
                let allIndices = flashcardSet.flashcards.compactMap(\.index)
                let minIndex   = allIndices.min()
                let maxIndex   = allIndices.max()
                
                if flashcard.index.wrappedValue == minIndex {
                    addNewCardButton(atTop: true)
                }
                
                flashcardView(flashcard: flashcard)
                
                if flashcard.index.wrappedValue == maxIndex {
                    addNewCardButton(atTop: false)
                }
            }
            .listStyle(PlainListStyle())
            .environment(\.defaultMinListRowHeight, 0)
            .scrollContentBackground(.hidden)
            
            if (flashcardSet.flashcards.isEmpty) {
                addNewCardButton(atTop: true)
            }
        }
    }
    
    private var sortedIndices: [Int] {
        
        flashcardSet.flashcards.indices.sorted { idx1, idx2 in
            let index1 = flashcardSet.flashcards[idx1].index
            let index2 = flashcardSet.flashcards[idx2].index
            return index1 < index2
        }
    }
    
    private func flashcardView(flashcard: Binding<Flashcard>) -> some View {
        
        return VStack(alignment: .leading, spacing: 0) {
            questionSectionView(for: flashcard)
            
            Text(String(flashcard.index.wrappedValue))
            // Divider
            Rectangle()
                .fill(colors.boxBorderColor)
                .frame(height: 1)
                .padding(.horizontal, 32)
            
            answerSectionView(for: flashcard)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                withAnimation {
                    flashcardSet.remove(flashcardToRemove: flashcard.wrappedValue, modelContext: modelContext)
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
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .listRowBackground(Color.clear)
    }
    
    private func questionSectionView(for flashcard: Binding<Flashcard>) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("Q:")
                .padding(.top, 8)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(colors.questionLabelColor)
            
            questionTextFieldView(for: flashcard)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private func questionTextFieldView(for flashcard: Binding<Flashcard>) -> some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Placeholder Text
                if flashcard.question.wrappedValue.isEmpty {
                    questionPlaceholderView
                }

                CustomTextField(text: flashcard.question)
                    .onAppear {
                        triggerTextFieldUpdates()
                    }
            }
        }
    }
    
    private var questionPlaceholderView: some View {
        Text("Enter Question")
            .foregroundColor(Color.gray.opacity(0.6))
            .font(.system(size: 20))
            .padding(.leading, 10)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .allowsHitTesting(false)
    }
    
    private func answerSectionView(for flashcard: Binding<Flashcard>) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("A:")
                .font(.system(size: 20, weight: .medium))
                .padding(.top, 8)
                .foregroundColor(colors.answerLabelColor)

            answerTextFieldView(for: flashcard)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .padding(.leading, 2)
    }
    
    private func answerTextFieldView(for flashcard: Binding<Flashcard>) -> some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Placeholder Text
                if flashcard.answer.wrappedValue.isEmpty {
                    answerPlaceholderView
                }

                CustomTextField(text: flashcard.answer)
                    .onAppear {
                        triggerTextFieldUpdates()
                    }
            }
        }
    }
    
    private var answerPlaceholderView: some View {
        Text("Enter Answer")
            .foregroundColor(Color.gray.opacity(0.6))
            .font(.system(size: 20))
            .padding(.leading, 10)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .allowsHitTesting(false)
    }
    
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
                    .foregroundColor(colors.buttonTextColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .listRowBackground(Color.clear)
    }
    
    private var bottomCutoffView: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(colors.cutoffColor)
                .frame(height: 80)
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    // MARK: - Bottom Menu Components
    
    private var bottomMenuView: some View {
        VStack(spacing: 0) {
            // Menu Options
            if isMenuExpanded {
                expandedMenuOptions
            }
            
            // Button Row
            buttonRow
        }
    }
    
    private var expandedMenuOptions: some View {
        VStack(spacing: 10) {
            NavigationLink(destination: FlashcardView(flashcardSet: flashcardSet)) {
                MenuOptionButton(title: "Standard", icon: "rectangle.fill")
            }
            NavigationLink(destination: HorizontalFlashcardView(flashcardSet: flashcardSet)) {
                MenuOptionButton(title: "Motion", icon: "iphone.and.arrow.forward")
            }
            Button(action: {
                // Placeholder for future functionality
            }) {
                MenuOptionButton(title: "Coming Soon", icon: "clock.fill")
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .padding(.bottom, 10)
    }
    
    private var buttonRow: some View {
        ZStack(alignment: .center) {
            searchButton
            studyButton
            profileButton
        }
        .padding(.bottom, 10)
        .padding(.horizontal, 20)
    }
    
    private var searchButton: some View {
        Button(action: {
            // Search functionality will go here
        }) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(colors.textColor)
                .frame(width: 50, height: 50)
                .background(colors.boxColor)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .offset(x: -((UIScreen.main.bounds.width * 0.6) / 2 + 35))
    }
    
    private var studyButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isMenuExpanded.toggle()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
                    .shadow(radius: 5)
                
                Label("Study", systemImage: isMenuExpanded ? "xmark" : "book.fill")
                    .font(.title)
                    .foregroundColor(colors.buttonTextColor)
            }
        }
        .frame(height: 50)
        .frame(width: UIScreen.main.bounds.width * 0.6)
    }
    
    private var profileButton: some View {
        Button(action: {
            // Profile functionality will go here
        }) {
            Image(systemName: "person.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(colors.textColor)
                .frame(width: 50, height: 50)
                .background(colors.boxColor)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .offset(x: ((UIScreen.main.bounds.width * 0.6) / 2 + 35))
    }
        
    private func addNewCard(atBeginning: Bool) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            let newCard = Flashcard(question: "New Question", answer: "New Answer", index: 0)
            
            if atBeginning {
                flashcardSet.insert(flashcard: newCard, modelContext: modelContext)
            } else {
                flashcardSet.append(flashcard: newCard, modelContext: modelContext)
            }
        }
    }
    
    func triggerTextFieldUpdates() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            textFieldUpdateTrigger.toggle()
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 20))
            .multilineTextAlignment(.leading)
            .background(Color.clear)
            .scrollContentBackground(.hidden)
            .padding([.leading, .trailing], 5)
            .frame(minHeight: 40, maxHeight: .infinity)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    // Helper function to dismiss the keyboard
    private func hideKeyboard() {
        isFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

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
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
        }
        .foregroundColor(colors.textColor)
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.6)
        .background(colors.boxColor)
        .cornerRadius(8)
        .shadow(radius: 3)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SetView(flashcardSet: FlashcardSet(title: "Science", flashcards: [
        Flashcard(question: "What is H2O?", answer: "Water", index: 1),
        Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury", index: 2),
        Flashcard(question: "What is the hardest natural substance?", answer: "Diamond", index: 3),
        Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second", index: 4),
        Flashcard(question: "What is the largest organ in the human body?", answer: "Skin", index: 5),
        Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis", index: 6)
    ]))
}
