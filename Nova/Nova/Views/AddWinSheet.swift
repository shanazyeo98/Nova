import SwiftUI
import SwiftData

struct AddWinSheet: View {
    @Environment(\.modelContext) private var modelContext

    var onWinAdded: (UUID) -> Void
    var onCancel: () -> Void

    @State private var title = ""
    @State private var note = ""
    @FocusState private var titleFocused: Bool
    @State private var selection: Size = .small

    private let fieldOpacity: CGFloat = 0.12

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel", action: onCancel)
                    .foregroundStyle(.white.opacity(0.6))

                Spacer()

                Text("New Win")
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                Button("Save") { save() }
                    .fontWeight(.semibold)
                    .foregroundStyle(title.trimmingCharacters(in: .whitespaces).isEmpty
                                     ? .white.opacity(0.3)
                                     : Color(hue: 0.13, saturation: 0.9, brightness: 0.95))
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)

            Divider()
                .background(Color.white.opacity(0.12))

            // Fields
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    label("What's your win?")
                    TextField("",
                              text: $title,
                              prompt: Text("e.g. Finished that tricky bug fix")
                                    .foregroundStyle(.white.opacity(0.35))
                    )
                    .focused($titleFocused)
                    .foregroundStyle(.white)
                    .tint(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(Color.white.opacity(fieldOpacity))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                VStack(alignment: .leading, spacing: 8) {
                    label("How big was your win?")
                    HStack(spacing: 0) {
                        ForEach(Size.allCases) { size in
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) { selection = size }
                            } label: {
                                Text(size.rawValue.capitalized)
                                    .font(.subheadline)
                                    .fontWeight(selection == size ? .semibold : .regular)
                                    .foregroundStyle(selection == size ? .white : .white.opacity(0.75))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 7)
                                    .background(
                                        RoundedRectangle(cornerRadius: 7)
                                            .fill(selection == size ? Color.white.opacity(0.2) : Color.clear)
                                            .padding(3)
                                    )
                            }
                        }
                    }
                    .background(Color.white.opacity(fieldOpacity))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                VStack(alignment: .leading, spacing: 8) {
                    label("Notes (optional)")
                    TextEditor(text: $note)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.white)
                        .tint(.white)
                        .frame(minHeight: 72)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.white.opacity(fieldOpacity))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(20)
        }
        .onAppear { titleFocused = true }
    }

    private func label(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .textCase(.uppercase)
            .foregroundStyle(.white.opacity(0.75))
    }

    private func save() {
        let win = Win(title: title.trimmingCharacters(in: .whitespaces), size: selection, note: note)
        modelContext.insert(win)
        onWinAdded(win.id)
    }
}

#Preview {
    ZStack {
        Color(red: 0.03, green: 0.03, blue: 0.15).ignoresSafeArea()
        AddWinSheet(onWinAdded: { _ in }, onCancel: {})
            .background(Color(red: 0.06, green: 0.04, blue: 0.18))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.18), lineWidth: 1))
            .padding(24)
    }
    .modelContainer(for: Win.self, inMemory: true)
}
