//
//  HomeView.swift
//  Study Up
//
//  Created by Trevor Smith on 3/8/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    @State private var searchText = ""
    @State private var isSearchExpanded = false
    @FocusState private var isSearchFocused: Bool
    
    // Use shared color scheme
    private var colors: AppColorScheme {
        AppColorScheme(colorScheme: colorScheme)
    }
    
    // Make flashcardSets mutable with @State, initialized with sample data
    @State private var flashcardSets: [FlashcardSet] = SampleFlashcardData.sampleSets
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
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
                
                // Top cutoff overlay
                VStack {
                    Rectangle()
                        .fill(colors.cutoffColor)
                        .frame(height: 60)
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
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all, edges: .bottom)
                
                // Button Row
                ZStack(alignment: .center) {
                    // Add Button
                    AddButton(
                        isExpanded: $isExpanded,
                        colors: colors,
                        onNewSet: {
                            let newSet = FlashcardSet(title: "Untitled Set", flashcards: [])
                            flashcardSets.append(newSet)
                        }
                    )
                    .zIndex(isExpanded ? 2 : 0)  // Bring to front when expanded
                    .opacity(isSearchExpanded ? 0 : 1)
                    
                    // Search Bar
                    SearchBar(
                        isExpanded: $isSearchExpanded,
                        searchText: $searchText,
                        isFocused: $isSearchFocused,
                        colors: colors
                    )
                    .offset(x: isExpanded ? -UIScreen.main.bounds.width : -((UIScreen.main.bounds.width * 0.6) / 2 + 35))
                    .zIndex(isSearchExpanded ? 1 : 0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
                    
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
                    .offset(x: isExpanded ? UIScreen.main.bounds.width : ((UIScreen.main.bounds.width * 0.6) / 2 + 35))
                    .opacity(isSearchExpanded ? 0 : 1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            }
            .background(colors.backgroundColor)
        }
    }
}

#Preview {
    HomeView()
}
