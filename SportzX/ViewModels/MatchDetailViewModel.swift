import Foundation
import AVKit

@MainActor
class MatchDetailViewModel: ObservableObject {
    @Published var match: Match
    @Published var selectedStream: StreamSource?
    @Published var selectedLanguage: String = "All"
    @Published var selectedQuality: String = "All"
    @Published var isPlayerPresented = false

    var allLanguages: [String] {
        let langs = Set(match.streams.map { $0.language })
        return ["All"] + langs.sorted()
    }

    var allQualities: [String] {
        let quals = Set(match.streams.map { $0.quality })
        return ["All"] + quals.sorted()
    }

    var filteredStreams: [StreamSource] {
        match.streams.filter { stream in
            let langMatch = selectedLanguage == "All" || stream.language == selectedLanguage
            let qualMatch = selectedQuality == "All" || stream.quality == selectedQuality
            return langMatch && qualMatch
        }
    }

    var groupedStreams: [(String, [StreamSource])] {
        let grouped = Dictionary(grouping: filteredStreams) { $0.sourceType.rawValue.uppercased() }
        return grouped.sorted { $0.key < $1.key }
    }

    var canWatch: Bool {
        match.isAvailable || match.isLive
    }

    var countdownText: String {
        if match.isLive { return "LIVE" }
        let interval = match.date.timeIntervalSince(Date())
        if interval <= 0 { return "LIVE" }
        if interval <= 3600 {
            let minutes = Int(interval) / 60
            return "Stream available in \(minutes)m"
        }
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "Stream available in \(hours)h \(minutes)m"
    }

    init(match: Match) {
        self.match = match
        self.selectedStream = match.streams.first
    }

    func selectStream(_ stream: StreamSource) {
        selectedStream = stream
    }

    func presentPlayer() {
        guard canWatch, selectedStream != nil else { return }
        isPlayerPresented = true
    }

    func getPlayerItem() -> AVPlayerItem? {
        guard let stream = selectedStream else { return nil }
        switch stream.sourceType {
        case .m3u8, .m3u:
            return AVPlayerItem(url: URL(string: stream.url)!)
        case .web, .embed:
            return nil
        }
    }
}
