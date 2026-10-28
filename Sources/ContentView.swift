import SwiftUI

struct Prize: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let subtitle: String
    let colors: [Color]
}

private let prizes: [Prize] = [
    Prize(emoji: "🎁", title: "Surprise Gift", subtitle: "You unlocked a bonus!", colors: [.orange, .pink]),
    Prize(emoji: "🏆", title: "Champion", subtitle: "Top of the leaderboard", colors: [.indigo, .blue]),
    Prize(emoji: "🌟", title: "Lucky Star", subtitle: "Daily streak +1", colors: [.teal, .green]),
]

struct ContentView: View {
    @State private var brush: Double = 36
    @State private var prizeIndex = 0
    @State private var progress = 0.0
    @State private var revealed = false
    @State private var cardID = UUID()

    var body: some View {
        VStack(spacing: 20) {
            Text("Scratch Reveal")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))

            ScratchView(brushSize: brush, progress: $progress, isRevealed: $revealed) {
                PrizeView(prize: prizes[prizeIndex])
            }
            .id(cardID)
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 14, y: 8)
            .padding(.horizontal)

            VStack(spacing: 6) {
                ProgressView(value: min(progress / 0.40, 1))
                    .tint(revealed ? .green : .accentColor)
                Text(revealed ? "Revealed!" : "Scratched \(Int(progress * 100))% — reveals at 40% when you pause")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .padding(.horizontal, 28)

            HStack {
                Text("Brush").font(.subheadline)
                Slider(value: $brush, in: 20...70)
            }
            .padding(.horizontal, 28)

            Button {
                prizeIndex = (prizeIndex + 1) % prizes.count
                progress = 0
                revealed = false
                cardID = UUID()
            } label: {
                Label("New Card", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)

            Spacer(minLength: 0)
        }
        .padding(.top, 24)
    }
}

struct PrizeView: View {
    let prize: Prize
    var body: some View {
        ZStack {
            LinearGradient(colors: prize.colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(spacing: 8) {
                Text(prize.emoji).font(.system(size: 72))
                Text(prize.title).font(.system(.title, design: .rounded, weight: .bold))
                Text(prize.subtitle).font(.subheadline).opacity(0.85)
            }
            .foregroundStyle(.white)
        }
    }
}

@main
struct ScratchRevealApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
