import SwiftUI

private struct CloudLayer: View {
    private struct Cloud {
        let x: CGFloat   // 0–1 fraction of bounds
        let y: CGFloat
        let w: CGFloat   // width fraction
        let h: CGFloat   // absolute height
        let blur: CGFloat
        let opacity: Double
    }

    private let clouds: [Cloud] = [
        .init(x: 0.50, y: 0.08, w: 1.00, h: 80, blur: 36, opacity: 0.55),
        .init(x: 0.22, y: 0.42, w: 0.62, h: 60, blur: 28, opacity: 0.45),
        .init(x: 0.78, y: 0.65, w: 0.68, h: 65, blur: 30, opacity: 0.48),
        .init(x: 0.50, y: 0.92, w: 1.10, h: 78, blur: 38, opacity: 0.55),
        .init(x: 0.65, y: 0.28, w: 0.50, h: 50, blur: 24, opacity: 0.38),
    ]

    // Slightly lighter than the background indigo so clouds are barely visible
    private let cloudColor = Color(red: 0.13, green: 0.09, blue: 0.30)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(clouds.indices, id: \.self) { i in
                    let c = clouds[i]
                    cloudBlob(width: c.w * geo.size.width, height: c.h)
                        .blur(radius: c.blur)
                        .opacity(c.opacity)
                        .position(x: c.x * geo.size.width, y: c.y * geo.size.height)
                }
            }
        }
        .allowsHitTesting(false)
    }

    // Three overlapping ellipses give a natural uneven cloud silhouette
    private func cloudBlob(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(cloudColor)
                .frame(width: width, height: height)
            Ellipse()
                .fill(cloudColor)
                .frame(width: width * 0.45, height: height * 1.25)
                .offset(x: -width * 0.22, y: -height * 0.08)
            Ellipse()
                .fill(cloudColor)
                .frame(width: width * 0.38, height: height * 1.15)
                .offset(x: width * 0.25, y: -height * 0.10)
        }
    }
}

struct NightSkyView: View {
    let wins: [Win]
    var newlyAddedID: UUID?
    var onDropComplete: () -> Void = {}

    var body: some View {
        GeometryReader { geo in
            let rect = CGRect(origin: .zero, size: geo.size)
            let positions = StarLayout.positions(for: wins, in: rect)

            ZStack {
                CloudLayer()

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
