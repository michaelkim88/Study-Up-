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
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(colors.textColor)
                    .frame(width: 20)
                
                if isExpanded {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(colors.textColor)
                        .focused($isFocused)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(colors.textColor.opacity(0.6))
                        }
                        .padding(.trailing, 8)
                    }
                }
            }
            .padding(.leading, 15)
        }
        .frame(width: isExpanded ? ((UIScreen.main.bounds.width * 0.6) / 2 + 35 + 50 + 40) : 50, height: 50)
        .contentShape(Rectangle())
    }
} 