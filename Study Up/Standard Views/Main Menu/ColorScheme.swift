import SwiftUI

struct AppColorScheme {
    let colorScheme: ColorScheme
    
    // First color is dark mode, second is light mode
    var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.02, green: 0.02, blue: 0.15) : Color(red: 0.95, green: 0.95, blue: 1.0)
    }
    
    var boxColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color(red: 0.9, green: 0.9, blue: 0.95)
    }
    
    var boxBorderColor: Color {
        colorScheme == .dark ? Color(red: 0.3, green: 0.3, blue: 0.35) : Color(red: 0.8, green: 0.8, blue: 0.85)
    }
    
    var textColor: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    var cutoffColor: Color {
        colorScheme == .dark ? Color(red: 0.05, green: 0.05, blue: 0.2) : Color(red: 0.93, green: 0.93, blue: 0.98)
    }
    
    var buttonTextColor: Color {
        colorScheme == .dark ? Color(red: 0.05, green: 0.05, blue: 0.2) : .white
    }
} 
