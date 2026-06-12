import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var showingRefreshConfirm = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        Text("SportzX")
                            .font(.title.weight(.bold))
                            .foregroundColor(.white)
                        Text("Version \(Constants.appVersion)")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                        Text("Free Sports Streaming")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .listRowBackground(Color.cardBackground)
                }

                Section("Data") {
                    HStack {
                        Label("Matches Loaded", systemImage: "sportscourt")
                        Spacer()
                        Text("\(appVM.allMatches.count)")
                            .foregroundColor(.accentGreen)
                    }
                    HStack {
                        Label("Sources", systemImage: "antenna.radiowaves.left.and.right")
                        Spacer()
                        Text("\(Constants.m3uSources.count + Constants.webSources.count)")
                            .foregroundColor(.accentGreen)
                    }
                    HStack {
                        Label("Streams Fetched", systemImage: "play.tv")
                        Spacer()
                        Text("\(appVM.allStreams.count)")
                            .foregroundColor(.accentGreen)
                    }

                    Button(action: { showingRefreshConfirm = true }) {
                        Label("Refresh All Data", systemImage: "arrow.clockwise")
                            .foregroundColor(.accentGreen)
                    }
                }
                .listRowBackground(Color.cardBackground)

                Section("Stream Sources") {
                    ForEach(Constants.m3uSources, id: \.self) { source in
                        HStack {
                            Image(systemName: "play.tv.fill")
                                .font(.caption)
                                .foregroundColor(.accentGreen)
                            Text(URL(string: source)?.host ?? source)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    ForEach(Constants.webSources, id: \.url) { source in
                        HStack {
                            Image(systemName: "safari.fill")
                                .font(.caption)
                                .foregroundColor(.accentGreen)
                            Text(source.name)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)

                Section("Supported Leagues") {
                    let count = Dictionary(grouping: League.all, by: { $0.sport.rawValue })
                        .map { "\($0.key): \($0.value.count)" }
                        .sorted()
                    ForEach(count, id: \.self) { line in
                        Text(line)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                .listRowBackground(Color.cardBackground)

                Section("About") {
                    Link("Sport Calendars by Fixtur.es", destination: URL(string: "https://fixtur.es")!)
                        .foregroundColor(.accentGreen)
                    Link("Stream Sources", destination: URL(string: "https://streamed.pk")!)
                        .foregroundColor(.accentGreen)
                    Text("All trademarks belong to their respective owners.")
                        .font(.caption2)
                        .foregroundColor(.textTertiary)
                }
                .listRowBackground(Color.cardBackground)
            }
            .scrollContentBackground(.hidden)
            .background(Color.surfaceColor)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Refresh Data?", isPresented: $showingRefreshConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Refresh", role: .destructive) {
                    Task { await appVM.loadAllData() }
                }
            } message: {
                Text("This will fetch the latest match schedules and stream sources.")
            }
        }
    }
}
