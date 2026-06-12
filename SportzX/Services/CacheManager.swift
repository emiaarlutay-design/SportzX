import Foundation

actor CacheManager {
    private let defaults = UserDefaults.standard
    private let matchesKey = "cached_matches"
    private let streamsKey = "cached_streams"
    private let lastFetchKey = "last_fetch_time"

    func saveMatches(_ matches: [Match]) {
        if let data = try? JSONEncoder().encode(matches) {
            defaults.set(data, forKey: matchesKey)
            defaults.set(Date().timeIntervalSince1970, forKey: lastFetchKey)
        }
    }

    func loadMatches() -> [Match] {
        guard let data = defaults.data(forKey: matchesKey),
              let matches = try? JSONDecoder().decode([Match].self, from: data) else {
            return []
        }
        return matches
    }

    func saveStreams(_ streams: [StreamSource]) {
        if let data = try? JSONEncoder().encode(streams) {
            defaults.set(data, forKey: streamsKey)
        }
    }

    func loadStreams() -> [StreamSource] {
        guard let data = defaults.data(forKey: streamsKey),
              let streams = try? JSONDecoder().decode([StreamSource].self, from: data) else {
            return []
        }
        return streams
    }

    func lastFetchTime() -> Date? {
        let ts = defaults.double(forKey: lastFetchKey)
        return ts > 0 ? Date(timeIntervalSince1970: ts) : nil
    }

    func needsRefresh() -> Bool {
        guard let last = lastFetchTime() else { return true }
        return Date().timeIntervalSince(last) > 3600
    }
}
