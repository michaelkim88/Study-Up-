//
//  FlashcardSet.swift
//  Study Up
//
//  Created by Trevor Smith on 3/4/25.
//

import Foundation
import SwiftData

@Model
class Flashcard {
    var question: String
    var answer: String

    var id: PersistentIdentifier { persistentModelID } // Unique identifier

    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
}

@Model
class FlashcardSet {
    var title: String
    var flashcards: [Flashcard]

    var id: PersistentIdentifier { persistentModelID } // Unique identifier

    init(title: String, flashcards: [Flashcard] = []) {
        self.title = title
        self.flashcards = flashcards
    }
}
