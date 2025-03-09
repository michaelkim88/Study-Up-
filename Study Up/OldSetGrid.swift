//
//  FlashcardSetGridView.swift
//  Study Up
//
//  Created by Trevor Smith on 3/4/25.
//

import SwiftUI
import CoreMotion

struct FlashcardSetGridView: View {
    let flashcardSets: [FlashcardSet] = [
        FlashcardSet(title: "Math Basics", flashcards: [
            Flashcard(question: "What is 2+2?", answer: "4"),
            Flashcard(question: "What is 7 x 8?", answer: "56"),
            Flashcard(question: "What is the square root of 16?", answer: "4"),
            Flashcard(question: "What is π (pi) rounded to 2 decimal places?", answer: "3.14"),
            Flashcard(question: "What is 15% of 200?", answer: "30"),
            Flashcard(question: "What is the formula for the area of a circle?", answer: "πr²")
        ]),
        FlashcardSet(title: "History", flashcards: [
            Flashcard(question: "Who discovered America?", answer: "Columbus"),
            Flashcard(question: "In what year did World War II end?", answer: "1945"),
            Flashcard(question: "Who was the first President of the United States?", answer: "George Washington"),
            Flashcard(question: "What ancient wonder was located in Alexandria?", answer: "The Great Lighthouse"),
            Flashcard(question: "Which empire built the Pyramids?", answer: "Ancient Egyptian Empire"),
            Flashcard(question: "When did the Berlin Wall fall?", answer: "1989")
        ]),
        FlashcardSet(title: "Science", flashcards: [
            Flashcard(question: "What is H2O?", answer: "Water"),
            Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury"),
            Flashcard(question: "What is the hardest natural substance?", answer: "Diamond"),
            Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second"),
            Flashcard(question: "What is the largest organ in the human body?", answer: "Skin"),
            Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis")
        ]),
        FlashcardSet(title: "Languages", flashcards: [
            Flashcard(question: "Hola means?", answer: "Hello"),
            Flashcard(question: "Bonjour means?", answer: "Good day/Hello"),
            Flashcard(question: "Gracias means?", answer: "Thank you"),
            Flashcard(question: "Comment allez-vous means?", answer: "How are you?"),
            Flashcard(question: "Guten Tag means?", answer: "Good day"),
            Flashcard(question: "Ciao means?", answer: "Hello/Goodbye")
        ])
    ]
        
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(flashcardSets) { set in
                        NavigationLink(destination: FlashcardSetDetailView(flashcardSet: set)) {
                            Text(set.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .background(.gray)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 10)
                                    )
                                .padding(.vertical, 3)
                                .padding(.horizontal, 2.0)
                        }
                        .foregroundColor(.black)
                    }
                }
                .padding(.all)
            }
        }
    }
}

struct StudyModeView: View {
    let flashcardSet: FlashcardSet
    @State private var currentCardIndex = 0
    @State private var isShowingAnswer = false
    @State private var motionManager = CMMotionManager()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if currentCardIndex < flashcardSet.flashcards.count {
                    let card = flashcardSet.flashcards[currentCardIndex]
                    
                    VStack {
                        Spacer()
                        Text(isShowingAnswer ? card.answer : card.question)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .padding()
                            .rotationEffect(.degrees(-90))
                            .frame(width: geometry.size.height, height: geometry.size.width)
                            .onTapGesture {
                                withAnimation {
                                    isShowingAnswer.toggle()
                                }
                            }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    VStack {
                        Text("Study Session Complete!")
                            .font(.title)
                            .padding()
                        Button("Start Over") {
                            currentCardIndex = 0
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .onAppear {
            setupMotionManager()
        }
        .onDisappear {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    private func setupMotionManager() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
                guard let motion = motion else { return }
                
                // Detect significant pitch changes (phone tilting forward/backward)
                if motion.attitude.pitch > 0.5 { // Tilted forward
                    handleIncorrectCard()
                } else if motion.attitude.pitch < -0.5 { // Tilted backward
                    handleCorrectCard()
                }
            }
        }
    }
    
    private func handleCorrectCard() {
        guard currentCardIndex < flashcardSet.flashcards.count else { return }
        withAnimation {
            currentCardIndex += 1
            isShowingAnswer = false
        }
    }
    
    private func handleIncorrectCard() {
        guard currentCardIndex < flashcardSet.flashcards.count - 1 else { return }
        withAnimation {
            // Note: In a real implementation, we'd want to modify the actual flashcards array
            currentCardIndex += 1
            isShowingAnswer = false
        }
    }
}

// Card View Component
struct FlashcardView: View {
    let card: Flashcard
    let index: Int
    let isFlipped: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(isFlipped ? "Answer" : "Question")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            ZStack {
                // Question side
                Text(card.question)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .frame(width: 300, height: 200)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                
                // Answer side
                Text(card.answer)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .frame(width: 300, height: 200)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.green, lineWidth: 2)
                    )
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(isFlipped ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0)
                    )
            }
            .onTapGesture(perform: onTap)
            .onLongPressGesture(perform: onLongPress)
        }
    }
}


