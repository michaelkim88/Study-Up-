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
    var creationDate: Date

    var id: PersistentIdentifier { persistentModelID } // Unique identifier

    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.creationDate = Date()  // Set creation time
    }
}

@Model
class FlashcardSet {
    var title: String
    var flashcards: [Flashcard]
    var creationDate: Date
    var totalCards: Int = 0

    var id: PersistentIdentifier { persistentModelID } // Unique identifier

    init(title: String, flashcards: [Flashcard] = []) {
        self.title = title
        self.flashcards = flashcards
        self.creationDate = Date()  // Set creation time
    }
}

@Model
class SetTracker {
    var totalSets: Int = 0
    
    init() {
        
    }
}
