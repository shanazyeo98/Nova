import SwiftUI

struct WinDetailView: View {
    let win: Win

    var body: some View {
        VStack(spacing: 20) {
            StarShape()
                .fill(Color(hue: 0.13, saturation: 0.9, brightness: 0.95))
                .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 2)
                .frame(width: 56, height: 56)

            Text(win.title)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)

            Text(win.date, style: .date)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if !win.note.isEmpty {
                Text(win.note)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top, 32)
        .padding()
    }
}
