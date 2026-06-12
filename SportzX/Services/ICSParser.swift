import Foundation

actor ICSParser {
    func parse(icsContent: String, leagueID: String, leagueName: String, sport: SportType) -> [Match] {
        var matches: [Match] = []
        let blocks = icsContent.components(separatedBy: "BEGIN:VEVENT")

        for block in blocks.dropFirst() {
            guard let event = parseEvent(block: block, leagueID: leagueID, leagueName: leagueName, sport: sport) else { continue }
            matches.append(event)
        }

        return matches
    }

    private func parseEvent(block: String, leagueID: String, leagueName: String, sport: SportType) -> Match? {
        let lines = block.components(separatedBy: .newlines)

        var uid = ""
        var dtStart = ""
        var dtEnd = ""
        var summary = ""
        var location = ""

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.hasPrefix("UID:") { uid = String(trimmed.dropFirst(4)) }
            else if trimmed.hasPrefix("DTSTART") {
                let val = trimmed.drop(while: { $0 != ":" }).dropFirst()
                dtStart = String(val)
            }
            else if trimmed.hasPrefix("DTEND") {
                let val = trimmed.drop(while: { $0 != ":" }).dropFirst()
                dtEnd = String(val)
            }
            else if trimmed.hasPrefix("SUMMARY:") { summary = String(trimmed.dropFirst(8)) }
            else if trimmed.hasPrefix("LOCATION:") { location = String(trimmed.dropFirst(9)) }
        }

        guard !uid.isEmpty, !dtStart.isEmpty, !summary.isEmpty else { return nil }

        guard let startDate = parseICSDate(dtStart) else { return nil }

        let (homeTeam, awayTeam, homeScore, awayScore) = parseSummary(summary, sport: sport)

        var status: MatchStatus = .upcoming
        let now = Date()
        if startDate <= now && startDate.addingTimeInterval(7200) >= now {
            status = .live
        } else if startDate.addingTimeInterval(7200) < now {
            status = .finished
        }

        return Match(
            id: uid,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            date: startDate,
            leagueID: leagueID,
            leagueName: leagueName,
            sport: sport,
            homeScore: homeScore,
            awayScore: awayScore,
            status: status,
            streams: []
        )
    }

    private func parseICSDate(_ str: String) -> Date? {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)

        if str.hasSuffix("Z") {
            f.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
            return f.date(from: str)
        }
        if str.count == 8 {
            f.dateFormat = "yyyyMMdd"
            return f.date(from: str)
        }
        f.dateFormat = "yyyyMMdd'T'HHmmss"
        return f.date(from: str)
    }

    private func parseSummary(_ summary: String, sport: SportType) -> (home: String, away: String, homeScore: Int?, awayScore: Int?) {
        if sport == .soccer || sport == .basketball || sport == .hockey || sport == .baseball {
            if let range = summary.range(of: " - ") {
                let before = String(summary[summary.startIndex..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
                let afterAndScore = String(summary[range.upperBound...]).trimmingCharacters(in: .whitespaces)

                if let scoreRange = afterAndScore.range(of: #" \((\d+)-(\d+)\)"#, options: .regularExpression) {
                    let scorePart = String(afterAndScore[scoreRange])
                    let awayTeam = String(afterAndScore[afterAndScore.startIndex..<scoreRange.lowerBound]).trimmingCharacters(in: .whitespaces)
                    let scores = scorePart.trimmingCharacters(in: CharacterSet(charactersIn: " ()"))
                    let parts = scores.components(separatedBy: "-")
                    if parts.count == 2 {
                        return (before, awayTeam, Int(parts[0]), Int(parts[1]))
                    }
                    return (before, awayTeam, nil, nil)
                }
                return (before, afterAndScore, nil, nil)
            }
        }
        return (summary, "", nil, nil)
    }
}
