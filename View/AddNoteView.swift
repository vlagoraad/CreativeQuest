import SwiftUI

struct AddNoteView: View {
    @Binding var notes: String
    @Environment(\.dismiss) var dismiss
    let challengeTitle: String
    let onSave: () -> Void
    
    @State private var localNotes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Como foi seu desafio?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.chocolateBrown)
                        
                        Text(challengeTitle)
                            .font(.subheadline)
                            .foregroundColor(.coffeeWithMilk)
                    }
                    
                    // Campo de texto
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Suas Reflexões", systemImage: "note.text")
                            .font(.headline)
                            .foregroundColor(.chocolateBrown)
                        
                        TextEditor(text: $localNotes)
                            .font(.body)
                            .foregroundColor(.chocolateBrown)
                            .padding()
                            .frame(minHeight: 200)
                            .background(Color.offWhite)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.lightBeige, lineWidth: 1.5)
                            )
                            .shadow(color: .chocolateBrown.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    
                    // Sugestões
                    VStack(alignment: .leading, spacing: 12) {
                        Text("💡 Sugestões do que anotar:")
                            .font(.headline)
                            .foregroundColor(.chocolateBrown)
                        
                        SuggestionRow(text: "O que você aprendeu com este desafio?")
                        SuggestionRow(text: "Como se sentiu durante a atividade?")
                        SuggestionRow(text: "O que faria diferente da próxima vez?")
                    }
                    .padding()
                    .background(Color.honeyGold.opacity(0.15))
                    .cornerRadius(15)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color.creamWarm)
            .navigationTitle("Adicionar Reflexão")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.offWhite, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        HapticManager.shared.light() // HAPTIC FEEDBACK!
                        dismiss()
                    }
                    .foregroundColor(.chocolateBrown)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        HapticManager.shared.success() // HAPTIC FEEDBACK!
                        notes = localNotes
                        onSave()
                        dismiss()
                    }
                    .foregroundColor(.chocolateBrown)
                    .fontWeight(.semibold)
                }
            }
        }
        .tint(.chocolateBrown)
        .onAppear {
            localNotes = notes
        }
    }
}

// MARK: - Suggestion Row
struct SuggestionRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "lightbulb.fill")
                .font(.caption)
                .foregroundColor(.honeyGold)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.coffeeWithMilk)
        }
    }
}
