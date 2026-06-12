import Foundation

@MainActor
class ScheduleViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var showOnlyLive: Bool = false

    let calendar = Calendar.current

    var dateRange: [Date] {
        let today = Date()
        return (0..<14).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: today)
        }
    }

    func matches(for date: Date, from allMatches: [Match]) -> [Match] {
        let dayMatches = allMatches.filter { $0.date.isSameDay(as: date) }
        if showOnlyLive {
            return dayMatches.filter { $0.isLive || $0.isAvailable }
        }
        return dayMatches
    }

    func moveDay(_ direction: Int) {
        if let newDate = calendar.date(byAdding: .day, value: direction, to: selectedDate) {
            selectedDate = newDate
        }
    }
}
