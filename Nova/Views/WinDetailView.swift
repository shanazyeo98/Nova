import SwiftUI

struct WinDetailView: View {
    let win: Win
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Button("Close", action: onClose)
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
            }
            
            StarShape()
                .fill(Color(hue: 0.13, saturation: 0.9, brightness: 0.95))
                .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 2)
                .frame(width: 56, height: 56)

            Text(win.title)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Text(win.date, style: .date)
                .font(.subheadline)
                .foregroundStyle(.white)

            if !win.note.isEmpty {
                ScrollView {
                    Text(win.note)
                        .font(.body)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: 120)
                .padding(.horizontal)
            }
        }
        .padding()
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: 320, maxHeight: 440)
    }
}
