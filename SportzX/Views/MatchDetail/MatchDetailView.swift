import SwiftUI
import AVKit
import WebKit

struct MatchDetailView: View {
    @StateObject private var vm: MatchDetailViewModel
    @EnvironmentObject var appVM: AppViewModel

    init(match: Match) {
        _vm = StateObject(wrappedValue: MatchDetailViewModel(match: match))
    }

    var body: some View {
        ZStack {
            Color.surfaceColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    matchHeader
                    countdownSection
                    if vm.match.isLive || vm.match.isAvailable {
                        streamPickerSection
                        streamsList
                    } else {
                        lockedSection
                    }
                }
                .padding(.bottom, 40)
            }

            if vm.isPlayerPresented, let stream = vm.selectedStream {
                if stream.sourceType == .m3u8 || stream.sourceType == .m3u {
                    if let url = URL(string: stream.url) {
                        VideoPlayer(player: AVPlayer(url: url))
                            .edgesIgnoringSafeArea(.all)
                            .transition(.move(edge: .bottom))
                    }
                } else {
                    SafariWebView(url: URL(string: stream.url)!)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .navigationTitle("Match Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if vm.isPlayerPresented {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { vm.isPlayerPresented = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private var matchHeader: some View {
        VStack(spacing: 16) {
            Text(vm.match.leagueName)
                .font(.caption.weight(.medium))
                .foregroundColor(.accentGreen)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.accentGreen.opacity(0.15))
                .clipShape(Capsule())

            HStack(spacing: 20) {
                TeamView(name: vm.match.homeTeam, isHome: true)
                VStack(spacing: 4) {
                    if vm.match.isLive || vm.match.status == .finished {
                        HStack(spacing: 12) {
                            Text("\(vm.match.homeScore ?? 0)")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text(":")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.textTertiary)
                            Text("\(vm.match.awayScore ?? 0)")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("VS")
                            .font(.title.weight(.bold))
                            .foregroundColor(.textTertiary)
                    }
                    Text(vm.match.formattedDate)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                TeamView(name: vm.match.awayTeam, isHome: false)
            }
        }
        .padding(20)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var countdownSection: some View {
        Group {
            if !vm.match.isLive && vm.match.status != .finished {
                HStack(spacing: 12) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.accentGreen)
                    Text(vm.countdownText)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.textSecondary)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color.cardBackground)
                .cornerRadius(12)
            }
        }
    }

    private var streamPickerSection: some View {
        VStack(spacing: 12) {
            if !vm.match.streams.isEmpty {
                StreamPickerBar(
                    streams: vm.groupedStreams,
                    selectedStream: $vm.selectedStream,
                    selectedLanguage: $vm.selectedLanguage,
                    selectedQuality: $vm.selectedQuality,
                    allLanguages: vm.allLanguages,
                    allQualities: vm.allQualities
                )

                Button(action: { vm.presentPlayer() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Watch Now")
                            .font(.headline.weight(.bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(vm.canWatch ? Color.accentGreen : Color.surfaceTertiary)
                    .cornerRadius(14)
                }
                .disabled(!vm.canWatch)
                .padding(.horizontal, 16)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "antenna.radiowaves.left.and.right.slash")
                        .font(.title2)
                        .foregroundColor(.textTertiary)
                    Text("No streams available for this match")
                        .font(.subheadline)
                        .foregroundColor(.textTertiary)
                }
                .padding(.vertical, 20)
            }
        }
    }

    private var streamsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Available Streams")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)

            ForEach(vm.filteredStreams) { stream in
                StreamRowView(
                    stream: stream,
                    isSelected: vm.selectedStream?.id == stream.id
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        vm.selectStream(stream)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var lockedSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill")
                .font(.system(size: 40))
                .foregroundColor(.textTertiary)
            Text(vm.countdownText)
                .font(.title3.weight(.semibold))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            Text("Streams will be available 30 minutes before kickoff")
                .font(.subheadline)
                .foregroundColor(.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

struct TeamView: View {
    let name: String
    let isHome: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.surfaceTertiary)
                    .frame(width: 56, height: 56)
                Text(String(name.prefix(2)).uppercased())
                    .font(.title3.weight(.bold))
                    .foregroundColor(.accentGreen)
            }
            Text(name)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 100)
        }
    }
}

struct SafariWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
