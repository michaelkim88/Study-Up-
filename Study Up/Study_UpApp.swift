//
//  Study_UpApp.swift
//  Study Up
//
//  Created by Trevor Smith on 3/1/25.
//

import SwiftUI
import SwiftData

@main
struct StudyUpApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [FlashcardSet.self, Flashcard.self])
    }
}
