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
    let images = ["IMG_8411", "IMG_8411", "IMG_8411", "IMG_8411", "IMG_8411", "IMG_8411", "IMG_8411", "IMG_8411", "IMG_8411"]
    @State private var currentIndex = 0

    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(images.indices, id: \.self) { index in
                                Image(images[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .clipped()
                                    .id(index)
                            }
                        }
                    }
                    .onChange(of: currentIndex) { newIndex in
                        withAnimation {
                            proxy.scrollTo(newIndex, anchor: .center)
                        }
                    }
                }
            }
            .frame(height: 400) // Adjust height as needed
            
            GeometryReader { geo in
                // Constants for indicator size and spacing
                let indicatorDiameter: CGFloat = 12
                let spacing: CGFloat = 10
                let totalHeight = geo.size.height
                let windowSize = 5
                let halfWindow = windowSize / 2
                
                // Calculate visible range
                var start = currentIndex - halfWindow
                var end = currentIndex + halfWindow
                
                // Adjust if we're near the start
                if start < 0 {
                    start = 0
                    end = min(windowSize - 1, images.count - 1)
                }
                
                // Adjust if we're near the end
                if end >= images.count {
                    end = images.count - 1
                    start = max(0, images.count - windowSize)
                }
                
                let visibleRange = Array(start...end)
                
                return Rectangle()
                    .fill(Color.clear)
                    .frame(width: geo.size.width, height: totalHeight)
                    .overlay {
                        VStack(spacing: spacing) {
                            ForEach(visibleRange, id: \.self) { index in
                                Circle()
                                    .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.5))
                                    .frame(width: indicatorDiameter, height: indicatorDiameter)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            currentIndex = index
                                        }
                                    }
                            }
                        }
                        .frame(width: geo.size.width, height: totalHeight, alignment: .center)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Map the drag's y-location to an image index
                                let y = value.location.y
                                // Determine the proportion of the gesture along the vertical space
                                let proportion = y / totalHeight
                                // Calculate new index based on the number of images
                                let newIndex = min(max(Int(round(proportion * CGFloat(images.count - 1))), 0), images.count - 1)
                                if newIndex != currentIndex {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        currentIndex = newIndex
                                    }
                                }
                            }
                    )
            }
            .frame(width: 40, height: 400)
            .padding(.leading, 8)
            
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


