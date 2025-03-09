//
//  HomeView.swift
//  Study Up
//
//  Created by Trevor Smith on 3/8/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    
    // Computed colors that adapt to color scheme
    var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.02, green: 0.02, blue: 0.15) : Color(red: 0.95, green: 0.95, blue: 1.0)
    }
    
    var boxColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color(red: 0.9, green: 0.9, blue: 0.95)
    }
    
    var boxBorderColor: Color {
        colorScheme == .dark ? Color(red: 0.3, green: 0.3, blue: 0.35) : Color(red: 0.8, green: 0.8, blue: 0.85)
    }
    
    var textColor: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    var cutoffColor: Color {
        colorScheme == .dark ? Color(red: 0.05, green: 0.05, blue: 0.2) : Color(red: 0.93, green: 0.93, blue: 0.98)
    }
    
    var buttonTextColor: Color {
        colorScheme == .dark ? Color(red: 0.05, green: 0.05, blue: 0.2) : .white
    }
    
    // Make flashcardSets mutable with @State
    @State private var flashcardSets: [FlashcardSet] = [
        FlashcardSet(title: "Math Basics to Study for the Exam Hello Hello", flashcards: [
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
        ]),
        FlashcardSet(title: "The War of the Regulation and Insurrection in South Carolina", flashcards: [
            
            Flashcard(question: "What is H2O?", answer: "Water"),
            Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury"),
            Flashcard(question: "What is the hardest natural substance?", answer: "Diamond"),
            Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second"),
            Flashcard(question: "What is the largest organ in the human body?", answer: "Skin"),
            Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis"),
            Flashcard(question: "What is 2+2?", answer: "4"),
            Flashcard(question: "What is 7 x 8?", answer: "56"),
            Flashcard(question: "What is the square root of 16?", answer: "4"),
            Flashcard(question: "What is π (pi) rounded to 2 decimal places?", answer: "3.14"),
            Flashcard(question: "What is 15% of 200?", answer: "30"),
            Flashcard(question: "What is the formula for the area of a circle?", answer: "πr²"),
            Flashcard(question: "Who discovered America?", answer: "Columbus"),
            Flashcard(question: "In what year did World War II end?", answer: "1945"),
            Flashcard(question: "Who was the first President of the United States?", answer: "George Washington"),
            Flashcard(question: "What ancient wonder was located in Alexandria?", answer: "The Great Lighthouse"),
            Flashcard(question: "Which empire built the Pyramids?", answer: "Ancient Egyptian Empire"),
            Flashcard(question: "When did the Berlin Wall fall?", answer: "1989"),
            Flashcard(question: "Hola means?", answer: "Hello"),
            Flashcard(question: "Bonjour means?", answer: "Good day/Hello"),
            Flashcard(question: "Gracias means?", answer: "Thank you"),
            Flashcard(question: "Comment allez-vous means?", answer: "How are you?"),
            Flashcard(question: "Guten Tag means?", answer: "Good day"),
            Flashcard(question: "Ciao means?", answer: "Hello/Goodbye")
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
                                NavigationLink(destination: SetView2(flashcardSet: set)) {
                                    VStack {
                                        Text(set.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(textColor)
                                            .lineLimit(3)
                                            .minimumScaleFactor(0.5)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .padding(.horizontal, 8)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 120)
                                    .background(boxColor)
                                    .cornerRadius(12)
                                    .shadow(radius: 3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(boxBorderColor, lineWidth: 1)
                                    )
                                    .padding(.horizontal, 4)
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 150)
                        .frame(width: geometry.size.width)
                    }
                }
                
                // Top cutoff overlay
                VStack {
                    Rectangle()
                        .fill(backgroundColor)
                        .frame(height: 60)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .top)
                
                // Bottom cutoff overlay
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(cutoffColor)
                        .frame(height: 120)
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .bottom)
                
                // Button Row
                ZStack {
                    // Search Button
                    Button(action: {
                        // Search functionality will go here
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(textColor)
                            .frame(width: 50, height: 50)
                            .background(boxColor)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .offset(x: isExpanded ? -200 : -((UIScreen.main.bounds.width * 0.6) / 2 + 35))
                    .opacity(isExpanded ? 0 : 1)
                    
                    // Profile Button
                    Button(action: {
                        // Profile functionality will go here
                    }) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(textColor)
                            .frame(width: 50, height: 50)
                            .background(boxColor)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .offset(x: isExpanded ? 200 : ((UIScreen.main.bounds.width * 0.6) / 2 + 35))
                    .opacity(isExpanded ? 0 : 1)
                    
                    // Center Button Container
                    Group {
                        if isExpanded {
                            // Expanded buttons
                            HStack(spacing: 0) {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        isExpanded = false
                                    }
                                }) {
                                    Text("Import")
                                        .font(.headline)
                                        .foregroundColor(buttonTextColor)
                                        .frame(maxWidth: .infinity)
                                }
                                
                                Rectangle()
                                    .fill(buttonTextColor)
                                    .frame(width: 3, height: 30)
                                
                                Button(action: {
                                    let newSet = FlashcardSet(title: "Untitled Set", flashcards: [])
                                    flashcardSets.append(newSet)
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        isExpanded = false
                                    }
                                }) {
                                    Text("New Set")
                                        .font(.headline)
                                        .foregroundColor(buttonTextColor)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(height: 50)
                            .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                            .cornerRadius(8)
                            .shadow(radius: 5)
                        } else {
                            // Add Button
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isExpanded = true
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(buttonTextColor)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .frame(width: isExpanded ? UIScreen.main.bounds.width - 40 : UIScreen.main.bounds.width * 0.6)
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            }
            .background(backgroundColor)
        }
    }
}

#Preview {
    HomeView()
}
