import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: ChallengeDataManager
    @State private var showingHistory = false
    @State private var showCelebration = false
    
    var body: some View {
        NavigationStack {
            if showCelebration {
                CelebrationView(
                    streak: dataManager.currentStreak,
                    total: dataManager.completedChallenges.count,
                    onDismiss: {
                        showCelebration = false
                    }
                )
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Streak Card
                        StreakCard(streak: dataManager.currentStreak)
                        
                        // Today's Challenge
                        if let challenge = dataManager.todayChallenge {
                            TodayChallengeCard(
                                challenge: challenge,
                                isCompleted: dataManager.isTodayCompleted(),
                                onComplete: {
                                    dataManager.completeChallenge()
                                    showCelebration = true
                                }
                            )
                        }
                        
                        // Badges Section
                        BadgesSection(
                            total: dataManager.completedChallenges.count,
                            maxStreak: dataManager.maxStreak
                        )
                        
                        Text("Continue assim!")
                            .font(.headline)
                            .foregroundColor(.coffeeWithMilk)
                            .padding(.top)
                    }
                    .padding()
                }
                .background(Color.creamWarm)
                .navigationTitle("CreativeQuest")
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color.offWhite, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            HapticManager.shared.light() // HAPTIC FEEDBACK!
                            showingHistory = true
                        } label: {
                            Label("Histórico", systemImage: "calendar")
                                .foregroundColor(.chocolateBrown)
                        }
                    }
                }
                .sheet(isPresented: $showingHistory) {
                    HistoryView()
                }
            }
        }
        .tint(.chocolateBrown)
        .onAppear {
            dataManager.checkAndGenerateNewChallenge()
        }
    }
}
