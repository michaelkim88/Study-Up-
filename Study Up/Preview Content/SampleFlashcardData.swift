import Foundation

struct SampleFlashcardData {
    static let sampleSets: [FlashcardSet] = [
        FlashcardSet(title: "Math Basics", flashcards: [
            Flashcard(question: "What is 2+2?", answer: "4", index: 1),
            Flashcard(question: "What is 7 x 8?", answer: "56", index: 2),
            Flashcard(question: "What is the square root of 16?", answer: "4", index: 3),
            Flashcard(question: "What is π (pi) rounded to 2 decimal places?", answer: "3.14", index: 4),
            Flashcard(question: "What is 15% of 200?", answer: "30", index: 5),
            Flashcard(question: "What is the formula for the area of a circle?", answer: "πr²", index: 6)
        ]),
        
        FlashcardSet(title: "History", flashcards: [
            Flashcard(question: "Who discovered America?", answer: "Columbus", index: 1),
            Flashcard(question: "In what year did World War II end?", answer: "1945", index: 2),
            Flashcard(question: "Who was the first President of the United States?", answer: "George Washington", index: 3),
            Flashcard(question: "What ancient wonder was located in Alexandria?", answer: "The Great Lighthouse", index: 4),
            Flashcard(question: "Which empire built the Pyramids?", answer: "Ancient Egyptian Empire", index: 5),
            Flashcard(question: "When did the Berlin Wall fall?", answer: "1989", index: 6)
        ]),
        
        FlashcardSet(title: "Science", flashcards: [
            Flashcard(question: "What is H2O?", answer: "Water", index: 1),
            Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury", index: 2),
            Flashcard(question: "What is the hardest natural substance?", answer: "Diamond", index: 3),
            Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second", index: 4),
            Flashcard(question: "What is the largest organ in the human body?", answer: "Skin", index: 5),
            Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis", index: 6)
        ]),
        
        FlashcardSet(title: "Language Basics", flashcards: [
            Flashcard(question: "Hola means?", answer: "Hello", index: 1),
            Flashcard(question: "Bonjour means?", answer: "Good day/Hello", index: 2),
            Flashcard(question: "Gracias means?", answer: "Thank you", index: 3),
            Flashcard(question: "Comment allez-vous means?", answer: "How are you?", index: 4),
            Flashcard(question: "Guten Tag means?", answer: "Good day", index: 5),
            Flashcard(question: "Ciao means?", answer: "Hello/Goodbye", index: 6)
        ])
    ]
} 
