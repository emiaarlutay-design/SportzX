import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var scheduleVM = ScheduleViewModel()
    @State private var showFilters = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                datePicker
                sportFilterBar
                leagueFilterChips
                matchesList
            }
            .background(Color.surfaceColor.ignoresSafeArea())
            .navigationTitle("Schedule")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(.accentGreen)
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                LeagueFilterView()
            }
        }
    }

    private var datePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(scheduleVM.dateRange, id: \.timeIntervalSince1970) { date in
                    DateCell(date: date, isSelected: scheduleVM.selectedDate.isSameDay(as: date))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                scheduleVM.selectedDate = date
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.surfaceSecondary)
    }

    private var sportFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SportType.allCases, id: \.self) { sport in
                    SportFilterChip(sport: sport, isSelected: appVM.selectedSport == sport)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                appVM.selectedSport = sport
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private var leagueFilterChips: some View {
        Group {
            if !appVM.selectedLeagueIDs.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(appVM.selectedLeagueIDs), id: \.self) { lid in
                            if let league = appVM.leaguesForSelectedSport.first(where: { $0.id == lid }) {
                                HStack(spacing: 4) {
                                    Text("\(league.icon) \(league.name)")
                                        .font(.caption2)
                                    Button(action: { appVM.toggleLeague(lid) }) {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 8, weight: .bold))
                                    }
                                }
                                .foregroundColor(.accentGreen)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.accentGreen.opacity(0.15))
                                .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                }
            }
        }
    }

    private var matchesList: some View {
        Group {
            if appVM.isLoading && appVM.allMatches.isEmpty {
                VStack(spacing: 16) {
                    ProgressView().scaleEffect(1.2).tint(.accentGreen)
                    Text("Loading matches...").font(.subheadline).foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if appVM.filteredMatches.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "sportscourt")
                        .font(.system(size: 48))
                        .foregroundColor(.textTertiary)
                    Text("No matches found")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.textSecondary)
                    Text("Try selecting a different sport or date")
                        .font(.subheadline)
                        .foregroundColor(.textTertiary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    let dayMatches = scheduleVM.matches(for: scheduleVM.selectedDate, from: appVM.allMatches)
                    ForEach(dayMatches) { match in
                        NavigationLink(destination: MatchDetailView(match: match)) {
                            MatchRowView(match: match)
                        }
                        .listRowBackground(Color.cardBackground)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .refreshable {
                    await appVM.loadAllData()
                }
            }
        }
    }
}

struct DateCell: View {
    let date: Date
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(date, formatter: {
                let f = DateFormatter()
                f.dateFormat = "EEE"
                return f
            }())
            .font(.caption2.weight(.medium))

            Text(date, formatter: {
                let f = DateFormatter()
                f.dateFormat = "d"
                return f
            }())
            .font(.title3.weight(.bold))
        }
        .foregroundColor(isSelected ? .white : .textSecondary)
        .frame(width: 48, height: 56)
        .background(isSelected ? Color.accentGreen : Color.surfaceTertiary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            date.isToday ?
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.accentGreen.opacity(0.5), lineWidth: 1)
            : nil
        )
    }
}

struct SportFilterChip: View {
    let sport: SportType
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 6) {
            Text(sport.icon)
                .font(.caption)
            Text(sport.rawValue)
                .font(.caption.weight(.semibold))
        }
        .foregroundColor(isSelected ? .white : .textSecondary)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(isSelected ? Color.accentGreen : Color.surfaceTertiary)
        .clipShape(Capsule())
    }
}

struct LeagueFilterView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Select All") { appVM.selectAllLeagues() }
                        .foregroundColor(.accentGreen)
                    Button("Deselect All") { appVM.deselectAllLeagues() }
                        .foregroundColor(.liveRed)
                }
                .listRowBackground(Color.cardBackground)

                ForEach(appVM.leaguesForSelectedSport) { league in
                    HStack {
                        Text("\(league.icon) \(league.name)")
                            .foregroundColor(.white)
                        Spacer()
                        if appVM.selectedLeagueIDs.contains(league.id) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentGreen)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { appVM.toggleLeague(league.id) }
                    .listRowBackground(Color.cardBackground)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.surfaceColor)
            .navigationTitle("Filter Leagues")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.accentGreen)
                }
            }
        }
    }
}
