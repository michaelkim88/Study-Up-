//
//  HomeView.swift
//  Study Up
//
//  Created by Trevor Smith on 3/8/25.
//

import SwiftUI

struct HomeView: View {
    // Make flashcardSets mutable with @State
    @State private var flashcardSets: [FlashcardSet] = [
        FlashcardSet(title: "Math Basics", flashcards: [
            Flashcard(question: "What is 2+2?", answer: "4"),
            Flashcard(question: "What is 7 x 8?", answer: "56")
        ]),
        FlashcardSet(title: "History", flashcards: [
            Flashcard(question: "Who discovered America?", answer: "Columbus"),
            Flashcard(question: "In what year did World War II end?", answer: "1945")
        ]),
        FlashcardSet(title: "Science", flashcards: [
            Flashcard(question: "What is H2O?", answer: "Water"),
            Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury")
        ])
    ]
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                GeometryReader { geometry in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(flashcardSets) { set in
                                NavigationLink(destination: FlashcardSetDetailView(flashcardSet: set)) {
                                    VStack {
                                        Text(set.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 120)
                                    .background(Color(red: 0.25, green: 0.25, blue: 0.3))
                                    .cornerRadius(12)
                                    .shadow(radius: 3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.3, green: 0.3, blue: 0.35), lineWidth: 1)
                                    )
                                    .padding(.horizontal, 4)
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 150)
                    }
                }
                
                // Top cutoff overlay
                VStack {
                    Rectangle()
                        .fill(.black)
                        .frame(height: 60)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .top)
                
                // Bottom cutoff overlay
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(Color(red: 0.05, green: 0.05, blue: 0.2))
                        .frame(height: 120)
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .bottom)
                
                // Button Row
                HStack(spacing: 20) {
                    // Search Button
                    Button(action: {
                        // Search functionality will go here
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color(red: 0.25, green: 0.25, blue: 0.3))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    // Add Button
                    Button(action: {
                        // Add new untitled flashcard set
                        let newSet = FlashcardSet(title: "Untitled Set", flashcards: [])
                        flashcardSets.append(newSet)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.05, green: 0.05, blue: 0.2))
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                            .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                    
                    // Profile Button
                    Button(action: {
                        // Profile functionality will go here
                    }) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color(red: 0.25, green: 0.25, blue: 0.3))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding(.bottom, 10)
            }
            .preferredColorScheme(.dark)
            .background(Color(red: 0.02, green: 0.02, blue: 0.15))
        }
    }
}

#Preview {
    HomeView()
}
