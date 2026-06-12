import Foundation

actor M3UStreamService {
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }

    func fetchStreams() async throws -> [StreamSource] {
        async let movitvStreams = fetchM3U8(url: "https://movitv.pro/")
        async let drewLiveStreams = fetchM3U8(url: "http://drewlive2423.duckdns.org:8081/DrewLive/MergedCleanPlaylist.m3u8")
        async let streamedPkStreams = fetchWebStreams()
        async let ppvToStreams = fetchWebStreamsAlt()

        let results = try await [movitvStreams, drewLiveStreams, streamedPkStreams, ppvToStreams]
        return results.flatMap { $0 }
    }

    private func fetchM3U8(url: String) async throws -> [StreamSource] {
        guard let url = URL(string: url) else { return [] }

        let (data, _) = try await session.data(from: url)
        guard let content = String(data: data, encoding: .utf8) else { return [] }

        return parseM3U8(content, baseURL: url)
    }

    private func parseM3U8(_ content: String, baseURL: URL) -> [StreamSource] {
        var streams: [StreamSource] = []
        let lines = content.components(separatedBy: .newlines)
        var i = 0

        while i < lines.count {
            let line = lines[i].trimmingCharacters(in: .whitespacesAndNewlines)

            if line.hasPrefix("#EXTINF:") {
                var title = ""
                var group = "Sports"
                var logo = ""

                if let groupRange = line.range(of: "group-title=\"") {
                    let rest = line[groupRange.upperBound...]
                    if let end = rest.firstIndex(of: "\"") {
                        group = String(rest[..<end])
                    }
                }
                if let logoRange = line.range(of: "tvg-logo=\"") {
                    let rest = line[logoRange.upperBound...]
                    if let end = rest.firstIndex(of: "\"") {
                        logo = String(rest[..<end])
                    }
                }

                if let comma = line.lastIndex(of: ",") {
                    title = String(line[line.index(after: comma)...]).trimmingCharacters(in: .whitespaces)
                }

                if i + 1 < lines.count {
                    i += 1
                    let urlLine = lines[i].trimmingCharacters(in: .whitespacesAndNewlines)
                    if !urlLine.hasPrefix("#"), !urlLine.isEmpty {
                        let quality = extractQuality(from: title, line: line)
                        let lang = extractLanguage(from: title, line: line)

                        if group == "Sports" || isSportsChannel(title) {
                            let stream = StreamSource(
                                id: UUID().uuidString,
                                title: title,
                                url: urlLine.starts(with: "http") ? urlLine : "\(baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")))\(urlLine)",
                                quality: quality,
                                language: lang,
                                sourceType: .m3u8,
                                isBackup: title.contains("(") && title.last == ")"
                            )
                            streams.append(stream)
                        }
                    }
                }
            }
            i += 1
        }

        return streams
    }

    private func isSportsChannel(_ title: String) -> Bool {
        let keywords = ["ESPN", "TNT Sports", "Bein Sports", "CBS Sports", "Fox Sports",
                        "Sky Sports", "BT Sport", "NBC Sports", "NBA", "NFL", "NHL",
                        "MLB", "UFC", "Cloud Sports", "Sport", "F1", "MotoGP",
                        "Premier League", "La Liga", "Bundesliga", "Serie A", "Ligue 1",
                        "Champions League", "Europa League"]
        return keywords.contains { title.localizedCaseInsensitiveContains($0) }
    }

    private func extractQuality(from title: String, line: String) -> String {
        let qualities = ["4K", "1080p", "720p", "1080", "720", "HD", "FHD", "SD"]
        for q in qualities {
            if title.localizedCaseInsensitiveContains(q) || line.localizedCaseInsensitiveContains(q) {
                return q
            }
        }
        return "HD"
    }

    private func extractLanguage(from title: String, line: String) -> String {
        if let range = line.range(of: "iso-id=\"") {
            let rest = line[range.upperBound...]
            if let end = rest.firstIndex(of: "\"") {
                let code = String(rest[..<end])
                return languageName(for: code)
            }
        }
        if title.localizedCaseInsensitiveContains("ENG") { return "English" }
        if title.localizedCaseInsensitiveContains("ES") || title.localizedCaseInsensitiveContains("ESP") { return "Spanish" }
        if title.localizedCaseInsensitiveContains("AR") || title.localizedCaseInsensitiveContains("FRA") { return "French" }
        return "English"
    }

    private func languageName(for code: String) -> String {
        switch code {
        case "US", "GB-ENG", "GB": return "English"
        case "ES", "MX": return "Spanish"
        case "FR": return "French"
        case "DE": return "German"
        case "IT": return "Italian"
        case "PT": return "Portuguese"
        case "NL": return "Dutch"
        case "AR": return "Arabic"
        default: return "English"
        }
    }

    private func fetchWebStreams() async throws -> [StreamSource] {
        var streams: [StreamSource] = []
        let sources = [
            ("Streamed PK", "https://streamed.pk"),
            ("PPV.to", "https://ppv.to"),
        ]

        for (name, url) in sources {
            let stream = StreamSource(
                id: UUID().uuidString,
                title: "\(name) - Main",
                url: url,
                quality: "HD",
                language: "English",
                sourceType: .web,
                isBackup: false
            )
            streams.append(stream)
        }

        return streams
    }

    private func fetchWebStreamsAlt() async throws -> [StreamSource] {
        return []
    }
}
