import SwiftUI

struct SearchBar: View {
    @Binding var isExpanded: Bool
    @Binding var searchText: String
    @FocusState.Binding var isFocused: Bool
    let colors: AppColorScheme
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Search Background
            RoundedRectangle(cornerRadius: 25)
                .fill(colors.boxColor)
                .shadow(radius: 5)
            
            HStack(spacing: 12) {
                Button(action: {
                    if isExpanded {
                        if !searchText.isEmpty {
                            searchText = ""
                        }
                    } else {
                        if searchText.isEmpty {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isExpanded = true
                                isFocused = true
                            }
                        } else {
                            searchText = ""
                        }
                    }
                }) {
                    ZStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(colors.textColor)
                        
                        if !isExpanded && !searchText.isEmpty {
                            Image(systemName: "nosign")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(.red)
                        }
                    }
                    .frame(width: 20)
                }
                
                if isExpanded {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(colors.textColor)
                        .focused($isFocused)
                }
            }
            .padding(.leading, 15)
        }
        .frame(width: isExpanded ? UIScreen.main.bounds.width - 40 : 50, height: 50, alignment: .leading)
        .contentShape(Rectangle())
    }
} 
