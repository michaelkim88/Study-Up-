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
    @Relationship(deleteRule: .nullify) var next: Flashcard?
    var id: PersistentIdentifier { persistentModelID } // Unique identifier

    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.creationDate = Date()
        // Index is set by FlashcardSet when the card is added.
    }
}

@Model
class FlashcardSet {
    var title: String
    var creationDate: Date
    @Relationship(deleteRule: .cascade) var head: Flashcard?
    var id: PersistentIdentifier { persistentModelID } // Unique identifier
    var count: Int = 0

    init(title: String) {
        self.title = title
        self.creationDate = Date()
    }
    
    func append(flashcard: Flashcard) {
        var current = head
        
        // check if the head node is empty or the next is empty
        while (current != nil && current!.next != nil) {
            current = current!.next!
        }
        
        // if the head node is empty, assign the head
        if current == nil {
            head = flashcard
        // if the next node is empty, assign it to the next place
        } else if current!.next == nil {
            current!.next! = flashcard
        }
        // increment the count by 1
        count += 1
    }
    
    func insert(flashcard: Flashcard) {
        // assign the next of the flashcard to whatever is first in the linked list already
        flashcard.next = head
        // assign the head to the new first flashcard
        head = flashcard
        // increment the count by 1
        count += 1
    }
    
    func remove(flashcard: Flashcard, modelContext: ModelContext) {
        var current = head
        var prev: Flashcard? = nil
        
        while current != nil {
            if current?.id == flashcard.id {
                // If current is the head node
                if prev == nil {
                    head = current?.next // Update head
                } else {
                    prev?.next = current?.next // Skip the current node
                }
                
                // Remove from the model context
                modelContext.delete(flashcard)
                count -= 1
                return
            }
            prev = current
            current = current?.next
        }
    }
}
// Extension to make FlashcardSet iterable
extension FlashcardSet: Sequence {
    func makeIterator() -> FlashcardIterator {
        return FlashcardIterator(current: head)
    }
}

// Iterator for FlashcardSet
struct FlashcardIterator: IteratorProtocol {
    var current: Flashcard?
    
    mutating func next() -> Flashcard? {
        guard let node = current else { return nil }
        current = node.next
        return node
    }
}
