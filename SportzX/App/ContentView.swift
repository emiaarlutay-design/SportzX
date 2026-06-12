import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable {
        case home = "Home"
        case schedule = "Schedule"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .schedule: return "calendar"
            case .settings: return "gearshape.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.rawValue, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)

            ScheduleView()
                .tabItem {
                    Label(Tab.schedule.rawValue, systemImage: Tab.schedule.icon)
                }
                .tag(Tab.schedule)

            SettingsView()
                .tabItem {
                    Label(Tab.settings.rawValue, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
        .accentColor(.accentGreen)
        .task {
            await appVM.loadAllData()
        }
    }
}
