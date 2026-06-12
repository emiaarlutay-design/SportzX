import Foundation

enum Constants {
    static let appName = "SportzX"
    static let appVersion = "1.0.0"

    static let refreshInterval: TimeInterval = 3600
    static let streamUnlockMinutesBeforeMatch: Double = 30
    static let matchDurationHours: Double = 2.5

    static let m3uSources: [String] = [
        "https://movitv.pro/",
        "http://drewlive2423.duckdns.org:8081/DrewLive/MergedCleanPlaylist.m3u8"
    ]

    static let webSources: [(name: String, url: String)] = [
        ("Streamed PK", "https://streamed.pk"),
        ("PPV.to", "https://ppv.to")
    ]

    static let feedbackEmail = "support@sportzx.app"
}
