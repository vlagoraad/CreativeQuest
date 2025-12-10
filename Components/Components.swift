import SwiftUI

// MARK: - Streak Card
struct StreakCard: View {
    let streak: Int
    @State private var animateProgress = false
    
    var body: some View {
        HStack {
            Text("🔥")
                .font(.system(size: 40))
                .scaleEffect(animateProgress ? 1.1 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animateProgress)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Streak: \(streak) Dias")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.chocolateBrown)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.lightBeige)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [.peach, .dustyRose],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: animateProgress ? min(CGFloat(streak) / 30.0 * geometry.size.width, geometry.size.width) : 0)
                            .animation(.easeOut(duration: 1.0), value: animateProgress)
                    }
                }
                .frame(height: 8)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.offWhite)
        .cornerRadius(20)
        .shadow(color: .chocolateBrown.opacity(0.08), radius: 8, x: 0, y: 4)
        .onAppear {
            animateProgress = true
        }
    }
}

// MARK: - Today's Challenge Card
struct TodayChallengeCard: View {
    let challenge: Challenge
    let isCompleted: Bool
    let onComplete: () -> Void
    
    @State private var isPressed = false
    @State private var showContent = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(challenge.emoji)
                    .font(.system(size: 40))
                    .rotationEffect(.degrees(showContent ? 0 : -180))
                    .opacity(showContent ? 1 : 0)
                
                Text("Desafio do Dia")
                    .font(.headline)
                    .foregroundColor(.coffeeWithMilk)
                    .opacity(showContent ? 1 : 0)
            }
            
            Text(challenge.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.chocolateBrown)
                .opacity(showContent ? 1 : 0)
                .offset(x: showContent ? 0 : -20)
            
            Text(challenge.description)
                .font(.body)
                .foregroundColor(.coffeeWithMilk)
                .fixedSize(horizontal: false, vertical: true)
                .opacity(showContent ? 1 : 0)
                .offset(x: showContent ? 0 : -20)
            
            if isCompleted {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.sageGreen)
                    Text("Desafio completado hoje!")
                        .fontWeight(.semibold)
                        .foregroundColor(.sageGreen)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.sageGreen.opacity(0.15))
                .cornerRadius(15)
                .transition(.scale.combined(with: .opacity))
            } else {
                Button(action: {
                    HapticManager.shared.success()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onComplete()
                    }
                }) {
                    Text("Completei o Desafio")
                        .fontWeight(.semibold)
                        .foregroundColor(.chocolateBrown)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.honeyGold)
                        .cornerRadius(15)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                }
            }
        }
        .padding()
        .background(Color.offWhite)
        .cornerRadius(20)
        .shadow(color: .chocolateBrown.opacity(0.08), radius: 8, x: 0, y: 4)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}

// MARK: - Badge Card
struct BadgeCard: View {
    let number: Int
    let emoji: String
    let label: String
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text("\(number)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.chocolateBrown)
                    .scaleEffect(animate ? 1.0 : 0.5)
                    .opacity(animate ? 1 : 0)
                Text(emoji)
                    .font(.system(size: 48))
                    .rotationEffect(.degrees(animate ? 0 : 360))
            }
            
            Text(label)
                .font(.headline)
                .foregroundColor(.coffeeWithMilk)
                .opacity(animate ? 1 : 0)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.offWhite)
        .cornerRadius(20)
        .shadow(color: .chocolateBrown.opacity(0.08), radius: 8, x: 0, y: 4)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                animate = true
            }
        }
    }
}

// MARK: - Badges Section
struct BadgesSection: View {
    let total: Int
    let maxStreak: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Badges")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.chocolateBrown)
            
            HStack(spacing: 16) {
                BadgeCard(
                    number: total,
                    emoji: "🏆",
                    label: "Total"
                )
                
                BadgeCard(
                    number: maxStreak,
                    emoji: "🔥",
                    label: "Recorde"
                )
            }
        }
    }
}
