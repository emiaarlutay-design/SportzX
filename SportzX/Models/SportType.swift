import Foundation

enum SportType: String, CaseIterable, Codable {
    case soccer = "Soccer"
    case basketball = "Basketball"
    case americanFootball = "American Football"
    case hockey = "Hockey"
    case baseball = "Baseball"
    case tennis = "Tennis"
    case motorsport = "Motorsport"
    case ufc = "UFC/Boxing"
    case rugby = "Rugby"
    case cricket = "Cricket"
    case golf = "Golf"
    case cycling = "Cycling"

    var icon: String {
        switch self {
        case .soccer: return "⚽️"
        case .basketball: return "🏀"
        case .americanFootball: return "🏈"
        case .hockey: return "🏒"
        case .baseball: return "⚾️"
        case .tennis: return "🎾"
        case .motorsport: return "🏎"
        case .ufc: return "🥊"
        case .rugby: return "🏉"
        case .cricket: return "🏏"
        case .golf: return "⛳️"
        case .cycling: return "🚴"
        }
    }

    var systemImage: String {
        switch self {
        case .soccer: return "sportscourt.fill"
        case .basketball: return "basketball.fill"
        case .americanFootball: return "football.fill"
        case .hockey: return "hockey.puck.fill"
        case .baseball: return "baseball.fill"
        case .tennis: return "tennisball.fill"
        case .motorsport: return "car.fill"
        case .ufc: return "figure.boxing"
        case .rugby: return "figure.rugby"
        case .cricket: return "figure.cricket"
        case .golf: return "figure.golf"
        case .cycling: return "figure.indoor.cycle"
        }
    }
}
