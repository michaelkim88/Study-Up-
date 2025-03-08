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
    
    var body: some View {
        HStack(spacing: 0) {
            // Main content
            VStack(spacing: 20) {
                // Title and card count
                VStack {
                    Text(flashcardSet.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("\(flashcardSet.flashcards.count) cards")
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
                    
                    Button(action: {
                        // Edit functionality will be added later
                    }) {
                        Label("Edit", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // Centered card scroll view
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        ScrollViewReader { proxy in
                            VStack(spacing: 0) {
                                ForEach(Array(flashcardSet.flashcards.enumerated()), id: \.element.id) { index, card in
                                    VStack {
                                        Text(card.question)
                                            .font(.title2)
                                            .multilineTextAlignment(.center)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: geometry.size.height)
                                            .background(Color(.systemBackground))
                                            .cornerRadius(10)
                                            .shadow(radius: 3)
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
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            
            // Scrubbing bar
            GeometryReader { geometry in
                VStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 40)
                        .overlay {
                            VStack(spacing: 8) {
                                ForEach(0..<flashcardSet.flashcards.count, id: \.self) { index in
                                    Text("\(index + 1)")
                                        .font(.caption)
                                        .foregroundColor(currentIndex == index ? .white : .gray)
                                        .frame(width: 30, height: 30)
                                        .background(currentIndex == index ? Color.blue : Color.clear)
                                        .clipShape(Circle())
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
                                        currentIndex = newIndex
                                    }
                                }
                        )
                }
            }
            .frame(width: 40)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
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
