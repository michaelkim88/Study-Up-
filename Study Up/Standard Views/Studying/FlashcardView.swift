//
//  StudyView.swift
//  Study Up
//
//  Created by Michael Kim on 3/9/25.
//

import SwiftUI

struct FlashcardView: View {
    let flashcardSet: FlashcardSet
    @State private var currentIndex = 0
    @State private var editingCard: (index: Int, isQuestion: Bool)? = nil
    @State private var flippedCards: Set<Int> = []
    @State private var editText: String = ""
    @State private var knownCount = 0
    @State private var unknownCount = 0
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var isPressed = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        // Flashcard
        GeometryReader { geometry in
            if currentIndex != flashcardSet.count {
                VStack {
                    // Back button and stats in the same HStack
                    ZStack{
                        // Stats centered
                        HStack(spacing: 40) {
                            VStack {
                                Text("\(unknownCount)")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                            
                            VStack {
                                Text("\(knownCount)")
                                    .font(.title)
                                    .foregroundColor(.green)
                            }
                        }
                        HStack {
                            Button(action: {
                                dismiss() // Dismiss the current view
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                    }
                    
// THIS NEEDS TO BE CHANGED
//                    let card = flashcardSet.head
//                    ZStack {
//                        // Question side
//                        Text(card?.question?)
//                            .font(.title2)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: geometry.size.height)
//                            .background(Color(.systemBackground))
//                            .cornerRadius(10)
//                            .shadow(radius: 3)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.blue, lineWidth: 2)
//                            )
//                            .opacity(flippedCards.contains(currentIndex) ? 0 : 1)
//                            .rotation3DEffect(
//                                .degrees(flippedCards.contains(currentIndex) ? 180 : 0),
//                                axis: (x: 0, y: 1, z: 0)
//                            )
//                        
//                        // Answer side
//                        Text(card.answer)
//                            .font(.title2)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: geometry.size.height)
//                            .background(Color(.systemBackground))
//                            .cornerRadius(10)
//                            .shadow(radius: 3)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.green, lineWidth: 2)
//                            )
//                            .opacity(flippedCards.contains(currentIndex) ? 1 : 0)
//                            .rotation3DEffect(
//                                .degrees(flippedCards.contains(currentIndex) ? 0 : -180),
//                                axis: (x: 0, y: 1, z: 0)
//                            )
//                    }
//                    .offset(offset)
//                    .rotationEffect(.degrees(Double(offset.width / 15)))
//                    .gesture(
//                        DragGesture(minimumDistance: 10)
//                            .onChanged { gesture in
//                                offset = gesture.translation
//                            }
//                            .onEnded { gesture in
//                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                    handleSwipe(gesture.translation)
//                                }
//                            }
//                    )
//                    .simultaneousGesture(
//                        TapGesture()
//                            .onEnded {
//                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                                    if flippedCards.contains(currentIndex) {
//                                        flippedCards.remove(currentIndex)
//                                    } else {
//                                        flippedCards.insert(currentIndex)
//                                    }
//                                }
//                            }
//                    )
//                    .onLongPressGesture {
//                        editingCard = (currentIndex, !flippedCards.contains(currentIndex))
//                        editText = flippedCards.contains(currentIndex) ? card?.answer : card?.question
//                    }
                }
                .navigationBarBackButtonHidden(true)
            } else {
                EndStudyView(flashcardSet: flashcardSet)
            }
        }
        .padding()
        Spacer()
    }
    
    private func handleSwipe(_ translation: CGSize) {
        let horizontalThreshold: CGFloat = 100
        
        if translation.width > horizontalThreshold {
            // Swipe right - Known
            knownCount += 1
            moveToNextCard()
        } else if translation.width < -horizontalThreshold {
            // Swipe left - Unknown
            unknownCount += 1
            moveToNextCard()
        }
        
        // Reset offset
        offset = .zero
    }
    
    private func moveToNextCard() {
        if currentIndex < flashcardSet.count {
            currentIndex += 1
            rotation = 0
        }
    }
}

#Preview {
    
}
