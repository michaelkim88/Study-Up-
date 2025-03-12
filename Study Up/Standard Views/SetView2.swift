//
//  SetView2.swift
//  Study Up
//
//  Created by Michael Kim on 3/9/25.
//

import SwiftUI

struct SetView2: View {
    let flashcardSet: FlashcardSet
    @State private var editingCard: (index: Int, isQuestion: Bool)? = nil
    @State private var editText: String = ""
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        NavigationStack {
            VStack {
                ZStack{
                    Text(flashcardSet.title)
                        .font(.system(size: 32, weight: .regular))
                        .foregroundColor(Color.black)
                        .zIndex(1)
                        .padding(.top, 8)
                        .multilineTextAlignment(.center)
                    HStack{
                        Button(action: {
                            dismiss() // Dismiss the current view
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding()
                        }
                        Spacer()
                    }
                }
                

                
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 16) {
                            ForEach(Array(flashcardSet.flashcards.enumerated()), id: \.element.id) { index, card in
                                VStack(alignment: .leading, spacing: 0) {
                                    // Question
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("Q:")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.blue)
                                        Text(card.question)
                                            .font(.system(size: 20))
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    
                                    // Divider
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                        .padding(.horizontal, 32)
                                    
                                    // Answer
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("A:")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.green)
                                        Text(card.answer)
                                            .font(.system(size: 20))
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal, 16)
                                .onLongPressGesture {
                                    editingCard = (index, true)
                                    editText = card.question
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
                        
                // Search, Study, and profile buttons
                HStack(spacing: 24) {
                    // Search Button
                    Button(action: {
                        // Search functionality will go here
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color(red: 0.25, green: 0.25, blue: 0.3))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    // Study Options button
                    NavigationLink(destination: FlashcardView(flashcardSet: flashcardSet)) {
                        Label("Study", systemImage: "book.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(red: 0.05, green: 0.05, blue: 0.2))
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 60)
                            .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    
                    // Profile Button
                    Button(action: {
                        // Profile functionality will go here
                    }) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color(red: 0.25, green: 0.25, blue: 0.3))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding(.bottom, 16)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    SetView2(flashcardSet: FlashcardSet(title: "Science", flashcards: [
        
        Flashcard(question: "What is H2O?", answer: "Water"),
        Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury"),
        Flashcard(question: "What is the hardest natural substance?", answer: "Diamond"),
        Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second"),
        Flashcard(question: "What is the largest organ in the human body?", answer: "Skin"),
        Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis")
    ]))
}
