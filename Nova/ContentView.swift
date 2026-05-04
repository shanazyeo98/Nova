import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Win.date, order: .forward) private var wins: [Win]
    @State private var showAddSheet = false
    @State private var newlyAddedID: UUID?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.03, blue: 0.15),
                    Color(red: 0.07, green: 0.04, blue: 0.22),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            NightSkyView(
                wins: wins,
                newlyAddedID: newlyAddedID,
                onDropComplete: { newlyAddedID = nil }
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Nova")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.top, 16)
                    .padding(.bottom, 6)

                Text(wins.isEmpty ? "Add your first star" : "\(wins.count) win\(wins.count == 1 ? "" : "s") in your sky")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))

                Spacer()
            }
            .allowsHitTesting(false)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            showAddSheet = true
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(Color(hue: 0.13, saturation: 0.9, brightness: 0.95))
                                    .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 32)
                }
            }

            if showAddSheet {
                // Scrim
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                            showAddSheet = false
                        }
                    }

                // Popup
                AddWinSheet(onWinAdded: { id in
                    newlyAddedID = id
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        showAddSheet = false
                    }
                }, onCancel: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        showAddSheet = false
                    }
                })
                .frame(maxWidth: 360, maxHeight: 460)
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
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Win.self, inMemory: true)
}
