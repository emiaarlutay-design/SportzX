import Foundation

actor CalendarFeedService {
    private let parser = ICSParser()
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)
    }

    func fetchMatches(for league: League) async throws -> [Match] {
        guard let url = URL(string: league.calendarURL) else {
            throw CalendarError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CalendarError.httpError
        }

        guard let icsString = String(data: data, encoding: .utf8) else {
            throw CalendarError.invalidData
        }

        return await parser.parse(
            icsContent: icsString,
            leagueID: league.id,
            leagueName: league.name,
            sport: league.sport
        )
    }

    enum CalendarError: LocalizedError {
        case invalidURL
        case httpError
        case invalidData

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid calendar URL"
            case .httpError: return "Failed to fetch calendar data"
            case .invalidData: return "Invalid calendar data received"
            }
        }
    }
}
