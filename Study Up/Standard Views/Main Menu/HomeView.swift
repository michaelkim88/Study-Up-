//
//  HomeView.swift
//  Study Up
//
//  Created by Trevor Smith on 3/8/25.
//

import SwiftUI
import SwiftData
import Foundation

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    @State private var searchText = ""
    @State private var isSearchExpanded = false
    @State private var newSet: FlashcardSet? = nil
    @State private var selectionMode: Bool = false
    @State private var selectedSets: Set<FlashcardSet.ID> = []
    @FocusState private var isSearchFocused: Bool
    
    @State private var showDeleteConfirmation = false
    
    @Environment(\.modelContext) private var modelContext
    
    // Use shared color scheme
    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }
    
    // Make flashcardSets mutable with @State, initialized with sample data
    @Query(sort: \FlashcardSet.creationDate, order: .reverse) private var flashcardSets: [FlashcardSet] // Fetch sets

    // Filtered flashcard sets based on search text
    private var filteredFlashcardSets: [FlashcardSet] {
        if searchText.isEmpty {
            return flashcardSets
        } else {
            return flashcardSets.filter { set in
                set.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Main content
                VStack(spacing: 0) {
                    GeometryReader { geometry in
                        ScrollView {
                            if (filteredFlashcardSets.isEmpty) {
                                if (searchText.isEmpty) {
                                    VStack {
                                        Text("No Flashcard Sets")
                                            .font(.title)
                                            .foregroundColor(colors.textColor)
                                            .padding()
                                    }
                                } else {
                                    VStack {
                                        Text("No Results Found")
                                            .font(.title)
                                            .foregroundColor(colors.textColor)
                                            .padding()
                                    }
                                }
                            }
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(filteredFlashcardSets) { set in
                                    SelectableGridItem(
                                        flashcardSet: set,
                                        selectionMode: $selectionMode,
                                        isSelected: Binding(
                                            get: { selectedSets.contains(set.id) },
                                            set: { newValue in
                                                if newValue { selectedSets.insert(set.id) }
                                                else        { selectedSets.remove(set.id) }
                                            }
                                        ),
                                        colors: colors)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 20)
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 150)
                        }
                        .frame(width: UIScreen.main.bounds.width - 20)
                    }
                    .frame(width: UIScreen.main.bounds.width - 20)
                    .allowsHitTesting(!isSearchExpanded && !isExpanded)
                }
                
                //                // Top cutoff overlay
                //                VStack(spacing: 0) {
                //                    Rectangle()
                //                        .fill(colors.cutoffColor)
                //                        .frame(height: 60)
                //                        .overlay(alignment: .leading) {
                //                            if selectionMode {
                //                                Text("Done")
                //                                    .font(.headline)
                //                                    .foregroundColor(.blue)
                //                                    .padding(.leading, 16)
                //                                    .padding(.top, 16)
                //                                    .contentShape(Rectangle())    // make tap area full text bounds
                //                                    .onTapGesture {
                //                                        withAnimation { selectionMode = false }
                //                                    }
                //                            }
                //                        }
                //                        .allowsHitTesting(true)  // ensure taps go through
                //                    Spacer()
                //                }
                //                .ignoresSafeArea(edges: .top)
                
                
                // Bottom cutoff overlay
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Rectangle()
                        .fill(colors.cutoffColor)
                        .frame(height: 120)
                        .allowsHitTesting(!isSearchExpanded && !isExpanded)
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .bottom)
                
                // Button Row
                HStack(spacing: 4) {
                    // Search Bar Container
                    HStack(alignment: .center) {
                        SearchBar(
                            isExpanded: $isSearchExpanded,
                            searchText: $searchText,
                            isFocused: $isSearchFocused,
                            colors: colors
                        )
                        .frame(width: isSearchExpanded ? UIScreen.main.bounds.width - 30 : 50)
                        .zIndex(isSearchExpanded ? 1 : 0)
                    }
                    .frame(width: 50, alignment: .leading)
                    
                    Spacer()
                    
                    // Add Button
                    AddButton(
                        isExpanded: $isExpanded,
                        colors: colors,
                        onNewSet: {
                            let set = FlashcardSet(title: "Untitled Set", flashcards: [])
                            newSet = set
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    modelContext.insert(set)
                                    try? modelContext.save()
                                }
                            }
                        }
                    )
                    .zIndex(isExpanded ? 2 : 0)
                    .opacity(isSearchExpanded ? 0 : 1)
                    
                    Spacer()
                    
                    // Profile Button
                    Button(action: {
                        // Profile functionality will go here
                    }) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(colors.textColor)
                            .frame(width: 50, height: 50)
                            .background(colors.boxColor)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .opacity(isSearchExpanded ? 0 : 1)
                }
                .padding(.bottom, 10)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
            
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isSearchExpanded = false
                    isSearchFocused = false
                    isExpanded = false
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isSearchExpanded = false
                            isSearchFocused = false
                            isExpanded = false
                        }
                    }
            )
            .background(colors.backgroundColor)
            
            // Navigation destination to automatically navigate to new set
            .navigationDestination(item: $newSet) { set in
                SetView(flashcardSet: set)
            }
            .navigationDestination(for: FlashcardSet.self) { set in
                SetView(flashcardSet: set)
            }
            
            // Button to exit selection mode
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)                 // make the bar’s background layer visible
            .toolbarBackground(colors.cutoffColor, for: .navigationBar)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        withAnimation { selectionMode = false }
                    }
                    .disabled(!selectionMode)
                    .opacity(selectionMode ? 1 : 0)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        showDeleteConfirmation = true
                    }
                    .disabled(selectedSets.isEmpty)
                    .opacity(selectionMode ? 1 : 0)
                }
            }
        }
        .alert(Text("Delete \(selectedSets.count) set\(selectedSets.count == 1 ? "" : "s")?"),
               isPresented: $showDeleteConfirmation
        ) {
            Button("Delete", role: .destructive) {
                selectedSets.forEach { id in
                    if let set = flashcardSets.first(where: { $0.id == id }) {
                        modelContext.delete(set)
                    }
                }
                try? modelContext.save()
                selectedSets.removeAll()
                selectionMode = false
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// Set Grid item that serves as a navigation link and
// selection mode toggle. Used to display the flashcard sets.
struct SelectableGridItem: View {
  let flashcardSet: FlashcardSet
  @Binding var selectionMode: Bool
  
    @Binding var isSelected: Bool
  @State private var clearedSelection = false
  let colors: AppColorScheme
  
  var body: some View {
    ZStack {
      NavigationLink(value: flashcardSet) {
        FlashcardSetGridItem(set: flashcardSet, colors: colors)
      }
      .disabled(selectionMode)
      
      .simultaneousGesture(
        LongPressGesture(minimumDuration: 0.5)
          .onEnded { _ in
            guard !selectionMode else { return }
            withAnimation {
              selectionMode = true
              isSelected = true
            }
          }
      )
      
      // tap toggles just this item
      if selectionMode {
        Color.clear
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation { isSelected.toggle() }
          }
          .overlay(
            Image(systemName: isSelected
                      ? "checkmark.circle.fill"
                      : "circle")
              .foregroundColor(.blue)
              .padding(8)
              .offset(x: 70, y: -40)
          )
      }
    }
    .contentShape(Rectangle())
    .onChange(of: selectionMode) { oldValue, newValue in
      if newValue && !oldValue {
        // entering: only pre-held items stay deselected
        if !isSelected { isSelected = false }
        clearedSelection = true
      } else if !newValue && oldValue {
        // exiting: unselect everything
        isSelected = false
        clearedSelection = false
      }
    }
  }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardSet.self, configurations: config)
    
    // Populate with sample flashcard sets
    for sampleSet in SampleFlashcardData.sampleSets {
        container.mainContext.insert(sampleSet)
    }
    
    return HomeView()
        .modelContainer(container)
}
