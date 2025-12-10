import SwiftUI

@main
struct CreativeQuestAppApp: App {
    @StateObject private var dataManager = ChallengeDataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
