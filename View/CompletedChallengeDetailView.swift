import SwiftUI

struct ChallengeDetailView: View {
    let completedChallenge: CompletedChallenge
    let dayNumber: Int
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: ChallengeDataManager
    
    @State private var showingAddNote = false
    @State private var currentNotes: String = ""
    @State private var showContent = false
    
    var backgroundColor: Color {
        switch completedChallenge.challenge.colorName {
        case "blue": return Color.peach.opacity(0.2)
        case "red": return Color.dustyRose.opacity(0.2)
        case "pink": return Color.dustyRose.opacity(0.3)
        case "green": return Color.sageGreen.opacity(0.2)
        case "yellow": return Color.honeyGold.opacity(0.2)
        case "orange": return Color.peach.opacity(0.3)
        case "purple": return Color.dustyRose.opacity(0.25)
        case "indigo": return Color.peach.opacity(0.25)
        default: return Color.lightBeige
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d 'de' MMMM 'de' yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: completedChallenge.completedDate)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: completedChallenge.completedDate)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header com emoji e categoria
                VStack(spacing: 12) {
                    Text(completedChallenge.challenge.emoji)
                        .font(.system(size: 80))
                        .scaleEffect(showContent ? 1.0 : 0.5)
                        .opacity(showContent ? 1 : 0)
                    
                    Text(completedChallenge.challenge.category)
                        .font(.headline)
                        .foregroundColor(.coffeeWithMilk)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(backgroundColor)
                        .cornerRadius(20)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 10)
                }
                .padding(.top, 20)
                
                // Card de informações
                VStack(alignment: .leading, spacing: 20) {
                    // Título
                    Text(completedChallenge.challenge.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.chocolateBrown)
                        .opacity(showContent ? 1 : 0)
                        .offset(x: showContent ? 0 : -20)
                    
                    // Descrição
                    Text(completedChallenge.challenge.description)
                        .font(.body)
                        .foregroundColor(.coffeeWithMilk)
                        .fixedSize(horizontal: false, vertical: true)
                        .opacity(showContent ? 1 : 0)
                        .offset(x: showContent ? 0 : -20)
                    
                    Divider()
                        .background(Color.lightBeige)
                        .opacity(showContent ? 1 : 0)
                    
                    // Informações do desafio
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(icon: "calendar", label: "Data", value: formattedDate)
                            .opacity(showContent ? 1 : 0)
                            .offset(x: showContent ? 0 : -20)
                        
                        InfoRow(icon: "clock", label: "Horário", value: formattedTime)
                            .opacity(showContent ? 1 : 0)
                            .offset(x: showContent ? 0 : -20)
                        
                        InfoRow(icon: "timer", label: "Duração", value: completedChallenge.challenge.duration)
                            .opacity(showContent ? 1 : 0)
                            .offset(x: showContent ? 0 : -20)
                        
                        InfoRow(icon: "number", label: "Desafio", value: "#\(dayNumber)")
                            .opacity(showContent ? 1 : 0)
                            .offset(x: showContent ? 0 : -20)
                    }
                    
                    // Notas (se houver)
                    if !currentNotes.isEmpty {
                        Divider()
                            .background(Color.lightBeige)
                            .opacity(showContent ? 1 : 0)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Suas Reflexões", systemImage: "note.text")
                                .font(.headline)
                                .foregroundColor(.chocolateBrown)
                            
                            Text(currentNotes)
                                .font(.body)
                                .foregroundColor(.coffeeWithMilk)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(backgroundColor)
                                .cornerRadius(12)
                        }
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 10)
                    }
                }
                .padding(20)
                .background(Color.offWhite)
                .cornerRadius(20)
                .shadow(color: .chocolateBrown.opacity(0.08), radius: 8, x: 0, y: 4)
                
                // Botão de adicionar/editar notas
                Button(action: {
                    HapticManager.shared.light()
                    showingAddNote = true
                }) {
                    HStack {
                        Image(systemName: currentNotes.isEmpty ? "plus.circle.fill" : "pencil.circle.fill")
                        Text(currentNotes.isEmpty ? "Adicionar Reflexão" : "Editar Reflexão")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.chocolateBrown)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.honeyGold)
                    .cornerRadius(15)
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1.0 : 0.9)
                
                // Badge de completado
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.sageGreen)
                    Text("Desafio Completado")
                        .fontWeight(.semibold)
                        .foregroundColor(.sageGreen)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.sageGreen.opacity(0.15))
                .cornerRadius(15)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1.0 : 0.9)
            }
            .padding()
        }
        .background(Color.creamWarm)
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.offWhite, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(
                notes: $currentNotes,
                challengeTitle: completedChallenge.challenge.title,
                onSave: {
                    dataManager.updateNotes(for: completedChallenge.id, notes: currentNotes)
                }
            )
        }
        .onAppear {
            currentNotes = completedChallenge.notes
            
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.coffeeWithMilk)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.coffeeWithMilk)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.chocolateBrown)
        }
    }
}
