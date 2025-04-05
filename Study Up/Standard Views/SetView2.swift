////  SetView2.swift
////  Study Up
////
////  Created by Michael Kim on 3/9/25.
////
//
//import SwiftUI
//import SwiftData
//
//private var colors: AppColorScheme {
//    AppColorScheme(colorScheme: colorScheme)
//}
//
//struct SetView2: View {
//    @Bindable var flashcardSet: FlashcardSet
//    @State private var isMenuExpanded = false
//    
//    @Environment(\.dismiss) private var dismiss
//    @Environment(\.colorScheme) var colorScheme
//
//    @State private var textFieldUpdateTrigger = false
//
//    @Environment(\.modelContext) private var modelContext
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .bottom) {
//                VStack(spacing: 0) {
//                    // Title with back button
//                    ZStack {
//                        TextField("Enter Title", text: $flashcardSet.title)
//                            .padding(.vertical, 5) // Optional: Adjust spacing
//                            .background(Color.clear) // Removes background
//                            .border(Color.clear, width: 0) // Ensures no border
//                            .font(.system(size: 32, weight: .regular))
//                            .foregroundColor(colors.textColor)
//                            .padding(.top, 8)
//                            .multilineTextAlignment(.center)
//                        
//                        HStack {
//                            Button(action: {
//                                // Reindex the remaining flashcards to ensure proper ordering
//                                try? modelContext.save()
//                                dismiss()
//                            }) {
//                                Image(systemName: "chevron.left")
//                                    .font(.title2)
//                                    .foregroundColor(colors.textColor)
//                                    .padding()
//                            }
//                            Spacer()
//                        }
//                        .zIndex(1)
//                    }
//                    
//                    GeometryReader { geometry in
//                        List {
//                            // Flashcards - Iterate directly over the array
//                            // ForEach needs identifiable elements, Flashcard should conform or use id: \.id
//                            
//                            let sortedIndices = flashcardSet.flashcards.indices.sorted {
//                                (flashcardSet.flashcards[$0].index ?? 0) < (flashcardSet.flashcards[$1].index ?? 0)
//                            }
//                            
//                            ForEach(sortedIndices, id: \.self) { originalIndex in
//                                let flashcard = $flashcardSet.flashcards[originalIndex]
//                                VStack(alignment: .leading, spacing: 0) {
//                                    // Question
//                                    HStack(alignment: .top, spacing: 8) {
//                                        Text("Q:")
//                                            .padding(.top, 8)
//                                            .font(.system(size: 20, weight: .medium))
//                                            .foregroundColor(colors.questionLabelColor)
//                                        VStack {
//                                            ZStack(alignment: .topLeading) {
//                                                // Placeholder Text
//                                                if flashcard.question.isEmpty {
//                                                    Text("Enter Question")
//                                                        .foregroundColor(Color.gray.opacity(0.6))
//                                                        .font(.system(size: 20))
//                                                        .padding(.leading, 10)
//                                                        .padding(.top, 8)
//                                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                                        .allowsHitTesting(false) // Prevent placeholder from blocking tap
//                                                }
//
//                                                // Use the direct binding from ForEach
//                                                CustomTextField(text: flashcard.question)
//                                                    .onAppear {
//                                                        triggerTextFieldUpdates()
//                                                    }
//                                            }
//                                        }
//                                    }
//                                    .padding(.horizontal, 16)
//                                    .padding(.vertical, 12)
//                                    
//                                    // Divider
//                                    Rectangle()
//                                        .fill(colors.boxBorderColor)
//                                        .frame(height: 1)
//                                        .padding(.horizontal, 32)
//
//                                    // Answer
//                                    HStack(alignment: .top, spacing: 8) {
//                                        Text("A:")
//                                            .font(.system(size: 20, weight: .medium))
//                                            .padding(.top, 8)
//                                            .foregroundColor(colors.answerLabelColor)
//
//                                        VStack {
//                                            ZStack(alignment: .topLeading) {
//                                                // Placeholder Text
//                                                if flashcard.answer.isEmpty {
//                                                    Text("Enter Answer")
//                                                        .foregroundColor(Color.gray.opacity(0.6))
//                                                        .font(.system(size: 20))
//                                                        .padding(.leading, 10)
//                                                        .padding(.top, 8)
//                                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                                        .allowsHitTesting(false) // Prevent placeholder from blocking tap
//                                                }
//
//                                                // Use the direct binding from ForEach
//                                                CustomTextField(text: flashcard.answer)
//                                                    .onAppear {
//                                                        triggerTextFieldUpdates()
//                                                    }
//                                            }
//                                        }
//                                    }
//                                    .padding(.horizontal, 16)
//                                    .padding(.vertical, 12)
//                                    .padding(.leading, 2)
//                                }
//                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                    Button(role: .destructive) {
//                                        withAnimation {
//                                            flashcardSet.remove(flashcardToRemove: flashcard, modelContext: modelContext)
//                                        }
//                                    } label: {
//                                        Label("Delete", systemImage: "trash")
//                                    }
//                                    .tint(.red)
//                                }
//                                .background(colors.boxColor)
//                                .cornerRadius(12)
//                                .shadow(radius: 3)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(colors.boxBorderColor, lineWidth: 1)
//                                )
//                                .listRowSeparator(.hidden)
//                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//                                .listRowBackground(Color.clear)
//                            }
//                            .onMove(perform: moveFlashcard)
//                        }
//                        .listStyle(PlainListStyle())
//                        .environment(\.defaultMinListRowHeight, 0)
//                        .scrollContentBackground(.hidden)
//                    }
//                    
//                    // Bottom cutoff overlay
//                    VStack(spacing: 0) {
//                        Rectangle()
//                            .fill(colors.cutoffColor)
//                            .frame(height: 80)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .ignoresSafeArea(.all, edges: .bottom)
//                    
//                    
//                }
//                
////                // Top cutoff overlay
////                VStack {
////                    Rectangle()
////                        .fill(colors.cutoffColor)
////                        .frame(height: 60)
////                    Spacer()
////                }
////                .frame(maxWidth: .infinity)
////                .ignoresSafeArea(.all, edges: .top)
//                
//                VStack(spacing: 0) {
//                    // Menu Options
//                    if isMenuExpanded {
//                        VStack(spacing: 10) {
//                            NavigationLink(destination: FlashcardView(flashcardSet: flashcardSet)) {
//                                MenuOptionButton(title: "Standard", icon: "rectangle.fill")
//                            }
//                            NavigationLink(destination: HorizontalFlashcardView(flashcardSet: flashcardSet)) {
//                                MenuOptionButton(title: "Motion", icon: "iphone.and.arrow.forward")
//                            }
//                            Button(action: {
//                                // Placeholder for future functionality
//                            }) {
//                                MenuOptionButton(title: "Coming Soon", icon: "clock.fill")
//                            }
//                        }
//                        .transition(.move(edge: .bottom).combined(with: .opacity))
//                        .padding(.bottom, 10)
//                    }
//                    
//                    // Button Row
//                    ZStack(alignment: .center) {
//                        // Search Button
//                        Button(action: {
//                            // Search functionality will go here
//                        }) {
//                            Image(systemName: "magnifyingglass")
//                                .font(.system(size: 20, weight: .bold))
//                                .foregroundColor(colors.textColor)
//                                .frame(width: 50, height: 50)
//                                .background(colors.boxColor)
//                                .clipShape(Circle())
//                                .shadow(radius: 5)
//                        }
//                        .offset(x: -((UIScreen.main.bounds.width * 0.6) / 2 + 35))
//                        
//                        // Main Study Button
//                        Button(action: {
//                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                isMenuExpanded.toggle()
//                            }
//                        }) {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 8)
//                                    .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
//                                    .shadow(radius: 5)
//                                
//                                Label("Study", systemImage: isMenuExpanded ? "xmark" : "book.fill")
//                                    .font(.title)
//                                    .foregroundColor(colors.buttonTextColor)
//                            }
//                        }
//                        .frame(height: 50)
//                        .frame(width: UIScreen.main.bounds.width * 0.6)
//                        
//                        // Profile Button
//                        Button(action: {
//                            // Profile functionality will go here
//                        }) {
//                            Image(systemName: "person.fill")
//                                .font(.system(size: 20, weight: .bold))
//                                .foregroundColor(colors.textColor)
//                                .frame(width: 50, height: 50)
//                                .background(colors.boxColor)
//                                .clipShape(Circle())
//                                .shadow(radius: 5)
//                        }
//                        .offset(x: ((UIScreen.main.bounds.width * 0.6) / 2 + 35))
//                    }
//                    .padding(.bottom, 10)
//                    .padding(.horizontal, 20)
//                }
//                
//                if textFieldUpdateTrigger {
//                    Color.clear.frame(width: 0, height: 0)
//                } else {
//                    Color.clear.frame(width: 0, height: 0)
//                }
//                
//            }
//            .background(colors.backgroundColor)
//            .navigationBarBackButtonHidden(true)
//            .onAppear {
//                // Trigger an update after a short delay when the view appears
//                triggerTextFieldUpdates()
//            }
//        }
//    }
//    func moveFlashcard(from source: IndexSet, to destination: Int) {
//        flashcardSet.flashcards.move(fromOffsets: source, toOffset: destination)
//        // Explicit save might be needed after reordering if auto-save doesn't cover moves
//        try? modelContext.save()
//    }
//    
//    func triggerTextFieldUpdates() {
//        // Toggle the trigger with a slight delay to ensure it happens after other UI operations
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            textFieldUpdateTrigger.toggle()
//        }
//    }
//}
//
//private var cardListView: some View {
//    List {
//        addNewCardButton()
//        flashcardsList()
//        addNewCardButton()
//    }
//    .listStyle(PlainListStyle())
//    .environment(\.defaultMinListRowHeight, 0)
//    .scrollContentBackground(.hidden)
//}
//
//private var addNewCardButton: some View {
//    ZStack {
//        RoundedRectangle(cornerRadius: 8)
//            .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
//            .shadow(radius: 5)
//            .frame(height: 70)
//
//        Button(action: {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                // Create a new card without an index
//                let newCard = Flashcard(question: "New Question", answer: "New Answer")
//                // Assign the relationship back to the set
//                // Insert at the beginning of the array
//                flashcardSet.insert(flashcard: newCard, modelContext: modelContext)
//                // Explicit save might be needed depending on context, but often @Bindable handles it
//                // try? modelContext.save()
//            }
//        }) {
//            Text("Add new Card")
//                .font(.headline)
//                .foregroundColor(colors.buttonTextColor)
//                .frame(maxWidth: .infinity)
//        }
//    }
//    .listRowSeparator(.hidden)
//    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//    .listRowBackground(Color.clear)
//}
//
//
//private var flashcardsList: some View {
//    let sortedIndices = flashcardSet.flashcards.indices.sorted {
//        (flashcardSet.flashcards[$0].index ?? 0) < (flashcardSet.flashcards[$1].index ?? 0)
//    }
//    
//    return ForEach(sortedIndices, id: \.self) { originalIndex in
//        flashcardView(for: $flashcardSet.flashcards[originalIndex])
//    }
//    .onMove(perform: moveFlashcard)
//}
//
//private func flashcardView(for flashcard: Binding<Flashcard>) -> some View {
//    VStack(alignment: .leading, spacing: 0) {
//        // Question section
//        questionSection(for: flashcard)
//        
//        // Divider
//        Rectangle()
//            .fill(colors.boxBorderColor)
//            .frame(height: 1)
//            .padding(.horizontal, 32)
//        
//        // Answer section
//        answerSection(for: flashcard)
//    }
//    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//        Button(role: .destructive) {
//            withAnimation {
//                flashcardSet.remove(flashcardToRemove: flashcard, modelContext: modelContext)
//            }
//        } label: {
//            Label("Delete", systemImage: "trash")
//        }
//        .tint(.red)
//    }
//    .background(colors.boxColor)
//    .cornerRadius(12)
//    .shadow(radius: 3)
//    .overlay(
//        RoundedRectangle(cornerRadius: 12)
//            .stroke(colors.boxBorderColor, lineWidth: 1)
//    )
//    .listRowSeparator(.hidden)
//    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//    .listRowBackground(Color.clear)
//}
//
//
//struct CustomTextField: View {
//    @Binding var text: String
//    
//    @State private var offset: CGFloat = 0
//    @FocusState private var isFocused: Bool
//    
//    var body: some View {
//        TextEditor(text: $text)
//            .font(.system(size: 20))
//            .multilineTextAlignment(.leading)
//            .background(Color.clear)
//            .scrollContentBackground(.hidden)
//            .padding([.leading, .trailing], 5)
//            .frame(minHeight: 40, maxHeight: .infinity)
//            .fixedSize(horizontal: false, vertical: true)
////            .highPriorityGesture(
////                DragGesture()
////                    .onChanged { value in
////                        // Only track downward movement
////                        if value.translation.height > 0 {
////                            self.offset = value.translation.height
////                        }
////                    }
////                    .onEnded { value in
////                        // If the user swiped down with enough force, dismiss the keyboard
////                        if value.translation.height > 20 && value.predictedEndTranslation.height > 40 {
////                            hideKeyboard()
////                        }
////                        self.offset = 0
////                    }
////                }
////            )
//    }
//    
//    // Helper function to dismiss the keyboard
//    private func hideKeyboard() {
//        isFocused = false
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//
//struct MenuOptionButton: View {
//    let title: String
//    let icon: String
//    @Environment(\.colorScheme) var colorScheme
//    
//    private var colors: AppColorScheme {
//        AppColorScheme(colorScheme: colorScheme)
//    }
//    
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .font(.system(size: 20))
//            Text(title)
//                .font(.headline)
//            Spacer()
//            Image(systemName: "chevron.right")
//                .font(.system(size: 14, weight: .bold))
//        }
//        .foregroundColor(colors.textColor)
//        .padding()
//        .frame(width: UIScreen.main.bounds.width * 0.6)
//        .background(colors.boxColor)
//        .cornerRadius(8)
//        .shadow(radius: 3)
//    }
//}
//
//#Preview {
//    SetView2(flashcardSet: FlashcardSet(title: "Science", flashcards: [
//        Flashcard(question: "What is H2O?", answer: "Water"),
//        Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury"),
//        Flashcard(question: "What is the hardest natural substance?", answer: "Diamond"),
//        Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second"),
//        Flashcard(question: "What is the largest organ in the human body?", answer: "Skin"),
//        Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis")
//    ]))
//}
