import Foundation
import Combine

@MainActor
class AppViewModel: ObservableObject {
    @Published var allMatches: [Match] = []
    @Published var selectedSport: SportType = .soccer
    @Published var selectedLeagueIDs: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var allStreams: [StreamSource] = []

    private let calendarService = CalendarFeedService()
    private let m3uService = M3UStreamService()
    private let streamMatcher = StreamMatcher()
    private let cacheManager = CacheManager()

    var filteredMatches: [Match] {
        let sportMatches = allMatches.filter { $0.sport == selectedSport }
        if selectedLeagueIDs.isEmpty {
            return sportMatches
        }
        return sportMatches.filter { selectedLeagueIDs.contains($0.leagueID) }
    }

    var groupedMatches: [(String, [Match])] {
        let grouped = Dictionary(grouping: filteredMatches) { match in
            match.date.relativeDay
        }
        return grouped.sorted { lhs, rhs in
            let d1 = filteredMatches.first { $0.date.relativeDay == lhs.key }?.date ?? Date()
            let d2 = filteredMatches.first { $0.date.relativeDay == rhs.key }?.date ?? Date()
            return d1 < d2
        }
    }

    var leaguesForSelectedSport: [League] {
        League.all.filter { $0.sport == selectedSport }
    }

    func loadAllData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let matchesTask = fetchAllMatches()
            async let streamsTask = fetchAllStreams()

            let (matches, streams) = try await (matchesTask, streamsTask)

            let matcher = StreamMatcher()
            let matched = await matcher.matchStreams(to: matches, from: streams)

            allMatches = matches.map { match in
                var m = match
                m.streams = matched[match.id] ?? []
                return m
            }
            allStreams = streams

            let cache = CacheManager()
            await cache.saveMatches(allMatches)
            await cache.saveStreams(streams)

            isLoading = false
        } catch {
            let cache = CacheManager()
            allMatches = await cache.loadMatches()
            allStreams = await cache.loadStreams()
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func fetchAllMatches() async throws -> [Match] {
        var allMatches: [Match] = []
        let leagues = League.all

        try await withThrowingTaskGroup(of: [Match].self) { group in
            for league in leagues {
                group.addTask {
                    let service = CalendarFeedService()
                    return try await service.fetchMatches(for: league)
                }
            }

            for try await matches in group {
                allMatches.append(contentsOf: matches)
            }
        }

        return allMatches.sorted { $0.date < $1.date }
    }

    private func fetchAllStreams() async throws -> [StreamSource] {
        let service = M3UStreamService()
        return try await service.fetchStreams()
    }

    func refreshIfNeeded() async {
        let cache = CacheManager()
        if await cache.needsRefresh() {
            await loadAllData()
        } else {
            allMatches = await cache.loadMatches()
            allStreams = await cache.loadStreams()
        }
    }

    func toggleLeague(_ leagueID: String) {
        if selectedLeagueIDs.contains(leagueID) {
            selectedLeagueIDs.remove(leagueID)
        } else {
            selectedLeagueIDs.insert(leagueID)
        }
    }

    func selectAllLeagues() {
        selectedLeagueIDs = Set(leaguesForSelectedSport.map { $0.id })
    }

    func deselectAllLeagues() {
        selectedLeagueIDs.removeAll()
    }
}
