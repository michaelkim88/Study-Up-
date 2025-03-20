import SwiftUI

struct FlashcardSetGridItem: View {
    let set: FlashcardSet
    let colors: AppColorScheme
        
    var body: some View {
        VStack {
            Text(set.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(colors.textColor)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(colors.boxColor)
        .cornerRadius(12)
        .shadow(radius: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colors.boxBorderColor, lineWidth: 1)
        )
        .padding(.horizontal, 4)
    }

}
