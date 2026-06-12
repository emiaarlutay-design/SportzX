import Foundation

struct Match: Identifiable, Codable, Hashable {
    let id: String
    let homeTeam: String
    let awayTeam: String
    let date: Date
    let leagueID: String
    let leagueName: String
    let sport: SportType
    var homeScore: Int?
    var awayScore: Int?
    var status: MatchStatus
    var streams: [StreamSource]

    var isLive: Bool {
        let now = Date()
        return date <= now && date.addingTimeInterval(7200) >= now
    }

    var isAvailable: Bool {
        date.addingTimeInterval(-1800) <= Date()
    }

    var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d · h:mm a"
        return f.string(from: date)
    }

    var countdown: String {
        let interval = date.timeIntervalSince(Date())
        if interval <= 0 { return "LIVE" }
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Match, rhs: Match) -> Bool {
        lhs.id == rhs.id
    }
}

enum MatchStatus: String, Codable {
    case upcoming
    case live
    case finished
    case postponed
    case cancelled
}
