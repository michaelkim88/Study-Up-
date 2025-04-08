//
//  FlashcardListTesting.swift
//  Study Up
//
//  Created by Michael Kim on 4/8/25.
//

import Foundation
import SwiftData

@Model
final class RectangleItem: Identifiable {
    let id: UUID // Explicit ID can be helpful, though SwiftData manages its own
    var orderIndex: Int // This is key for maintaining order
    var creationDate: Date // Good practice, can be useful

    init(id: UUID = UUID(), orderIndex: Int, creationDate: Date = Date()) {
        self.id = id
        self.orderIndex = orderIndex
        self.creationDate = creationDate
    }
}

import SwiftUI
import SwiftData

struct ContentView: View {
    // Access the model context from the environment
    @Environment(\.modelContext) private var modelContext

    // Query for RectangleItems, sorted by our custom orderIndex
    // This automatically keeps the view updated when data changes
    @Query(sort: \RectangleItem.orderIndex, order: .forward) private var items: [RectangleItem]

    var body: some View {
        NavigationView { // Use NavigationView for title and EditButton
            VStack {
                List {
                    // ForEach iterates through the fetched items
                    ForEach(items) { item in
                        RectangleView(item: item) // Use a dedicated view for the row
                    }
                    .onDelete(perform: deleteItems) // Handle swipe-to-delete
                    .onMove(perform: moveItems)   // Handle drag-and-drop reordering
                }
                // Make the list style plain or inset as desired
                // .listStyle(.plain)
            }
            .navigationTitle("Draggable Rectangles")
            .toolbar {
                // Button to add new items
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        addItem()
                    }
                }
                // EditButton toggles the list's edit mode (for moving/deleting)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            // Ensure items array is available for EditButton enabling/disabling
             .environment(\.editMode, .constant(items.isEmpty ? .inactive : .active))

        }
    }

    // MARK: - Data Handling Functions

    private func addItem() {
        withAnimation {
            // Determine the index for the new item (should be the next available index)
            let nextIndex = items.count // Since indices are 0-based, count is the next index

            // Create the new item
            let newItem = RectangleItem(orderIndex: nextIndex)

            // Insert into the model context
            modelContext.insert(newItem)

            // Optional: Explicitly save if needed, though usually autosave handles it
            // saveContext()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // 1. Get the items to delete based on the offsets provided by the List
            let itemsToDelete = offsets.map { items[$0] }

            // 2. Delete them from the model context
            itemsToDelete.forEach { item in
                modelContext.delete(item)
                print("Deleting item with index: \(item.orderIndex)")
            }

            // 3. **Crucially: Re-index the remaining items**
            // Fetch the items *after* deletion, sorted correctly,
            // then update their orderIndex to be sequential (0, 1, 2...).
            do {
                // We need to fetch *after* the delete operation is registered
                // Using the existing @Query `items` might not reflect the deletion immediately
                // within this function call on all OS versions/scenarios. A fresh fetch is safer.
                let descriptor = FetchDescriptor<RectangleItem>(sortBy: [SortDescriptor(\.orderIndex)])
                let remainingItems = try modelContext.fetch(descriptor)

                print("Re-indexing \(remainingItems.count) items after deletion.")
                for (newIndex, item) in remainingItems.enumerated() {
                     // Check if update is needed to avoid unnecessary writes
                    if item.orderIndex != newIndex {
                        print("Updating item \(item.id) from index \(item.orderIndex) to \(newIndex)")
                        item.orderIndex = newIndex
                    }
                }
                // Optional: Explicit save if encountering issues
                // saveContext()

            } catch {
                print("Error fetching or re-indexing after delete: \(error)")
                // Handle error appropriately
            }
        }
    }


    private func moveItems(from source: IndexSet, to destination: Int) {
        // 1. Create a mutable copy of the current items array
        //    (items from @Query is already sorted by orderIndex)
        var updatedItems = items

        // 2. Perform the move operation on this temporary array
        //    This calculates the new arrangement based on user drag
        updatedItems.move(fromOffsets: source, toOffset: destination)

        // 3. Update the orderIndex property on the actual SwiftData models
        //    Iterate through the reordered temporary array and assign new indices
        print("Re-indexing \(updatedItems.count) items after move.")
        for (newIndex, item) in updatedItems.enumerated() {
            // Check if update is needed to avoid unnecessary writes
            if item.orderIndex != newIndex {
                 print("Updating item \(item.id) from index \(item.orderIndex) to \(newIndex)")
                item.orderIndex = newIndex
            }
        }

        // Optional: Explicit save if encountering issues
        // saveContext()

        // Note: No need to manually insert/delete, just update the index.
        // SwiftData and @Query handle reflecting these changes in the UI.
    }

    // Optional: Helper to explicitly save context if needed
    // private func saveContext() {
    //     do {
    //         try modelContext.save()
    //         print("Context saved successfully.")
    //     } catch {
    //         print("Error saving context: \(error)")
    //     }
    // }
}

// MARK: - Row View

struct RectangleView: View {
    // Receive the item to display
    @Bindable var item: RectangleItem // Use @Bindable if you might edit properties directly here

    var body: some View {
        HStack {
            // Display the orderIndex (our number)
            Text("\(item.orderIndex)")
                .font(.headline)
                .padding(.horizontal, 8)

            // The visual rectangle
            Rectangle()
                .fill(Color.blue.opacity(0.7))
                .frame(height: 50) // Give it some height

            Spacer() // Push text and rectangle left
        }
        .padding(.vertical, 4) // Add some padding around the row content
        // You could add more details from the item here if needed
        // .overlay(Text("ID: \(item.id.uuidString.prefix(4))").font(.caption), alignment: .bottomTrailing)
    }
}

// MARK: - Preview

#Preview {
    // Example preview setup with in-memory data
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: RectangleItem.self, configurations: config)

        // Add some sample data for the preview
        let sampleIndices = [0, 1, 2]
        sampleIndices.forEach { index in
            let newItem = RectangleItem(orderIndex: index)
            container.mainContext.insert(newItem)
        }

        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create container: \(error)")
    }
}
