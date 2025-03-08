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
            Flashcard(question: "What is 2+2?", answer: "4")
        ]),
        FlashcardSet(title: "History", flashcards: [
            Flashcard(question: "Who discovered America?", answer: "Columbus")
        ]),
        FlashcardSet(title: "Science", flashcards: [
            Flashcard(question: "What is H2O?", answer: "Water")
        ]),
        FlashcardSet(title: "Languages", flashcards: [
            Flashcard(question: "Hola means?", answer: "Hello")
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
                                            .stroke(Color.blue, lineWidth: 6)
                                    )
                                .padding(.vertical, -4.0)
                                .padding(.horizontal, 2.0)
                        }
                        .foregroundColor(.black)
                    }
                }
                .padding(.all)
            }
            .navigationTitle("Study Sets")
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
            // Move the current card to the end of the deck
            let currentCard = flashcardSet.flashcards[currentCardIndex]
            // Note: In a real implementation, we'd want to modify the actual flashcards array
            currentCardIndex += 1
            isShowingAnswer = false
        }
    }
}

struct FlashcardSetDetailView: View {
    let flashcardSet: FlashcardSet
    @State private var selectedMode: StudyMode?
    @State private var flippedCards: Set<Int> = []
    @State private var editingCard: (index: Int, isQuestion: Bool)? = nil
    @State private var editText: String = ""
    
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
            
            Spacer()
            
            // Horizontal flashcard preview
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(flashcardSet.flashcards.enumerated()), id: \.offset) { index, card in
                        VStack {
                            Text(flippedCards.contains(index) ? "Answer" : "Question")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Text(flippedCards.contains(index) ? card.answer : card.question)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .frame(width: 120, height: 80)
                                .padding(8)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        if flippedCards.contains(index) {
                                            flippedCards.remove(index)
                                        } else {
                                            flippedCards.insert(index)
                                        }
                                    }
                                }
                                .onLongPressGesture {
                                    editingCard = (index, !flippedCards.contains(index))
                                    editText = flippedCards.contains(index) ? card.answer : card.question
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 150)
        }
        .navigationTitle(flashcardSet.title)
        .sheet(item: Binding(
            get: { editingCard.map { EditingCard(index: $0.index, isQuestion: $0.isQuestion) } },
            set: { editingCard = $0.map { ($0.index, $0.isQuestion) } }
        )) { editing in
            NavigationView {
                VStack {
                    Text(editing.isQuestion ? "Edit Question" : "Edit Answer")
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
                    leading: Button("Cancel") {
                        editingCard = nil
                    },
                    trailing: Button("Save") {
                        // Here you would update the actual flashcard
                        editingCard = nil
                    }
                )
            }
        }
    }
}

struct EditingCard: Identifiable {
    let index: Int
    let isQuestion: Bool
    var id: Int { index }
}

#Preview {
    FlashcardSetGridView()
}
