//
//  StudyView.swift
//  Study Up
//
//  Created by Michael Kim on 3/9/25.
//

import SwiftUI

struct FlashcardView: View {
    let flashcards: [Flashcard]
    @State private var currentIndex = 0
    @State private var knownCount = 0
    @State private var unknownCount = 0
    @State private var offset: CGSize = .zero
    @State private var isShowingAnswer = false
    
    var body: some View {
        VStack {
            // Stats at the top
            HStack(spacing: 40) {
                VStack {
                    Text("Known")
                        .font(.headline)
                    Text("\(knownCount)")
                        .font(.title)
                        .foregroundColor(.green)
                }
                
                VStack {
                    Text("Unknown")
                        .font(.headline)
                    Text("\(unknownCount)")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
            .padding(.top)
            
            // Flashcard
            ZStack {
                if currentIndex < flashcards.count {
                    VStack {
                        // Question side
                        Text(flashcards[currentIndex].question)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .opacity(isShowingAnswer ? 0 : 1)
                            .rotation3DEffect(
                                .degrees(isShowingAnswer ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                        
                        // Answer side
                        Text(flashcards[currentIndex].answer)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green, lineWidth: 2)
                            )
                            .opacity(isShowingAnswer ? 1 : 0)
                            .rotation3DEffect(
                                .degrees(isShowingAnswer ? 0 : -180),
                                axis: (x: 0, y: 1, z: 0)
                            )
                    }
                    .offset(offset)
                    .rotationEffect(.degrees(Double(offset.width / 15)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    swipeCard(width: gesture.translation.width)
                                }
                            }
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isShowingAnswer.toggle()
                        }
                    }
                } else {
                    Text("No more cards!")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    private func swipeCard(width: CGFloat) {
        let swipeThreshold: CGFloat = 100
        
        if width > swipeThreshold {
            // Swipe right - Known
            knownCount += 1
            moveToNextCard()
        } else if width < -swipeThreshold {
            // Swipe left - Unknown
            unknownCount += 1
            moveToNextCard()
        }
        
        // Reset offset
        offset = .zero
    }
    
    private func moveToNextCard() {
        if currentIndex < flashcards.count - 1 {
            currentIndex += 1
            isShowingAnswer = false
        }
    }
}

#Preview {
    FlashcardView(flashcards: [
        Flashcard(question: "What is H2O?", answer: "Water"),
        Flashcard(question: "What is the capital of France?", answer: "Paris"),
        Flashcard(question: "What is 2+2?", answer: "4")
    ])
}
