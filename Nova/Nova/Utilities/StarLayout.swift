import CoreGraphics
import Foundation

struct SeededRNG {
    private var state: UInt64

    init(seed: Int) {
        state = UInt64(bitPattern: Int64(seed &* 6364136223846793005 &+ 1442695040888963407))
        if state == 0 { state = 1 }
    }

    mutating func next() -> Double {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return Double(state) / Double(UInt64.max)
    }

    mutating func next(in range: ClosedRange<Double>) -> Double {
        range.lowerBound + next() * (range.upperBound - range.lowerBound)
    }
}

struct StarPosition {
    let winID: UUID
    let point: CGPoint
    let rotation: Double
    let scale: Double
    let zIndex: Int
}

enum StarLayout {
    static let starDiameter: CGFloat = 30
    static let margin: CGFloat = 48

    static func positions(for wins: [Win], in bounds: CGRect) -> [UUID: StarPosition] {
        guard bounds.width > 0, bounds.height > 0 else { return [:] }

        var result: [UUID: StarPosition] = [:]

        for win in wins {
            var rng = SeededRNG(seed: win.id.hashValue)

            let x = bounds.minX + margin + rng.next() * (bounds.width - margin * 2)
            let y = bounds.minY + margin + rng.next() * (bounds.height - margin * 2)
            let scale: Double = {
                switch win.size {
                case .small:
                    return rng.next(in: 0.25...0.45)
                case .medium:
                    return rng.next(in: 0.45...0.75)
                case .big:
                    return rng.next(in: 0.75...1.0)
                }
            }()
            let rotation = rng.next(in: -45...45)

            result[win.id] = StarPosition(
                winID: win.id,
                point: CGPoint(x: x, y: y),
                rotation: rotation,
                scale: scale,
                zIndex: Int(scale * 100)
            )
        }

        return result
    }
}
