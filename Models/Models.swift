import Foundation

// MARK: - Challenge Model
struct Challenge: Identifiable, Codable {
    let id: Int
    let category: String
    let emoji: String
    let title: String
    let description: String
    let duration: String
    let colorName: String
}

// MARK: - CompletedChallenge Model
struct CompletedChallenge: Identifiable, Codable {
    let id: UUID
    let challenge: Challenge
    let completedDate: Date
    var notes: String // NOVA PROPRIEDADE para reflexões
    
    // Inicializador para compatibilidade
    init(id: UUID = UUID(), challenge: Challenge, completedDate: Date, notes: String = "") {
        self.id = id
        self.challenge = challenge
        self.completedDate = completedDate
        self.notes = notes
    }
}
