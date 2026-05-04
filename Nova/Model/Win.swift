import Foundation
import SwiftData

enum Size: String, Codable, CaseIterable, Identifiable {
    case small, medium, big
    var id: Self { self }
}

@Model
final class Win {
    var id: UUID
    var title: String
    var note: String
    var date: Date
    var size: Size

    init(title: String, size: Size, note: String = "", date: Date = .now) {
        self.id = UUID()
        self.title = title
        self.size = size
        self.note = note
        self.date = date
    }
}
