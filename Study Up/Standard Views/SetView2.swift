//  SetView2.swift
//  Study Up
//
//  Created by Michael Kim on 3/9/25.
//

import SwiftUI
import SwiftData

struct SetView2: View {
    @Bindable var flashcardSet: FlashcardSet
    @State private var editingCard: (index: Int, isQuestion: Bool)? = nil
    @State private var editText: String = ""
    @State private var isMenuExpanded = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var textHeight: CGFloat = 20
    
    @State private var textFieldUpdateTrigger = false
    
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isTextFieldFocused: Bool
    
    // Use shared color scheme
    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // Title with back button
                    ZStack {
                        TextField("Enter Title", text: $flashcardSet.title)
                            .padding(.vertical, 5) // Optional: Adjust spacing
                            .background(Color.clear) // Removes background
                            .border(Color.clear, width: 0) // Ensures no border
                            .font(.system(size: 32, weight: .regular))
                            .foregroundColor(colors.textColor)
                            .padding(.top, 8)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Button(action: {
                                // Reindex the remaining flashcards to ensure proper ordering
                                flashcardSet.flashcards = normalizeFlashcardIndices(flashcards: flashcardSet.flashcards)
                                try? modelContext.save()
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(colors.textColor)
                                    .padding()
                            }
                            Spacer()
                        }
                        .zIndex(1)
                    }
                    
                    GeometryReader { geometry in
                        List {
                            // Add new card button (at the top)
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
                                    .shadow(radius: 5)
                                    .frame(height: 70)
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        let newCard = Flashcard(question: "New Question", answer: "New Answer", index: 0)
                                        flashcardSet.flashcards.insert(newCard, at: 0)
                                        // reindex after adding
//                                        flashcardSet.flashcards = normalizeFlashcardIndices(flashcards: flashcardSet.flashcards)
                                        // Ensure changes are saved
                                    }
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

                            // Flashcards
                            ForEach(flashcardSet.flashcards, id: \.id) { flashcard in
                                VStack(alignment: .leading, spacing: 0) {
                                    // Question
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("Q:")
                                            .padding(.top, 8)
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(colors.questionLabelColor)
                                        VStack {
                                            ZStack(alignment: .topLeading) {
                                                // Placeholder Text
                                                if flashcard.question.isEmpty {
                                                    Text("Enter Question")
                                                        .foregroundColor(Color.gray.opacity(0.6))
                                                        .font(.system(size: 20))
                                                        .padding(.leading, 10)
                                                        .padding(.top, 8)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }

                                                // TextEditor with dynamic height
                                                CustomTextField(text: Binding(
                                                    get: { flashcard.question },
                                                    set: {
                                                        if let index = flashcardSet.flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                                                            flashcardSet.flashcards[index].question = $0
                                                        }
                                                    }
                                                ))
                                                .onAppear {
                                                    // Trigger an update after a short delay when the view appears
                                                    triggerTextFieldUpdates()
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    
                                    // Divider
                                    Rectangle()
                                        .fill(colors.boxBorderColor)
                                        .frame(height: 1)
                                        .padding(.horizontal, 32)
                                    
                                    // Answer
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("A:")
                                            .font(.system(size: 20, weight: .medium))
                                            .padding(.top, 8)
                                            .foregroundColor(colors.answerLabelColor)
                                        
                                        VStack {
                                            ZStack(alignment: .topLeading) {
                                                // Placeholder Text
                                                if flashcard.answer.isEmpty {
                                                    Text("Enter Answer")
                                                        .foregroundColor(Color.gray.opacity(0.6))
                                                        .font(.system(size: 20))
                                                        .padding(.leading, 10)
                                                        .padding(.top, 8)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }

                                                // TextEditor with dynamic height
                                                CustomTextField(text: Binding(
                                                    get: { flashcard.answer },
                                                    set: {
                                                        if let index = flashcardSet.flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                                                            flashcardSet.flashcards[index].answer = $0
                                                        }
                                                    }
                                                ))
                                                .onAppear {
                                                    // Trigger an update after a short delay when the view appears
                                                    triggerTextFieldUpdates()
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .padding(.leading, 2) // really weird behavior with this not sure why, but we need 2 pixels of leading space
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            // Find the index of the flashcard to be deleted
                                            if let index = flashcardSet.flashcards.firstIndex(where: { $0.id == flashcard.id }) {
                                                flashcardSet.flashcards.remove(at: index)
                                                
                                                try? modelContext.save() // Save after deletion
                                            }
                                        }
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.red)
                                                .frame(maxWidth: .infinity)
                                            Image(systemName: "trash")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                        }
                                    }
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
                            
                            // Add new card button (at the bottom)
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
                                    .shadow(radius: 5)
                                    .frame(height: 70)
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        let newCard = Flashcard(question: "New Question", answer: "New Answer", index: -1)
                                        flashcardSet.flashcards.append(newCard)
                                        // reindex after adding
//                                        flashcardSet.flashcards = normalizeFlashcardIndices(flashcards: flashcardSet.flashcards)
                                    }
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
                        .listStyle(PlainListStyle())
                        .environment(\.defaultMinListRowHeight, 0)
                        .scrollContentBackground(.hidden)
                    }
                    
                    // Bottom cutoff overlay
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(colors.cutoffColor)
                            .frame(height: 80)
                    }
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(.all, edges: .bottom)
                    
                    
                }
                
