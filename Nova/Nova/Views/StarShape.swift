import SwiftUI

struct StarShape: Shape {
    var points: Int = 5

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.382
        let angleStep = Double.pi * 2 / Double(points)
        let startAngle = -Double.pi / 2

        var path = Path()

        for i in 0..<points * 2 {
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = startAngle + Double(i) * angleStep / 2
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.closeSubpath()
        return path
    }
}

#Preview {
    HStack(spacing: 16) {
        StarShape()
            .fill(Color(hue: 0.13, saturation: 0.9, brightness: 0.95))
            .frame(width: 24, height: 24)
        StarShape()
            .fill(Color(hue: 0.13, saturation: 0.9, brightness: 0.95))
            .frame(width: 48, height: 48)
        StarShape()
            .fill(Color(hue: 0.13, saturation: 0.9, brightness: 0.95))
            .frame(width: 72, height: 72)
    }
    .padding()
}
