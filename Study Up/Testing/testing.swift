import SwiftUI

struct ContentView: View {
    
    @State private var episodes: [Episode] = MockData.episodes
    
    var body: some View {
        NavigationStack {
            List ($episodes, editActions: .move) { episode in
                HStack(alignment: .top, spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 80, height: 80)
                        .foregroundStyle(episode.color.wrappedValue)
                    VStack(alignment: .leading) {
                        Text ("Episode Title")
                            .font(.headline)
                        Text ("Here is the short description for the latest episode.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Episodes")
        }
    }
}

#Preview { NavigationStack { ContentView() } }

class Episode: Identifiable {
    let id = UUID()
    var title: String
    var color: Color
    var listOrder: Int
    
    init(title: String, color: Color, listOrder: Int) {
        self.title = title
        self.color = color
        self.listOrder = listOrder
    }
}

struct MockData {
    static var episodes: [Episode] {
        [
            Episode(title: "Pink Episode", color: .pink, listOrder: 0),
            Episode (title: "Teal Episode", color: .teal, listOrder: 1),
            Episode(title: "Indigo Episode", color: .indigo, listOrder: 2),
            Episode(title: "Orange Episode", color: .orange, listOrder: 3),
            Episode(title: "Green Episode", color: .green, listOrder: 4),
            Episode(title: "Purple Episode", color: .purple, listOrder: 5),
            Episode(title: "Yellow Episode", color: .yellow, listOrder: 6)]}
}
