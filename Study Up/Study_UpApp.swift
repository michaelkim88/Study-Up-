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
    init() {
        // Clear existing data
        let container = try! ModelContainer(for: FlashcardSet.self)
        let context = container.mainContext
        let descriptor = FetchDescriptor<FlashcardSet>()
        if let existingSets = try? context.fetch(descriptor) {
            for set in existingSets {
                context.delete(set)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: FlashcardSet.self)
    }
} 
