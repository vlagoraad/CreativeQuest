import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var dataManager: ChallengeDataManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Stats
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Meus Desafios")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.chocolateBrown)
                        
                        Text("Novembro 2025")
                            .font(.title3)
                            .foregroundColor(.coffeeWithMilk)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Stats Grid
                    HStack(spacing: 12) {
                        StatCard(
                            number: dataManager.completedChallenges.count,
                            label: "Desafios"
                        )
                        
                        StatCard(
                            number: dataManager.maxStreak,
                            label: "Maior Streak"
                        )
                        
                        StatCard(
                            number: dataManager.thisMonthChallenges(),
                            label: "Este mês"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Challenges Grid (ATUALIZADO)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(Array(dataManager.completedChallenges.enumerated()), id: \.element.id) { index, completed in
                            ChallengeHistoryCard(
                                challenge: completed.challenge,
                                date: completed.completedDate,
                                dayNumber: dataManager.completedChallenges.count - index,
                                completedChallenge: completed // PASSANDO O OBJETO COMPLETO
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.creamWarm)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.offWhite, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fechar") {
                        dismiss()
                    }
                    .foregroundColor(.chocolateBrown)
                }
            }
        }
        .tint(.chocolateBrown)
    }
}
