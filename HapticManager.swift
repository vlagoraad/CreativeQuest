import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    // Feedback de sucesso (ao completar desafio)
    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // Feedback leve (ao clicar em botões)
    func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    // Feedback médio (ao navegar)
    func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // Feedback de seleção (ao interagir com elementos)
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
