import SwiftUI

struct CelebrationView: View {
    let streak: Int
    let total: Int
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = -180
    @State private var showStats = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.peach, .dustyRose, .honeyGold],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("🏆")
                    .font(.system(size: 100))
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                
                Text("Parabéns!")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.chocolateBrown)
                    .opacity(opacity)
                    .offset(y: opacity == 1 ? 0 : 20)
                
                Text("Desafio completado!")
                    .font(.title2)
                    .foregroundColor(.chocolateBrown.opacity(0.8))
                    .opacity(opacity)
                    .offset(y: opacity == 1 ? 0 : 20)
                
                if showStats {
                    VStack(spacing: 12) {
                        Text("Streak: \(streak) dias 🔥")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.chocolateBrown)
                            .transition(.scale.combined(with: .opacity))
                        
                        Text("Total: \(total) desafios ⭐")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.chocolateBrown)
                            .transition(.scale.combined(with: .opacity))
                    }
                    .padding(.top)
                }
            }
        }
        .onAppear {
            // Animação do troféu
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.2
                rotation = 0
            }
            
            // Animação do texto
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                opacity = 1
            }
            
            // Animação das estatísticas
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) {
                showStats = true
            }
            
            // Pequeno bounce no troféu
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    scale = 1.0
                }
            }
            
            // Dismiss após 2.5 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.3)) {
                    opacity = 0
                    scale = 0.5
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onDismiss()
                }
            }
        }
    }
}
