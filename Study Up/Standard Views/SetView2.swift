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
    @Environment(\.colorScheme) var colorScheme
    
    // Use shared color scheme
    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 16) {
                            // Title with back button
                            ZStack {
                                Text(flashcardSet.title)
                                    .font(.system(size: 32, weight: .regular))
                                    .foregroundColor(colors.textColor)
                                    .zIndex(1)
                                    .padding(.top, 8)
                                    .multilineTextAlignment(.center)
                                HStack {
                                    Button(action: {
                                        dismiss()
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .font(.title2)
                                            .foregroundColor(colors.textColor)
                                            .padding()
                                    }
                                    Spacer()
                                }
                            }
                            
                            // Flashcards
                            ForEach(Array(flashcardSet.flashcards.enumerated()), id: \.element.id) { index, card in
                                VStack(alignment: .leading, spacing: 0) {
                                    // Question
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("Q:")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(colors.textColor)
                                        Text(card.question)
                                            .font(.system(size: 20))
                                            .foregroundColor(colors.textColor)
                                            .multilineTextAlignment(.leading)
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
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(colors.textColor)
                                        Text(card.answer)
                                            .font(.system(size: 20))
                                            .foregroundColor(colors.textColor)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                .background(colors.boxColor)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(colors.boxBorderColor, lineWidth: 1)
                                )
                                .padding(.horizontal, 16)
                                .onLongPressGesture {
                                    editingCard = (index, true)
                                    editText = card.question
                                }
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 150)
                    }
                }
                
                // Top cutoff overlay
                VStack {
                    Rectangle()
                        .fill(colors.cutoffColor)
                        .frame(height: 60)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .top)
                
                // Bottom cutoff overlay
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(colors.cutoffColor)
                        .frame(height: 120)
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .bottom)
                
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
                    
                    // Study Button (matching AddButton style)
                    NavigationLink(destination: FlashcardView(flashcardSet: flashcardSet)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
                                .shadow(radius: 5)
                            
                            Label("Study", systemImage: "book.fill")
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
            .background(colors.backgroundColor)
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
