import SwiftUI
import AVKit

struct StreamPlayerView: View {
    let stream: StreamSource
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let url = actualURL {
                if stream.sourceType == .m3u8 || stream.sourceType == .m3u {
                    VideoPlayer(player: player)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            let playerItem = AVPlayerItem(url: url)
                            player = AVPlayer(playerItem: playerItem)
                            player?.play()
                            isPlaying = true
                        }
                        .onDisappear {
                            player?.pause()
                            player = nil
                        }
                } else {
                    SafariWebView(url: url)
                        .edgesIgnoringSafeArea(.all)
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.liveRed)
                    Text("Invalid stream URL")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.white)
                    Text("This stream source appears to be unavailable")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
            }

            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text(stream.title)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                    Button(action: {
                        if isPlaying {
                            player?.pause()
                        } else {
                            player?.play()
                        }
                        isPlaying.toggle()
                    }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                .padding()
                Spacer()
            }
        }
        .statusBar(hidden: true)
    }

    private var actualURL: URL? {
        URL(string: stream.url)
    }
}
