////
////  testing.swift
////  Study Up
////
////  Created by Michael Kim on 3/7/25.
////
//
//import SwiftUI
//
//@Model
//class StudyItem {
//    var text: String
//    
//    init(text: String = "Tap and hold to edit...") {
//        self.text = text
//    }
//}
//
//struct Testing: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var studyItems: [StudyItem]
//    @State private var isExpanded: Bool = false
//    @State private var currentIndex = 0
//    
//    var currentText: Binding<String> {
//        Binding(
//            get: { studyItems.first?.text ?? "Tap and hold to edit..." },
//            set: { newValue in
//                if let item = studyItems.first {
//                    item.text = newValue
//                } else {
//                    let newItem = StudyItem(text: newValue)
//                    modelContext.insert(newItem)
//                }
//            }
//        )
//    }
//    
//    var body: some View {
//        VStack {
//            
//            Text("Study Set")
//                .font(.largeTitle)
//                .fontWeight(.heavy)
//                .multilineTextAlignment(.center)
//                .frame(maxWidth: .infinity, alignment: .center)
//            Spacer()
//            
//            if isExpanded {
//                VStack {
//                    TextEditor(text: currentText)
//                        .frame(height: 150)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                        .padding()
//                    
//                    Button("Back") {
//                        withAnimation {
//                            isExpanded = false
//                        }
//                    }
//                    .padding()
//                }
//                .transition(.opacity)
//            } else {
//                Text(currentText.wrappedValue)
//                    .frame(maxWidth: .infinity, minHeight: 50)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//                    .onLongPressGesture {
//                        withAnimation (.easeInOut(duration: 0.5)){
//                            isExpanded = true
//                        }
//                    }
//                    .transition(.opacity)
//            }
//            Spacer()
//        }
//        .padding()
//        .onAppear {
//            if studyItems.isEmpty {
//                let initialItem = StudyItem()
//                modelContext.insert(initialItem)
//            }
//        }
//    }
//}
//
//struct ExpandableTextBox_Previews: PreviewProvider {
//    static var previews: some View {
//        Testing()
//    }
//}
//
//
