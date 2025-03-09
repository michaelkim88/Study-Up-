//
//  SetView.swift
//  Study Up
//
//  Created by Trevor Smith on 3/8/25.
//

import SwiftUI

struct SetView: View {
    let flashcardSet: FlashcardSet
    @State private var currentIndex: Int = 0
    @State private var flippedCards: Set<Int> = []
    @State private var editingCard: (index: Int, isQuestion: Bool)? = nil
    @State private var editText: String = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                // Main content
                VStack(spacing: 20) {
                    // Title and card count
                    VStack {
                        Text(flashcardSet.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)
                    }
                    
                    // Centered card scroll view
                    GeometryReader { geometry in
                        ScrollView(.vertical, showsIndicators: false) {
                            ScrollViewReader { proxy in
                                VStack(spacing: 0) {
                                    ForEach(Array(flashcardSet.flashcards.enumerated()), id: \.element.id) { index, card in
                                        VStack {
                                            ZStack {
                                                // Question side
                                                Text(card.question)
                                                    .font(.title2)
                                                    .multilineTextAlignment(.center)
                                                    .padding()
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: geometry.size.height)
                                                    .background(Color(.systemBackground))
                                                    .cornerRadius(10)
                                                    .shadow(radius: 3)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.blue, lineWidth: 2)
                                                    )
                                                    .opacity(flippedCards.contains(index) ? 0 : 1)
                                                    .rotation3DEffect(
                                                        .degrees(flippedCards.contains(index) ? 180 : 0),
                                                        axis: (x: 0, y: 1, z: 0)
                                                    )
                                                
                                                // Answer side
                                                Text(card.answer)
                                                    .font(.title2)
                                                    .multilineTextAlignment(.center)
                                                    .padding()
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: geometry.size.height)
                                                    .background(Color(.systemBackground))
                                                    .cornerRadius(10)
                                                    .shadow(radius: 3)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.green, lineWidth: 2)
                                                    )
                                                    .opacity(flippedCards.contains(index) ? 1 : 0)
                                                    .rotation3DEffect(
                                                        .degrees(flippedCards.contains(index) ? 0 : -180),
                                                        axis: (x: 0, y: 1, z: 0)
                                                    )
                                            }
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
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
                                        .id(index)
                                        .frame(height: geometry.size.height)
                                    }
                                }
                                .onChange(of: currentIndex) { oldValue, newValue in
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        proxy.scrollTo(newValue, anchor: .center)
                                    }
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                        .scrollDisabled(false)
                        .simultaneousGesture(
                            DragGesture()
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    if value.translation.height > threshold && currentIndex > 0 {
                                        currentIndex -= 1
                                    } else if value.translation.height < -threshold && currentIndex < flashcardSet.flashcards.count - 1 {
                                        currentIndex += 1
                                    }
                                }
                        )
                    }
                    .padding(.leading)
                }
                .frame(maxWidth: .infinity)
                
                // Scrubbing bar
                GeometryReader { geometry in
                    VStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.0001))
                            .frame(width: 20)
                            .overlay {
                                VStack(spacing: 8) {
                                    ForEach(0..<flashcardSet.flashcards.count, id: \.self) { index in
                                        Button(action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                currentIndex = index
                                            }
                                        }) {
                                            Text("\(index + 1)")
                                                .font(.caption)
                                                .foregroundColor(currentIndex == index ? .white : .gray)
                                                .frame(width: 20, height: 30)
                                                .background(currentIndex == index ? Color.blue : Color.clear)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let cardHeight = (geometry.size.height - 40) / CGFloat(flashcardSet.flashcards.count)
                                        let newIndex = Int((value.location.y - 20) / cardHeight)
                                        if newIndex >= 0 && newIndex < flashcardSet.flashcards.count {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                currentIndex = newIndex
                                            }
                                        }
                                    }
                            )
                    }
                }
                .frame(width: 20)
            }
            .navigationBarTitleDisplayMode(.inline)
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
                        leading: Button("Cancel") { editingCard = nil },
                        trailing: Button("Save") { editingCard = nil }
                    )
                }
            }
            // Study and Edit buttons
            HStack(spacing: 20) {
                NavigationLink(destination: StudyModeView(flashcardSet: flashcardSet)) {
                    Label("Study", systemImage: "book.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
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
    NavigationView {
        SetView(flashcardSet: FlashcardSet(title: "Placeholder Set", flashcards: [
            
                Flashcard(question: "What is H2O?", answer: "Water"),
                Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury"),
                Flashcard(question: "What is the hardest natural substance?", answer: "Diamond"),
                Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second"),
                Flashcard(question: "What is the largest organ in the human body?", answer: "Skin"),
                Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis")
            ]))
    }
}
