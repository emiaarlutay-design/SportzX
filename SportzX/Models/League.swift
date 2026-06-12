import Foundation

struct League: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let sport: SportType
    let icon: String
    let calendarURL: String
    let country: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: League, rhs: League) -> Bool {
        lhs.id == rhs.id
    }

    static let all: [League] = [
        // Soccer - Top Leagues
        League(id: "premier-league", name: "Premier League", sport: .soccer, icon: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", calendarURL: "https://ics.fixtur.es/v2/league/premier-league.ics", country: "England"),
        League(id: "la-liga", name: "La Liga", sport: .soccer, icon: "🇪🇸", calendarURL: "https://ics.fixtur.es/v2/league/primera-division.ics", country: "Spain"),
        League(id: "bundesliga", name: "Bundesliga", sport: .soccer, icon: "🇩🇪", calendarURL: "https://ics.fixtur.es/v2/league/bundesliga.ics", country: "Germany"),
        League(id: "serie-a", name: "Serie A", sport: .soccer, icon: "🇮🇹", calendarURL: "https://ics.fixtur.es/v2/league/serie-a.ics", country: "Italy"),
        League(id: "ligue-1", name: "Ligue 1", sport: .soccer, icon: "🇫🇷", calendarURL: "https://ics.fixtur.es/v2/league/ligue-1.ics", country: "France"),
        League(id: "eredivisie", name: "Eredivisie", sport: .soccer, icon: "🇳🇱", calendarURL: "https://ics.fixtur.es/v2/league/eredivisie.ics", country: "Netherlands"),
        League(id: "primeira-liga", name: "Primeira Liga", sport: .soccer, icon: "🇵🇹", calendarURL: "https://ics.fixtur.es/v2/league/superliga.ics", country: "Portugal"),
        League(id: "mls", name: "MLS", sport: .soccer, icon: "🇺🇸", calendarURL: "https://ics.fixtur.es/v2/league/mls-major-league-soccer.ics", country: "USA"),
        League(id: "ligamx", name: "Liga MX", sport: .soccer, icon: "🇲🇽", calendarURL: "https://ics.fixtur.es/v2/league/liga-mx.ics", country: "Mexico"),
        League(id: "serie-a-brazil", name: "Serie A Brazil", sport: .soccer, icon: "🇧🇷", calendarURL: "https://ics.fixtur.es/v2/league/serie-a-brazil.ics", country: "Brazil"),
        League(id: "argentina-primera", name: "Primera División Argentina", sport: .soccer, icon: "🇦🇷", calendarURL: "https://ics.fixtur.es/v2/league/primera-division-argentina.ics", country: "Argentina"),
        League(id: "saudi-league", name: "Saudi Pro League", sport: .soccer, icon: "🇸🇦", calendarURL: "https://ics.fixtur.es/v2/league/saudi-professional-league.ics", country: "Saudi Arabia"),
        League(id: "super-lig", name: "Süper Lig", sport: .soccer, icon: "🇹🇷", calendarURL: "https://ics.fixtur.es/v2/league/superlig.ics", country: "Turkey"),

        // Soccer - Lower Divisions
        League(id: "efl-championship", name: "EFL Championship", sport: .soccer, icon: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", calendarURL: "https://ics.fixtur.es/v2/league/efl-championship.ics", country: "England"),
        League(id: "2-bundesliga", name: "2. Bundesliga", sport: .soccer, icon: "🇩🇪", calendarURL: "https://ics.fixtur.es/v2/league/2-bundesliga.ics", country: "Germany"),
        League(id: "serie-b", name: "Serie B", sport: .soccer, icon: "🇮🇹", calendarURL: "https://ics.fixtur.es/v2/league/serie-b.ics", country: "Italy"),
        League(id: "ligue-2", name: "Ligue 2", sport: .soccer, icon: "🇫🇷", calendarURL: "https://ics.fixtur.es/v2/league/ligue-2.ics", country: "France"),

        // Soccer - International Competitions
        League(id: "champions-league", name: "UEFA Champions League", sport: .soccer, icon: "🇪🇺", calendarURL: "https://ics.fixtur.es/v2/league/champions-league.ics", country: "Europe"),
        League(id: "europa-league", name: "UEFA Europa League", sport: .soccer, icon: "🇪🇺", calendarURL: "https://ics.fixtur.es/v2/league/europa-league.ics", country: "Europe"),
        League(id: "nations-league", name: "UEFA Nations League", sport: .soccer, icon: "🇪🇺", calendarURL: "https://ics.fixtur.es/v2/league/nations-league.ics", country: "Europe"),
        League(id: "world-cup-2026", name: "FIFA World Cup 2026", sport: .soccer, icon: "🌍", calendarURL: "https://ics.fixtur.es/v2/league/fifa-world-cup-2026.ics", country: "International"),
        League(id: "copa-america", name: "Copa América", sport: .soccer, icon: "🌎", calendarURL: "https://ics.fixtur.es/v2/league/copa-america.ics", country: "South America"),
        League(id: "africa-cup", name: "Africa Cup of Nations", sport: .soccer, icon: "🌍", calendarURL: "https://ics.fixtur.es/v2/league/africa-cup-of-nations.ics", country: "Africa"),
        League(id: "afc-asian-cup", name: "AFC Asian Cup", sport: .soccer, icon: "🌏", calendarURL: "https://ics.fixtur.es/v2/league/afc-asian-cup.ics", country: "Asia"),

        // Soccer - Women's
        League(id: "wsl", name: "FA Women's Super League", sport: .soccer, icon: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", calendarURL: "https://ics.fixtur.es/v2/league/fa-womens-super-league.ics", country: "England"),
        League(id: "nwsl", name: "NWSL", sport: .soccer, icon: "🇺🇸", calendarURL: "https://ics.fixtur.es/v2/league/nwsl-national-womens-soccer-league.ics", country: "USA"),

        // Other Sports
        League(id: "nba", name: "NBA", sport: .basketball, icon: "🇺🇸", calendarURL: "https://ics.fixtur.es/v2/league/nba.ics", country: "USA"),
        League(id: "nfl", name: "NFL", sport: .americanFootball, icon: "🇺🇸", calendarURL: "https://ics.fixtur.es/v2/league/nfl.ics", country: "USA"),
        League(id: "nhl", name: "NHL", sport: .hockey, icon: "🇺🇸", calendarURL: "https://ics.fixtur.es/v2/league/nhl.ics", country: "USA"),
        League(id: "mlb", name: "MLB", sport: .baseball, icon: "🇺🇸", calendarURL: "https://ics.fixtur.es/v2/league/mlb.ics", country: "USA"),
        League(id: "formula-1", name: "Formula 1", sport: .motorsport, icon: "🏎", calendarURL: "https://ics.fixtur.es/v2/league/formula-1.ics", country: "International"),
        League(id: "motogp", name: "MotoGP", sport: .motorsport, icon: "🏍", calendarURL: "https://ics.fixtur.es/v2/league/motogp.ics", country: "International"),
        League(id: "tennis-atp", name: "ATP Tennis", sport: .tennis, icon: "🎾", calendarURL: "https://ics.fixtur.es/v2/league/tennis/atp-1000.ics", country: "International"),
        League(id: "tennis-wta", name: "WTA Tennis", sport: .tennis, icon: "🎾", calendarURL: "https://ics.fixtur.es/v2/league/tennis/wta-1000.ics", country: "International"),
        League(id: "ufc", name: "UFC", sport: .ufc, icon: "🥊", calendarURL: "https://ics.fixtur.es/v2/league/ufc.ics", country: "International"),
    ]
}
