//
//  testing.swift
//  Study Up
//
//  Created by Michael Kim on 3/7/25.
//

import SwiftUI

struct ExpandableTextBox: View {
    @State private var text: String = "Tap and hold to edit..."
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            Text("Study Set")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            
            if isExpanded {
                VStack {
                    TextEditor(text: $text)
                        .frame(height: 150)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding()
                    
                    Button("Back") {
                        withAnimation {
                            isExpanded = false
                        }
                    }
                    .padding()
                }
                .transition(.opacity)
            } else {
                Text(text)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .onLongPressGesture {
                        withAnimation (.easeInOut(duration: 0.5)){
                            isExpanded = true
                        }
                    }
                    .transition(.opacity)
            }
            Spacer()
        }
        .padding()
    }
}

struct ExpandableTextBox_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableTextBox()
    }
}


