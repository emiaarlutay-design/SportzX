import SwiftUI

struct StreamPickerBar: View {
    let streams: [(String, [StreamSource])]
    @Binding var selectedStream: StreamSource?
    @Binding var selectedLanguage: String
    @Binding var selectedQuality: String
    let allLanguages: [String]
    let allQualities: [String]

    @State private var showLanguagePicker = false
    @State private var showQualityPicker = false

    var body: some View {
        VStack(spacing: 12) {
            if streams.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(streams, id: \.0) { group, groupStreams in
                            Button(action: {
                                if let first = groupStreams.first {
                                    selectedStream = first
                                }
                            }) {
                                Text(group)
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        groupStreams.contains(where: { $0.id == selectedStream?.id }) ?
                                        Color.accentGreen : Color.surfaceTertiary
                                    )
                                    .foregroundColor(
                                        groupStreams.contains(where: { $0.id == selectedStream?.id }) ?
                                        .white : .textSecondary
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }

            HStack(spacing: 8) {
                filterButton(
                    label: selectedLanguage == "All" ? "Language" : selectedLanguage,
                    icon: "globe",
                    action: { showLanguagePicker.toggle() }
                )
                filterButton(
                    label: selectedQuality == "All" ? "Quality" : selectedQuality,
                    icon: "4k.tv",
                    action: { showQualityPicker.toggle() }
                )
                Spacer()
                Text("\(streams.flatMap(\.1).count) streams")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
            }
            .padding(.horizontal, 16)
        }
        .confirmationDialog("Filter by Language", isPresented: $showLanguagePicker) {
            ForEach(allLanguages, id: \.self) { lang in
                Button(lang) { selectedLanguage = lang }
            }
        }
        .confirmationDialog("Filter by Quality", isPresented: $showQualityPicker) {
            ForEach(allQualities, id: \.self) { qual in
                Button(qual) { selectedQuality = qual }
            }
        }
    }

    private func filterButton(label: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(label)
                    .font(.caption.weight(.medium))
            }
            .foregroundColor(.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.surfaceTertiary)
            .clipShape(Capsule())
        }
    }
}
