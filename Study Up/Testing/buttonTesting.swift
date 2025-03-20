//
////
////  buttonTesting.swift
////  Study Up
////
////  Created by Michael Kim on 3/19/25.
////
//
//import SwiftUI
//
//struct ButtonTest: View {
//    @State private var showNewScreen = false  // Controls the full-screen transition
//
//    var body: some View {
//        ZStack {
//            Color.white.ignoresSafeArea()  // Background color
//            
//            VStack {
//                Button(action: {
//                    withAnimation {
//                        showNewScreen = true
//                    }
//                }) {
//                    Text("Open Full-Screen View")
//                        .font(.title)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(12)
//                        .padding()
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $showNewScreen) {
//            FullScreenView(showNewScreen: $showNewScreen)
//        }
//    }
//}
//
//struct FullScreenView: View {
//    @Binding var showNewScreen: Bool
//
//    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            
//            VStack {
//                Text("New Full-Screen View")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                
//                Spacer()
//                
//                Button(action: {
//                    withAnimation {
//                        showNewScreen = false  // Dismiss the screen
//                    }
//                }) {
//                    Text("Close")
//                        .font(.title)
//                        .foregroundColor(.black)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .padding()
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonTest()
//    }
//}
