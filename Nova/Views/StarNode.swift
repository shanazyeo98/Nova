import SwiftUI

struct StarNode: View {
    let win: Win
    let position: StarPosition
    let isDropping: Bool
    var onDropComplete: () -> Void = {}

    @State private var appeared = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var twinkleOpacity: CGFloat = 1.0
    @State private var showDetail = false

    private var starColor: Color {
        var rng = SeededRNG(seed: win.id.hashValue ^ 0xCAFE)
        let t = rng.next()
        if t < 0.5 {
            return Color(hue: 0.14, saturation: rng.next(in: 0.1...0.35), brightness: 1.0)
        } else if t < 0.78 {
            return Color(hue: 0.58, saturation: rng.next(in: 0.05...0.2), brightness: 1.0)
        } else {
            return .white
        }
    }

    private var twinkleDuration: Double {
        var rng = SeededRNG(seed: win.id.hashValue ^ 0xFACE)
        return rng.next(in: 1.8...4.5)
    }

    private var diameter: CGFloat { StarLayout.starDiameter * position.scale }

    var body: some View {
        StarShape()
            .fill(starColor)
            .overlay(
                StarShape()
                    .fill(LinearGradient(
                        colors: [.white.opacity(0.85), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .shadow(color: starColor.opacity(0.9), radius: diameter * 0.5)
            .frame(width: diameter, height: diameter)
            .rotationEffect(.degrees(position.rotation))
            .scaleEffect((isDropping && !appeared ? 3.5 : 1.0) * pulseScale)
            .opacity(appeared ? twinkleOpacity : 0.0)
            .position(position.point)
            .zIndex(Double(position.zIndex))
            .onAppear {
                if isDropping {
                    withAnimation(.easeOut(duration: 0.7)) { appeared = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                        withAnimation(.spring(response: 0.22)) { pulseScale = 1.5 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.25)) { pulseScale = 1.0 }
                            onDropComplete()
                            startTwinkle()
                        }
                    }
                } else {
                    let delay = Double(win.id.hashValue & 0xFF) / 255.0 * 0.6
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        withAnimation(.easeIn(duration: 0.5)) { appeared = true }
                        startTwinkle()
                    }
                }
            }
            .onTapGesture { withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                showDetail = true
            } }
        
        if showDetail {
            WinDetailView(win: win, onClose: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    showDetail = false
                }
            })
//                .frame(maxWidth: 360, maxHeight: 460)
                .background(Color(red: 0.06, green: 0.04, blue: 0.18))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 10)
                .padding(.horizontal, 24)
                .transition(.scale(scale: 0.92).combined(with: .opacity))
        }
    }

    private func startTwinkle() {
        let delay = Double(win.id.hashValue & 0x7F) / 127.0 * 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: twinkleDuration).repeatForever(autoreverses: true)) {
                twinkleOpacity = 0.6
            }
        }
    }
}
