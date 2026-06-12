import Foundation

struct StreamSource: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let url: String
    let quality: String
    let language: String
    let sourceType: StreamType
    let isBackup: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: StreamSource, rhs: StreamSource) -> Bool {
        lhs.id == rhs.id
    }
}

enum StreamType: String, Codable {
    case m3u8
    case m3u
    case web
    case embed
}
