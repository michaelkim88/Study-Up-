//
//  FlashcardSet.swift
//  Study Up
//
//  Created by Trevor Smith on 3/4/25.
//

import Foundation

struct Flashcard : Identifiable {
    let id = UUID()
    let question : String
    let answer : String
}

struct FlashcardSet : Identifiable, Hashable {
    let id = UUID()
    let title : String
    let flashcards : [Flashcard]
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable (required by Hashable)
    static func == (lhs: FlashcardSet, rhs: FlashcardSet) -> Bool {
        lhs.id == rhs.id
    }
}
