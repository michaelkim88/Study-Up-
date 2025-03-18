import SwiftUI

struct AddButton: View {
    @Binding var isExpanded: Bool
    let colors: AppColorScheme
    let onNewSet: () -> Void
    @State private var hasAddedSet = false
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.2, green: 0.8, blue: 0.4))
                .shadow(radius: 5)
            
            ZStack {
                // Expanded buttons
                if isExpanded {
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isExpanded = false
                            }
                        }) {
                            Text("Import")
                                .font(.headline)
                                .foregroundColor(colors.buttonTextColor)
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {
                            if !hasAddedSet {
                                hasAddedSet = true  // Set this first to prevent multiple rapid clicks
                                onNewSet()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    isExpanded = false
                                }
                                
                            }
                        }) {
                            Text("New Set")
                                .font(.headline)
                                .foregroundColor(colors.buttonTextColor.opacity(hasAddedSet ? 0.5 : 1))
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(hasAddedSet)
                    }
                    .opacity(isExpanded ? 1 : 0)
                }
                
                // The two rectangles
                ZStack {
                    // Vertical rectangle (animates between plus and bar)
                    Rectangle()
                        .fill(colors.buttonTextColor)
                        .frame(width: 3, height: isExpanded ? 30 : 20)
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
                    
                    // Horizontal rectangle (animates width)
                    Rectangle()
                        .fill(colors.buttonTextColor)
                        .frame(width: isExpanded ? 0 : 20, height: 3)
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
                }
            }
        }
        .frame(height: 50)
        .frame(width: isExpanded ? UIScreen.main.bounds.width - 40 : UIScreen.main.bounds.width * 0.6)
        .contentShape(Rectangle())  // Make entire frame tappable
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                if !isExpanded {
                    isExpanded = true
                    hasAddedSet = false  // Only reset when expanding
                } else {
                    isExpanded = false
                }
            }
        }
    }
} 
