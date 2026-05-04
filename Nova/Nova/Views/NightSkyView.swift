import SwiftUI

struct NightSkyView: View {
    let wins: [Win]
    var newlyAddedID: UUID?
    var onDropComplete: () -> Void = {}

    var body: some View {
        GeometryReader { geo in
            let rect = CGRect(origin: .zero, size: geo.size)
            let positions = StarLayout.positions(for: wins, in: rect)

            ZStack {
                ForEach(wins, id: \.id) { win in
                    if let pos = positions[win.id] {
                        StarNode(
                            win: win,
                            position: pos,
                            isDropping: win.id == newlyAddedID,
                            onDropComplete: onDropComplete
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    let mockWins = (0..<20).map { i in Win(title: "Win \(i + 1)", size: .medium, note: "A small win") }
    NightSkyView(wins: mockWins)
        .ignoresSafeArea()
        .background(
            LinearGradient(
                colors: [Color(red: 0.03, green: 0.03, blue: 0.15), Color(red: 0.07, green: 0.04, blue: 0.22)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
}
