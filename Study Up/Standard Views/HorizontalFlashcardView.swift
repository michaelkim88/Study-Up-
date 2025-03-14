import SwiftUI
import CoreMotion
import AVFoundation

struct HorizontalFlashcardView: View {
    let flashcardSet: FlashcardSet
    @State private var currentIndex = 0
    @State private var flippedCards: Set<Int> = []
    @State private var timeRemaining = 60
    @State private var timer: Timer?
    @State private var motionManager = CMMotionManager()
    @State private var lastFlipTime = Date()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showEndStudy = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            if !showEndStudy {
                let card = flashcardSet.flashcards[currentIndex]
                
                // Don't use this gives index out of bounds error for now
                ZStack {
                    // Question side
                    VStack {
                        // Back button at the top left
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Text(card.question)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.5)
                        
                        // Timer at the bottom
                        Text("\(timeRemaining)s")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(timeRemaining <= 10 ? .red : .primary)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .opacity(flippedCards.contains(currentIndex) ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(flippedCards.contains(currentIndex) ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    
                    // Answer side
                    VStack {
                        // Back button at the top left
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Text(card.answer)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.5)
                        
                        // Timer at the bottom
                        Text("\(timeRemaining)s")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(timeRemaining <= 10 ? .red : .primary)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 2)
                    )
                    .opacity(flippedCards.contains(currentIndex) ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(flippedCards.contains(currentIndex) ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
                .padding(.horizontal)
                .padding(.vertical)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    startMotionUpdates()
                    startTimer()
                    setupAudioPlayer()
                }
                .onDisappear {
                    stopMotionUpdates()
                    stopTimer()
                }
            } else {
                EndStudyView(flashcardSet: flashcardSet)
            }
        }
    }
    
    private func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
                guard let motion = motion else { return }
                
                let now = Date()
                let timeSinceLastFlip = now.timeIntervalSince(lastFlipTime)
                
                if timeSinceLastFlip >= 0.4 {
                    // Check for upward tilt (incorrect)
                    if motion.attitude.pitch > 0.5 {
                        moveToNextCard()
                        lastFlipTime = now
                    }
                    // Check for downward tilt (correct)
                    else if motion.attitude.pitch < -0.5 {
                        moveToNextCard()
                        lastFlipTime = now
                    }
                }
            }
        }
    }
    
    private func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                playAlarmSound()
                showEndStudy = true
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setupAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error setting up audio player: \(error.localizedDescription)")
        }
    }
    
    private func playAlarmSound() {
        audioPlayer?.play()
    }
    
    private func moveToNextCard() {
        if currentIndex < flashcardSet.flashcards.count - 1 {
            currentIndex += 1
        } else {
            showEndStudy = true
        }
    }
}

#Preview {
    HorizontalFlashcardView(flashcardSet: FlashcardSet(title: "Science", flashcards: [
        Flashcard(question: "What is H2O?", answer: "Water"),
        Flashcard(question: "What is the closest planet to the Sun?", answer: "Mercury"),
        Flashcard(question: "What is the hardest natural substance?", answer: "Diamond")
    ]))
} 
