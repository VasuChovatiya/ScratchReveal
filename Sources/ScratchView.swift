import SwiftUI

/// SwiftUI wrapper around GLScratchCard's `GLScratchCardImageView`.
/// `content` sits underneath; the library's image view (foil) is erased by touch.
/// The library reveals the content on its own once the scratched amount passes
/// `benchMark` and the user stops scratching for a few seconds.
struct ScratchView<Content: View>: View {
    var brushSize: CGFloat = 36
    var benchMark: Float = 40
    @Binding var progress: Double
    @Binding var isRevealed: Bool
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            content()
            GLScratchRepresentable(brushSize: brushSize, benchMark: benchMark,
                                   progress: $progress, isRevealed: $isRevealed)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .allowsHitTesting(!isRevealed)
        }
    }
}

private struct GLScratchRepresentable: UIViewRepresentable {
    let brushSize: CGFloat
    let benchMark: Float
    @Binding var progress: Double
    @Binding var isRevealed: Bool

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> GLScratchCardImageView {
        let view = GLScratchCardImageView()
        let foil = UIImage(named: "scratch_image_new", in: Bundle.module, compatibleWith: nil)
        view.image = foil
        view.topLayerImageReference = foil
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.addDelegate(delegate: context.coordinator)
        if AutoScratch.isEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { AutoScratch.play(on: view) }
        }
        return view
    }

    func updateUIView(_ view: GLScratchCardImageView, context: Context) {
        context.coordinator.parent = self
        view.lineWidth = brushSize
        view.benchMarkScratchPercentage = benchMark
    }

    final class Coordinator: GLScratchCarImageViewDelegate {
        var parent: GLScratchRepresentable
        init(_ parent: GLScratchRepresentable) { self.parent = parent }

        func scratchpercentageDidChange(value: Float) {
            DispatchQueue.main.async { self.parent.progress = Double(value) / 100 }
        }
        func didScratchStarted() {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
        func didScratchEnded() {
            DispatchQueue.main.async { self.parent.isRevealed = true }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}
