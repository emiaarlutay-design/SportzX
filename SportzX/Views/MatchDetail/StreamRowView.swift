import SwiftUI

struct StreamRowView: View {
    let stream: StreamSource
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.accentGreen : Color.surfaceTertiary)
                    .frame(width: 44, height: 44)
                Image(systemName: isSelected ? "checkmark" : "play.rectangle.fill")
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .textSecondary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(stream.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Label(stream.language, systemImage: "globe")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                    Label(stream.quality, systemImage: "4k.tv")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                }
            }

            Spacer()

            Image(systemName: stream.sourceType == .m3u8 ? "play.tv.fill" : "safari.fill")
                .font(.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color.accentGreen.opacity(0.1) : Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color.accentGreen : Color.clear, lineWidth: 1.5)
                )
        )
    }
}
