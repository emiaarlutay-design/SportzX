import SwiftUI

extension Color {
    static let accentGreen = Color(red: 0.051, green: 0.600, blue: 0.400)
    static let accentGreenLight = Color(red: 0.000, green: 0.478, blue: 0.200)
    static let surfaceColor = Color(red: 0.118, green: 0.118, blue: 0.141)
    static let surfaceSecondary = Color(red: 0.157, green: 0.157, blue: 0.184)
    static let surfaceTertiary = Color(red: 0.200, green: 0.200, blue: 0.235)
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.686, green: 0.686, blue: 0.718)
    static let textTertiary = Color(red: 0.486, green: 0.486, blue: 0.518)
    static let liveRed = Color(red: 1.0, green: 0.231, blue: 0.188)
    static let liveGreen = Color(red: 0.2, green: 0.8, blue: 0.3)
    static let cardBackground = Color(red: 0.157, green: 0.157, blue: 0.184)
    static let dividerColor = Color(red: 0.235, green: 0.235, blue: 0.271)
    static let goldAccent = Color(red: 1.0, green: 0.843, blue: 0.0)
    static let tabInactive = Color(red: 0.4, green: 0.4, blue: 0.44)
}

struct SportzXTheme {
    static func applyAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.surfaceColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(Color.surfaceColor)

        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }
}
