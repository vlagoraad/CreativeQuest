import SwiftUI

// MARK: - Stat Card
struct StatCard: View {
    let number: Int
    let label: String
    
    @State private var animateNumber = false
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(number)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.chocolateBrown)
                .scaleEffect(animateNumber ? 1.0 : 0.5)
                .opacity(animateNumber ? 1 : 0)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.coffeeWithMilk)
                .opacity(animateNumber ? 1 : 0)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.offWhite)
        .cornerRadius(15)
        .shadow(color: .chocolateBrown.opacity(0.08), radius: 8, x: 0, y: 4)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)) {
                animateNumber = true
            }
        }
    }
}

// MARK: - Challenge History Card
struct ChallengeHistoryCard: View {
    let challenge: Challenge
    let date: Date
    let dayNumber: Int
    let completedChallenge: CompletedChallenge
    
    @State private var isPressed = false
    
    var backgroundColor: Color {
        switch challenge.colorName {
        case "blue": return Color.peach.opacity(0.3)
        case "red": return Color.dustyRose.opacity(0.3)
        case "pink": return Color.dustyRose.opacity(0.4)
        case "green": return Color.sageGreen.opacity(0.3)
        case "yellow": return Color.honeyGold.opacity(0.3)
        case "orange": return Color.peach.opacity(0.4)
        case "purple": return Color.dustyRose.opacity(0.35)
        case "indigo": return Color.peach.opacity(0.35)
        default: return Color.lightBeige
        }
    }
    
    var body: some View {
        NavigationLink(destination: ChallengeDetailView(completedChallenge: completedChallenge, dayNumber: dayNumber)) {
            VStack(spacing: 12) {
                Text(challenge.emoji)
                    .font(.system(size: 40))
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                Text("Dia \(dayNumber)")
                    .font(.headline)
                    .foregroundColor(.chocolateBrown)
                
                Text(challenge.category)
                    .font(.caption)
                    .foregroundColor(.coffeeWithMilk)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(backgroundColor)
            .cornerRadius(20)
            .shadow(color: .chocolateBrown.opacity(0.05), radius: 4, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                    HapticManager.shared.selection()
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}
