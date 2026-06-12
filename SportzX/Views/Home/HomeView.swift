import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    heroSection
                    sportGrid
                    if appVM.isLoading {
                        loadingSection
                    } else {
                        liveNowSection
                        upcomingSection
                    }
                }
                .padding(.bottom, 24)
            }
            .background(Color.surfaceColor.ignoresSafeArea())
            .navigationTitle("SportzX")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await appVM.loadAllData()
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: 4) {
            Text("All Sports")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text("Real-time schedules & streams")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
    }

    private var sportGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
            ForEach(SportType.allCases, id: \.self) { sport in
                NavigationLink(destination: SportDetailView(sport: sport)) {
                    SportCell(sport: sport, isSelected: appVM.selectedSport == sport)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private var loadingSection: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.accentGreen)
            Text("Loading matches...")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .padding(.vertical, 40)
    }

    private var liveNowSection: some View {
        Group {
            let liveMatches = appVM.allMatches.filter { $0.isLive }
            if !liveMatches.isEmpty {
                sectionHeader(title: "🔴 Live Now", count: liveMatches.count)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(liveMatches.prefix(10)) { match in
                            NavigationLink(destination: MatchDetailView(match: match)) {
                                LiveMatchCard(match: match)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private var upcomingSection: some View {
        Group {
            let upcoming = appVM.allMatches.filter { !$0.isLive && $0.date > Date() }.prefix(10)
            if !upcoming.isEmpty {
                sectionHeader(title: "Upcoming", count: upcoming.count)
                VStack(spacing: 0) {
                    ForEach(Array(upcoming)) { match in
                        NavigationLink(destination: MatchDetailView(match: match)) {
                            UpcomingMatchRow(match: match)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private func sectionHeader(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
            Spacer()
            Text("\(count)")
                .font(.caption.weight(.medium))
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.surfaceSecondary)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 16)
    }
}

struct SportCell: View {
    let sport: SportType
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.accentGreen.opacity(0.2) : Color.surfaceSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.accentGreen : Color.clear, lineWidth: 2)
                    )
                Text(sport.icon)
                    .font(.system(size: 28))
            }
            .frame(height: 64)

            Text(sport.rawValue)
                .font(.caption2.weight(.semibold))
                .foregroundColor(isSelected ? .accentGreen : .textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

struct LiveMatchCard: View {
    let match: Match
    @State private var timeText = ""

    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.liveRed)
                    .frame(width: 8, height: 8)
                Text("LIVE")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.liveRed)
            }

            Text(match.homeTeam)
                .font(.callout.weight(.semibold))
                .foregroundColor(.white)
                .lineLimit(1)

            Text(match.awayTeam)
                .font(.callout.weight(.semibold))
                .foregroundColor(.white)
                .lineLimit(1)

            if let hs = match.homeScore, let as_ = match.awayScore {
                Text("\(hs) - \(as_)")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.accentGreen)
            }

            Text(match.leagueName)
                .font(.caption2)
                .foregroundColor(.textTertiary)
                .lineLimit(1)
        }
        .padding(12)
        .frame(width: 160)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .onReceive(timer) { _ in
            timeText = match.countdown
        }
    }
}

struct UpcomingMatchRow: View {
    let match: Match

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(match.leagueName)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.accentGreen)
                Text(match.homeTeam)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                Text(match.awayTeam)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(match.date, style: .time)
                    .font(.caption.weight(.bold))
                    .foregroundColor(.textSecondary)
                Text(match.date, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

struct SportDetailView: View {
    @EnvironmentObject var appVM: AppViewModel
    let sport: SportType

    var body: some View {
        List {
            let leagues = League.all.filter { $0.sport == sport }
            ForEach(leagues) { league in
                let matches = appVM.allMatches.filter { $0.leagueID == league.id }
                if !matches.isEmpty {
                    Section(header: Text(league.name).font(.headline).foregroundColor(.accentGreen)) {
                        ForEach(matches.prefix(20)) { match in
                            NavigationLink(destination: MatchDetailView(match: match)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(match.homeTeam) vs \(match.awayTeam)")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundColor(.white)
                                    Text(match.formattedDate)
                                        .font(.caption)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                            .listRowBackground(Color.cardBackground)
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.surfaceColor)
        .navigationTitle(sport.rawValue)
        .navigationBarTitleDisplayMode(.large)
    }
}
