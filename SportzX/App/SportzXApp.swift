import SwiftUI

@main
struct SportzXApp: App {
    @StateObject private var appVM = AppViewModel()

    init() {
        SportzXTheme.applyAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appVM)
                .preferredColorScheme(.dark)
        }
    }
}
