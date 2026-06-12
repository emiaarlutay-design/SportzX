import Foundation

extension DateFormatter {
    static let matchDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d · h:mm a"
        return f
    }()

    static let matchDateShort: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, h:mm a"
        return f
    }()

    static let matchTime: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    static let dayHeader: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f
    }()

    static let icsDate: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return f
    }()
}

extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }

    var isPast: Bool {
        self < Date()
    }

    var relativeDay: String {
        if isToday { return "Today" }
        if isTomorrow { return "Tomorrow" }
        return DateFormatter.dayHeader.string(from: self)
    }

    var minutesUntil: Int {
        Int(timeIntervalSince(Date()) / 60)
    }

    var isStreamAvailable: Bool {
        timeIntervalSinceNow >= -1800
    }
}
