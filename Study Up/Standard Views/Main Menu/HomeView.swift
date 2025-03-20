//
//  HomeView.swift
//  Study Up
//
//  Created by Trevor Smith on 3/8/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    @State private var searchText = ""
    @State private var isSearchExpanded = false
    @State private var newSet: FlashcardSet? = nil
    @FocusState private var isSearchFocused: Bool
    
    @Environment(\.modelContext) private var modelContext
    
    // Use shared color scheme
    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }
    
    // Make flashcardSets mutable with @State, initialized with sample data
    @Query private var flashcardSets: [FlashcardSet]
    
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
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(flashcardSets) { set in
                                    NavigationLink(destination: SetView2(flashcardSet: set)) {
                                        FlashcardSetGridItem(set: set, colors: colors)
                                    }
                                }
                            }
                            .padding()
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 150)
                            .frame(width: geometry.size.width)
                        }
                    }
                    .allowsHitTesting(!isSearchExpanded && !isExpanded)
                }
                
                // Top cutoff overlay
                VStack {
                    Rectangle()
                        .fill(colors.cutoffColor)
                        .frame(height: 60)
                        .allowsHitTesting(!isSearchExpanded && !isExpanded)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .top)
                
                // Bottom cutoff overlay
                VStack(spacing: 0) {
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
                        .frame(width: isSearchExpanded ? UIScreen.main.bounds.width - 40 : 50)
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
            .background(colors.backgroundColor)
            .navigationDestination(item: $newSet) { set in
                SetView2(flashcardSet: set)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlashcardSet.self, configurations: config)
    return HomeView()
        .modelContainer(container)
}
