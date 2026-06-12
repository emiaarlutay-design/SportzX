import Foundation

actor StreamMatcher {
    func matchStreams(to matches: [Match], from allStreams: [StreamSource]) -> [String: [StreamSource]] {
        var matchStreams: [String: [StreamSource]] = [:]

        let now = Date()
        let calendar = Calendar.current

        for match in matches {
            let matchStart = match.date
            let matchEnd = matchStart.addingTimeInterval(7200)

            let relevantStreams = allStreams.filter { stream in
                guard stream.sourceType == .m3u8 else { return true }
                return true
            }

            var scored = relevantStreams.map { stream -> (StreamSource, Int) in
                var score = 0
                let title = stream.title.lowercased()
                let homeLower = match.homeTeam.lowercased()
                let awayLower = match.awayTeam.lowercased()
                let leagueLower = match.leagueName.lowercased()

                if title.contains(leagueLower) { score += 30 }
                if title.contains(homeLower) || title.contains(awayLower) { score += 20 }

                let homeWords = homeLower.components(separatedBy: " ")
                let awayWords = awayLower.components(separatedBy: " ")
                for word in homeWords where word.count > 3 && title.contains(word) { score += 10 }
                for word in awayWords where word.count > 3 && title.contains(word) { score += 10 }

                let sportMap: [SportType: [String]] = [
                    .soccer: ["soccer", "football", "futbol"],
                    .basketball: ["basketball", "nba"],
                    .americanFootball: ["football", "nfl"],
                    .hockey: ["hockey", "nhl"],
                    .baseball: ["baseball", "mlb"],
                    .motorsport: ["f1", "formula", "motogp", "motorsport"],
                    .ufc: ["ufc", "boxing", "fight"],
                    .tennis: ["tennis", "atp", "wta"],
                ]

                if let keywords = sportMap[match.sport] {
                    for kw in keywords where title.contains(kw) { score += 15 }
                }

                if stream.isBackup { score -= 5 }

                return (stream, score)
            }

            scored.sort { $0.1 > $1.1 }

            let threshold = match.sport == .soccer ? 10 : 5
            let matched = scored.filter { $0.1 >= threshold }.map { $0.0 }

            if !matched.isEmpty {
                matchStreams[match.id] = matched
            } else {
                let genericSports = allStreams.filter { stream in
                    let title = stream.title.lowercased()
                    let sportMap: [SportType: [String]] = [
                        .soccer: ["sport", "bein", "tnt", "espn", "sky sports", "cloud sports"],
                        .basketball: ["sport", "espn", "tnt", "nba"],
                        .motorsport: ["f1", "formula", "motorsport"],
                        .ufc: ["ufc", "boxing", "fight"],
                    ]
                    if let keywords = sportMap[match.sport] {
                        return keywords.contains { title.contains($0) }
                    }
                    return false
                }
                if !genericSports.isEmpty {
                    matchStreams[match.id] = Array(genericSports.prefix(3))
                }
            }
        }

        return matchStreams
    }
}
