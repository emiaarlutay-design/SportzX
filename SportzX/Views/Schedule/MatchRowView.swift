import SwiftUI

struct MatchRowView: View {
    let match: Match

    var body: some View {
        HStack(spacing: 12) {
            statusIndicator

            VStack(alignment: .leading, spacing: 2) {
                Text(match.leagueName)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.accentGreen)

                HStack(spacing: 8) {
                    Text(match.homeTeam)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                    if match.status == .finished, let hs = match.homeScore {
                        Text("\(hs)")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.accentGreen)
                    }
                }

                HStack(spacing: 8) {
                    Text(match.awayTeam)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                    if match.status == .finished, let as_ = match.awayScore {
                        Text("\(as_)")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.accentGreen)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                if match.isLive {
                    HStack(spacing: 4) {
                        Circle().fill(Color.liveRed).frame(width: 6, height: 6)
                        Text("LIVE").font(.caption.weight(.bold)).foregroundColor(.liveRed)
                    }
                } else if match.status == .finished {
                    Text("FT").font(.caption.weight(.bold)).foregroundColor(.textTertiary)
                } else {
                    Text(match.date, style: .time)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.textSecondary)
                }

                if !match.isLive && match.status != .finished {
                    Text(match.countdown)
                        .font(.caption2)
                        .foregroundColor(.textTertiary)
                }

                if match.isAvailable && !match.streams.isEmpty {
                    Image(systemName: "play.tv.fill")
                        .font(.caption)
                        .foregroundColor(.accentGreen)
                }

                if match.streams.isEmpty && match.isAvailable {
                    Text("No streams")
                        .font(.caption2)
                        .foregroundColor(.liveRed)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private var statusIndicator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(match.isLive ? Color.liveRed : (match.status == .finished ? Color.surfaceTertiary : Color.accentGreen))
                .frame(width: 3, height: 40)
        }
    }
}
