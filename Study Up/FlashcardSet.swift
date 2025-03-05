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

struct FlashcardSet : Identifiable {
    let id = UUID()
    let title : String
    let flashcards : [Flashcard]
}
