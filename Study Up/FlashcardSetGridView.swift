//
//  FlashcardSetGridView.swift
//  Study Up
//
//  Created by Trevor Smith on 3/4/25.
//

import SwiftUI

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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(flashcardSets) { set in
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
            }
            .padding(.all)
        }
    }
}

struct FlashcardSetDetailView: View {
    let flashcardSet: FlashcardSet
    
    var body: some View {
        VStack {
            Text("Welcome to \(flashcardSet.title)!")
                .font(.title)
                .padding()
            // Future: Add the flashcards details here.
            Spacer()
        }
        .navigationTitle(flashcardSet.title)
    }
}

#Preview {
    FlashcardSetGridView()
}
