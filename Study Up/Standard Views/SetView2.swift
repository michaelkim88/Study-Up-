//
//  SetView2.swift
//  Study Up
//
//  Created by Michael Kim on 3/9/25.
//

import SwiftUI

struct SetView2: View {
    let flashcardSet: FlashcardSet
    @State private var flippedCards: Set<Int> = []
    @State private var editingCard: (index: Int, isQuestion: Bool)? = nil
    @State private var editText: String = ""
    @State private var currentIndex: Int = 0

    private func getVisibleRange(total: Int, current: Int) -> [Int] {
        let windowSize = 3
        let halfWindow = windowSize / 2
        
        var start = current - halfWindow
        var end = current + halfWindow
        
        // Adjust if we're near the start
        if start < 0 {
            start = 0
            end = min(windowSize - 1, total - 1)
        }
        
        // Adjust if we're near the end
        if end >= total {
            end = total - 1
            start = max(0, total - windowSize)
        }
        
        return Array(start...end)
    }
    
    var body: some View {
        
        VStack {
            Text(flashcardSet.title)
                .font(.title)
                .fontWeight(.regular)
                .foregroundColor(Color.black)
            
            HStack (spacing: 0) {
                Spacer()
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
                                flippedCards.removeAll()
                            }
                        }
                    }
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
                .padding()
                
                
                
//                GeometryReader { geo in
//                    // Constants for indicator size and spacing
//                    let indicatorDiameter: CGFloat = 12
//                    let spacing: CGFloat = 10
//                    let totalHeight = geo.size.height
//                    let windowSize = 5
//                    let halfWindow = windowSize / 2
//                    
//                    // Calculate visible range
//                    var start = currentIndex - halfWindow
//                    var end = currentIndex + halfWindow
//                    
//                    // Adjust if we're near the start
//                    if start < 0 {
//                        start = 0
//                        end = min(windowSize - 1, flashcardSet.flashcards.count - 1)
//                    }
//                    
//                    // Adjust if we're near the end
//                    if end >= flashcardSet.flashcards.count {
//                        end = flashcardSet.flashcards.count - 1
//                        start = max(0, flashcardSet.flashcards.count - windowSize)
//                    }
//                    
//                    let visibleRange = Array(start...end)
//                    
//                    Rectangle()
//                        .fill(Color.clear)
//                        .frame(width: geo.size.width, height: totalHeight)
//                        .overlay {
//                            VStack(spacing: spacing) {
//                                ForEach(visibleRange, id: \.self) { index in
//                                    Circle()
//                                        .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.5))
//                                        .frame(width: indicatorDiameter, height: indicatorDiameter)
//                                        .onTapGesture {
//                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                                currentIndex = index
//                                            }
//                                        }
//                                }
//                            }
//                            .frame(width: geo.size.width, height: totalHeight, alignment: .center)
//                        }
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    // Map the drag's y-location to an image index
//                                    let y = value.location.y
//                                    // Determine the proportion of the gesture along the vertical space
//                                    let proportion = y / totalHeight
//                                    // Calculate new index based on the number of images
//                                    let newIndex = min(max(Int(round(proportion * CGFloat(flashcardSet.flashcards.count - 1))), 0), flashcardSet.flashcards.count - 1)
//                                    if newIndex != currentIndex {
//                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                            currentIndex = newIndex
//                                        }
//                                    }
//                                }
//                        )
//                }
//                .frame(width: 40, height: 400)
//                .padding(.leading, 8)
            }
            
            
            // Search, Study, and profile buttons
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
                
                // Study Options button
                NavigationLink(destination: FlashcardView(flashcardSet: flashcardSet)) {
                    Label("Study", systemImage: "book.fill")
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
        .navigationBarBackButtonHidden(false)
    }
}


#Preview {
    SetView2(flashcardSet: FlashcardSet(title: "Science", flashcards: [
        
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
    ]))
}
