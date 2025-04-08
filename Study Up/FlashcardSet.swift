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
    // Ensure index is consistently managed
    @Attribute(.preserveValueOnDeletion) // Consider if you want index gaps or re-indexing on delete
    var index: Int?

    // Relationship back to the set
    var set: FlashcardSet?

    // No need for explicit id property when using @Model

    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.creationDate = Date()
        // Index should be set by the FlashcardSet methods
    }
}

@Model
class FlashcardSet {
    var title: String
    var creationDate: Date
    private var index_create: Int = 0

    // Define the relationship with cascade delete
    @Relationship(deleteRule: .cascade, inverse: \Flashcard.set)
    var flashcards: [Flashcard] = [] // Initialize to empty array

    init(title: String, flashcards: [Flashcard] = []) {
        self.title = title
        self.creationDate = Date()
        self.flashcards = flashcards // Assign initial flashcards if provided
    }

    // Adds a new flashcard to the end and saves context.
    func append(flashcard: Flashcard, modelContext: ModelContext?) {
        flashcard.index = index_create // Assign index based on current count (0-based)
        index_create += 1
        flashcard.set = self // Establish the relationship
        flashcards.append(flashcard) // Add to the Swift array

        // Save the context if provided
        save(context: modelContext)
    }

    // Inserts a new flashcard at the beginning, re-indexes others, and saves context.
    func insert(flashcard: Flashcard, modelContext: ModelContext?) {
        // Increment the index of all existing flashcards
        for card in flashcards {
            card.index = (card.index ?? 0) + 1
        }

        // Set up the new flashcard
        flashcard.index = 0 // New card goes at the beginning
        flashcard.set = self // Establish the relationship
        flashcards.insert(flashcard, at: 0) // Insert into the Swift array
        index_create += 1

        // Save the context if provided
        save(context: modelContext)
    }

    func remove(flashcardToRemove: Flashcard, modelContext: ModelContext?) {
        // Ensure we have a context to work with
        guard let context = modelContext else {
            print("Error: ModelContext is nil. Cannot remove flashcard.")
            return
        }

        // 1. Find the index of the flashcard in the backing array
        guard let indexToRemove = flashcards.firstIndex(where: { $0.id == flashcardToRemove.id }) else {
            return // Exit if not found in the array
        }

        // 2. Remove the flashcard from the Swift array FIRST.
        //    This modifies the array in memory.
        flashcards.remove(at: indexToRemove)

        context.delete(flashcardToRemove) // Use the original object passed to the function

        self.save(context: context) // Call the save helper
    }


    // Helper function for saving the context (keep as is)
    private func save(context: ModelContext?) {
        guard let context = context else {
            print("Warning: ModelContext not provided for saving.")
            return
        }
        do {
            try context.save()
            print("Context saved successfully.")
        } catch {
            // Handle or log the error appropriately
            print("Failed to save ModelContext: \(error)")
        }
    }
}


// SetTracker remains the same, seems unrelated to SetView2 edits
@Model
class SetTracker {
    var _totalSets: Int = 0

    init() {

    }
}
