import Foundation

struct SampleFlashcardData {
    static let sampleSets: [FlashcardSet] = [
        FlashcardSet(title: "Math Basics", flashcards: [
            Flashcard(question: "What is 2+2?", answer: "4"),
            Flashcard(question: "What is 7 x 8?", answer: "56"),
            Flashcard(question: "What is the square root of 16?", answer: "4"),
            Flashcard(question: "What is π (pi) rounded to 2 decimal places?", answer: "3.14"),
            Flashcard(question: "What is 15% of 200?", answer: "30"),
            Flashcard(question: "What is the formula for the area of a circle?", answer: "πr²")
        ]),
        
        FlashcardSet(title: "History", flashcards: [
            Flashcard(question: "Who discovered America?", answer: "Columbus"),
            Flashcard(question: "In what year did World War II end?", answer: "1945"),
            Flashcard(question: "Who was the first President of the United States?", answer: "George Washington"),
            Flashcard(question: "What ancient wonder was located in Alexandria?", answer: "The Great Lighthouse"),
            Flashcard(question: "Which empire built the Pyramids?", answer: "Ancient Egyptian Empire"),
            Flashcard(question: "When did the Berlin Wall fall?", answer: "1989")
        ]),
        
        FlashcardSet(title: "Science", flashcards: [
            Flashcard(question: "What is H2O?", answer: "Water"),
            Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury"),
            Flashcard(question: "What is the hardest natural substance?", answer: "Diamond"),
            Flashcard(question: "What is the speed of light?", answer: "299,792,458 meters per second"),
            Flashcard(question: "What is the largest organ in the human body?", answer: "Skin"),
            Flashcard(question: "What is the process of plants making food called?", answer: "Photosynthesis")
        ]),
        
        FlashcardSet(title: "Language Basics", flashcards: [
            Flashcard(question: "Hola means?", answer: "Hello"),
            Flashcard(question: "Bonjour means?", answer: "Good day/Hello"),
            Flashcard(question: "Gracias means?", answer: "Thank you"),
            Flashcard(question: "Comment allez-vous means?", answer: "How are you?"),
            Flashcard(question: "Guten Tag means?", answer: "Good day"),
            Flashcard(question: "Ciao means?", answer: "Hello/Goodbye")
        ])
    ]
} 