// Navigation Buttons Component
struct NavigationButtonsView: View {
    let flashcardSet: FlashcardSet
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: Text("Edit Mode - Coming Soon")) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.title2)
                    Text("Edit Flashcards")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            NavigationLink(destination: StudyModeView(flashcardSet: flashcardSet)) {
                HStack {
                    Image(systemName: "book.fill")
                        .font(.title2)
                    Text("Study Flashcards")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

// Edit Sheet Component
struct EditSheetView: View {
    let isQuestion: Bool
    @Binding var editText: String
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Text(isQuestion ? "Edit Question" : "Edit Answer")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $editText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Cancel", action: onCancel),
                trailing: Button("Save", action: onSave)
            )
        }
    }
}

// Carousel View Component
struct CarouselView: View {
    let geometry: GeometryProxy
    let flashcardSet: FlashcardSet
    @Binding var currentIndex: Int
    @Binding var flippedCards: Set<Int>
    @Binding var editingCard: (index: Int, isQuestion: Bool)?
    @Binding var editText: String
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(flashcardSet.flashcards.enumerated()), id: \.offset) { index, card in
                        FlashcardView(
                            card: card,
                            index: index,
                            isFlipped: flippedCards.contains(index),
                            onTap: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    if flippedCards.contains(index) {
                                        flippedCards.remove(index)
                                    } else {
                                        flippedCards.insert(index)
                                    }
                                }
                            },
                            onLongPress: {
                                editingCard = (index, !flippedCards.contains(index))
                                editText = flippedCards.contains(index) ? card.answer : card.question
                            }
                        )
                        .frame(width: geometry.size.width)
                        .id(index)
                        .onAppear {
                            currentIndex = index
                        }
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .onChange(of: currentIndex) { oldValue, newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

struct FlashcardSetDetailView: View {
    let flashcardSet: FlashcardSet
    @State private var selectedMode: StudyMode?
    @State private var flippedCards: Set<Int> = []
    @State private var editingCard: (index: Int, isQuestion: Bool)? = nil
    @State private var editText: String = ""
    @State private var currentIndex: Int = 0
    
    enum StudyMode: String, Identifiable {
        case edit = "Edit"
        case study = "Study"
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to \(flashcardSet.title)!")
                .font(.title)
                .padding()
            
            NavigationButtonsView(flashcardSet: flashcardSet)
            
            Spacer()
            
            GeometryReader { geometry in
                CarouselView(
                    geometry: geometry,
                    flashcardSet: flashcardSet,
                    currentIndex: $currentIndex,
                    flippedCards: $flippedCards,
                    editingCard: $editingCard,
                    editText: $editText
                )
            }
            .frame(height: 350)
            
        }
        .navigationTitle(flashcardSet.title)
        .sheet(item: Binding(
            get: { editingCard.map { EditingCard(index: $0.index, isQuestion: $0.isQuestion) } },
            set: { editingCard = $0.map { ($0.index, $0.isQuestion) } }
        )) { editing in
            EditSheetView(
                isQuestion: editing.isQuestion,
                editText: $editText,
                onCancel: { editingCard = nil },
                onSave: { editingCard = nil }
            )
        }
    }
}


#Preview {
    FlashcardSetGridView()
}
