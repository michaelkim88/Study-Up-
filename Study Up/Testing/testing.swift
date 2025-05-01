import SwiftUI
struct TextSheet: View {
    @State var text = "Starting text"
    @FocusState var showkeyboard :Bool
    var body: some View {
        TextEditor(text: $text).bold().font(.title)
            .padding(12)
            .focused($showkeyboard)
            .navigationTitle ("Dynamic keyboard")
            .onAppear (){
                showkeyboard = true
            }
    }
}

import SwiftUI
struct ContentView: View {
    @State var showView = false
    var body: some View {
        VStack {
            Button (action: {
                showView.toggle()
            }, label: {
                Label("Start typing", systemImage: "keyboard.fill")
            })
            .tint(.green)
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .padding()
        .sheet(isPresented: $showView, content: {
            TextSheet ()
        })
    }
}
#Preview {
    ContentView()
}