//                // Top cutoff overlay
//                VStack {
//                    Rectangle()
//                        .fill(colors.cutoffColor)
//                        .frame(height: 60)
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity)
//                .ignoresSafeArea(.all, edges: .top)
                
                VStack(spacing: 0) {
                    // Menu Options
                    if isMenuExpanded {
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
                    
                    // Button Row
                    ZStack(alignment: .center) {
                        // Search Button
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
                        
                        // Main Study Button
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
                        
                        // Profile Button
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
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                }
                
                if textFieldUpdateTrigger {
                    Color.clear.frame(width: 0, height: 0)
                } else {
                    Color.clear.frame(width: 0, height: 0)
                }
                
            }
            .background(colors.backgroundColor)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // Trigger an update after a short delay when the view appears
                triggerTextFieldUpdates()
            }
        }
    }
    
    func triggerTextFieldUpdates() {
        // Toggle the trigger with a slight delay to ensure it happens after other UI operations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            textFieldUpdateTrigger.toggle()
        }
    }
}

func normalizeFlashcardIndices(flashcards: [Flashcard]) -> [Flashcard] {
    // First sort the flashcards with special handling for 0 and -1
    let sortedFlashcards = flashcards.sorted { (card1, card2) -> Bool in
        // Special case: If index is 0, it goes to the beginning
        if card1.index == 0 {
            return true  // card1 comes before card2
        }
        if card2.index == 0 {
            return false // card2 comes before card1
        }
        
        // Special case: If index is -1, it goes to the end
        if card1.index == -1 {
            return false // card1 comes after card2
        }
        if card2.index == -1 {
            return true  // card2 comes after card1
        }
        
        // Normal case: Sort by index
        return card1.index < card2.index
    }
    
    // Create a copy of the sorted flashcards with normalized indices
    var normalizedFlashcards = [Flashcard]()
    
    // Assign new sequential indices starting from 1
    for (newIndex, flashcard) in sortedFlashcards.enumerated() {
        let updatedFlashcard = Flashcard(question: flashcard.question,
                                        answer: flashcard.answer,
                                        index: newIndex + 1) // +1 to start from 1 instead of 0
        
        // Copy the creation date from the original flashcard
        updatedFlashcard.creationDate = flashcard.creationDate
        
        normalizedFlashcards.append(updatedFlashcard)
    }
    
    return normalizedFlashcards
}



struct CustomTextField: View {
    @Binding var text: String
    
    @State private var offset: CGFloat = 0
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
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Only track downward movement
                        if value.translation.height > 0 {
                            self.offset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        // If the user swiped down with enough force, dismiss the keyboard
                        if value.translation.height > 20 && value.predictedEndTranslation.height > 40 {
                            hideKeyboard()
                        }
                        self.offset = 0
                    }
            )
    }
    
    // Helper function to dismiss the keyboard
    private func hideKeyboard() {
        isFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

#Preview {
    SetView2(flashcardSet: FlashcardSet(title: "Science", flashcards: [
        Flashcard(question: "What is H2O?", answer: "Water", index: 0),
        Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury", index: 1),
        Flashcard(question: "What is the hardest natural substance?", answer: "Diamond", index: 2),
        Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second", index: 3),
        Flashcard(question: "What is the largest organ in the human body?", answer: "Skin", index: 4),
        Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis", index: 5)
    ]))
}
