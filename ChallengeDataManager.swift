import Foundation
import SwiftUI
import Combine

class ChallengeDataManager: ObservableObject {
    @Published var completedChallenges: [CompletedChallenge] = []
    @Published var currentStreak: Int = 0
    @Published var maxStreak: Int = 0
    @Published var todayChallenge: Challenge?
    
    private let challengesKey = "completedChallenges"
    private let streakKey = "currentStreak"
    private let maxStreakKey = "maxStreak"
    private let todayChallengeKey = "todayChallenge"
    private let lastCompletedChallengeIdKey = "lastCompletedChallengeId"
    
    let availableChallenges: [Challenge] = [
        Challenge(id: 1, category: "Fotografia", emoji: "📸", title: "Fotografe algo com padrão geométrico", description: "Observe ao seu redor e capture texturas, formas ou padrões interessantes.", duration: "5-10 min", colorName: "blue"),
        Challenge(id: 2, category: "Design", emoji: "🎨", title: "Crie uma paleta de cores", description: "Escolha 5 cores que representam seu humor atual.", duration: "10 min", colorName: "red"),
        Challenge(id: 3, category: "Escrita", emoji: "✍️", title: "Escreva um micro-conto", description: "Escreva uma história curta com início, meio e fim em 100 palavras.", duration: "12 min", colorName: "pink"),
        Challenge(id: 4, category: "Música", emoji: "🎵", title: "Crie um ritmo", description: "Use objetos ao redor para criar um padrão rítmico de 30 segundos.", duration: "10 min", colorName: "green"),
        Challenge(id: 5, category: "Observação", emoji: "🌳", title: "Observe a natureza", description: "Encontre algo natural e observe todos os detalhes por 5 minutos.", duration: "5 min", colorName: "yellow"),
        Challenge(id: 6, category: "Desenho", emoji: "✏️", title: "Desenhe sem olhar", description: "Escolha um objeto e desenhe-o sem olhar para o papel.", duration: "8 min", colorName: "orange"),
    ]
    
    init() {
        loadData()
        if todayChallenge == nil {
            generateNewChallenge()
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: challengesKey),
           let decoded = try? JSONDecoder().decode([CompletedChallenge].self, from: data) {
            completedChallenges = decoded
        }
        
        currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        maxStreak = UserDefaults.standard.integer(forKey: maxStreakKey)
        
        if let data = UserDefaults.standard.data(forKey: todayChallengeKey),
           let decoded = try? JSONDecoder().decode(Challenge.self, from: data) {
            todayChallenge = decoded
        }
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(completedChallenges) {
            UserDefaults.standard.set(encoded, forKey: challengesKey)
        }
        
        UserDefaults.standard.set(currentStreak, forKey: streakKey)
        UserDefaults.standard.set(maxStreak, forKey: maxStreakKey)
        
        if let challenge = todayChallenge,
           let encoded = try? JSONEncoder().encode(challenge) {
            UserDefaults.standard.set(encoded, forKey: todayChallengeKey)
        }
    }
    
    func generateNewChallenge() {
        todayChallenge = availableChallenges.randomElement()
        saveData()
    }
    
    func completeChallenge() {
        guard let challenge = todayChallenge else { return }
        
        let completed = CompletedChallenge(
            id: UUID(),
            challenge: challenge,
            completedDate: Date(),
            notes: ""
        )
        
        completedChallenges.insert(completed, at: 0)
        
        // Salva o ID do desafio que foi completado
        UserDefaults.standard.set(challenge.id, forKey: lastCompletedChallengeIdKey)
        
        calculateStreak()
        saveData()
    }
    
    func updateNotes(for challengeId: UUID, notes: String) {
        if let index = completedChallenges.firstIndex(where: { $0.id == challengeId }) {
            completedChallenges[index] = CompletedChallenge(
                id: completedChallenges[index].id,
                challenge: completedChallenges[index].challenge,
                completedDate: completedChallenges[index].completedDate,
                notes: notes
            )
            saveData()
        }
    }
    
    func calculateStreak() {
        guard !completedChallenges.isEmpty else {
            currentStreak = 0
            return
        }
        
        let calendar = Calendar.current
        var streak = 1
        
        for i in 0..<completedChallenges.count - 1 {
            let currentDate = calendar.startOfDay(for: completedChallenges[i].completedDate)
            let previousDate = calendar.startOfDay(for: completedChallenges[i + 1].completedDate)
            
            let daysDiff = calendar.dateComponents([.day], from: previousDate, to: currentDate).day ?? 0
            
            if daysDiff == 1 {
                streak += 1
            } else {
                break
            }
        }
        
        currentStreak = streak
        if streak > maxStreak {
            maxStreak = streak
        }
    }
    
    func checkAndGenerateNewChallenge() {
        // Se o desafio atual já foi completado hoje, não gera novo
        if isTodayCompleted() {
            // Verifica se o desafio atual é o mesmo que foi completado
            if let lastCompletedId = UserDefaults.standard.object(forKey: lastCompletedChallengeIdKey) as? Int,
               let currentChallenge = todayChallenge,
               currentChallenge.id == lastCompletedId {
                // Mantém o mesmo desafio
                return
            }
        }
        
        // Se mudou de dia, gera novo desafio
        guard let lastCompleted = completedChallenges.first else {
            return
        }
        
        let calendar = Calendar.current
        let lastCompletedDay = calendar.startOfDay(for: lastCompleted.completedDate)
        let today = calendar.startOfDay(for: Date())
        
        if lastCompletedDay < today {
            generateNewChallenge()
        }
    }
    
    func isTodayCompleted() -> Bool {
        guard let lastCompleted = completedChallenges.first else { return false }
        return Calendar.current.isDateInToday(lastCompleted.completedDate)
    }
    
    func thisMonthChallenges() -> Int {
        let calendar = Calendar.current
        let thisMonth = calendar.component(.month, from: Date())
        let thisYear = calendar.component(.year, from: Date())
        
        return completedChallenges.filter { completed in
            let month = calendar.component(.month, from: completed.completedDate)
            let year = calendar.component(.year, from: completed.completedDate)
            return month == thisMonth && year == thisYear
        }.count
    }
    
    // Função para resetar (temporária para testes)
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: challengesKey)
        UserDefaults.standard.removeObject(forKey: streakKey)
        UserDefaults.standard.removeObject(forKey: maxStreakKey)
        UserDefaults.standard.removeObject(forKey: todayChallengeKey)
        UserDefaults.standard.removeObject(forKey: lastCompletedChallengeIdKey)
        
        completedChallenges = []
        currentStreak = 0
        maxStreak = 0
        generateNewChallenge()
    }
}
