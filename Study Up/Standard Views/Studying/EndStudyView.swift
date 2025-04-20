//
//  EndStudyView.swift
//  Study Up
//
//  Created by Michael Kim on 3/9/25.
//

import SwiftUI

struct EndStudyView: View {
    let flashcardSet: FlashcardSet
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            // Back button at the top
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
            
            Spacer()
            
            // Completion message
            VStack(spacing: 20) {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("You've completed")
                    .font(.title2)
                
                Text(flashcardSet.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Text("Keep up the great work!")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 20) {
                Button(action: {
                    // Study again action will be implemented later
                }) {
                    Text("Study Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Continue action will be implemented later
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EndStudyView(flashcardSet: FlashcardSet(title: "Science", flashcards: [
        Flashcard(question: "What is H2O?", answer: "Water", index: 1),
        Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury", index: 2)
    ]))
}

