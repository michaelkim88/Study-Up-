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


    // Define the relationship with cascade delete
    @Relationship(deleteRule: .cascade, inverse: \Flashcard.set)
    var flashcards: [Flashcard] = [] // Initialize to empty array

    init(title: String, flashcards: [Flashcard] = []) {
        self.title = title
        self.creationDate = Date()
        self.flashcards = flashcards // Assign initial flashcards if provided
        // Re-index initial flashcards if necessary (or ensure they come with correct indices)
        reindexFlashcards()
    }

    // Adds a new flashcard to the end and saves context.
    func append(flashcard: Flashcard, modelContext: ModelContext?) {
        flashcard.index = flashcards.count // Assign index based on current count (0-based)
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
            print("Warning: Flashcard with ID \(flashcardToRemove.persistentModelID) not found in the set's array for removal.")
            // Optional: Could attempt to delete from context anyway if the array state is suspect,
            // but it's safer to rely on the array being the source of truth for order.
            // context.delete(flashcardToRemove)
            // save(context: context)
            return // Exit if not found in the array
        }

        print("Removing flashcard at array index \(indexToRemove) with Question: '\(flashcards[indexToRemove].question)'")

        // 2. Remove the flashcard from the Swift array FIRST.
        //    This modifies the array in memory.
        flashcards.remove(at: indexToRemove)

        // 3. Re-index the *remaining* flashcards based on their new positions in the array.
        //    This ensures the indices stored in each Flashcard object are sequential (0, 1, 2, ...)
        //    after the deletion.
        print("Re-indexing remaining flashcards...")
        self.reindexFlashcards() // Call the helper function

        // 4. Delete the actual flashcard *object* from the persistent store (SwiftData).
        //    This marks it for deletion upon saving the context.
        print("Deleting flashcard object from ModelContext...")
        context.delete(flashcardToRemove) // Use the original object passed to the function

        // 5. Save the changes (the deletion AND the index updates on remaining cards)
        //    to the persistent store.
        print("Saving ModelContext after removal and re-indexing...")
        self.save(context: context) // Call the save helper
    }

    // Utility function to re-index all flashcards based on their current array order.
    // This should be called AFTER the `flashcards` array has been modified (e.g., by removal or move).
    private func reindexFlashcards() {
        print("Executing reindexFlashcards. Current count: \(flashcards.count)")
        for (newArrayIndex, card) in flashcards.enumerated() {
             // Assign the current position in the array (0, 1, 2...) as the new index property value
             if card.index != newArrayIndex { // Optional: Only log if index actually changes
                 print("Updating index for card '\(card.question)' from \(String(describing: card.index)) to \(newArrayIndex)")
             }
             card.index = newArrayIndex
        }
        print("Finished re-indexing.")
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
