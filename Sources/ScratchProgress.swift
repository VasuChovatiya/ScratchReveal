/// The maths behind the scratch card's progress and reveal, kept free of UIKit
/// so it can be unit tested.
enum ScratchProgress {
    /// Share of the cover that has been scratched away, from 0 to 1: the fraction
    /// of pixels whose alpha is fully cleared. An empty bitmap counts as 0.
    static func clearedFraction<Pixels: Collection>(ofAlpha alpha: Pixels) -> Float where Pixels.Element == UInt8 {
        guard !alpha.isEmpty else { return 0 }
        let cleared = alpha.lazy.filter { $0 == 0 }.count
        return Float(cleared) / Float(alpha.count)
    }

    /// Whether the card reveals itself when the user pauses after scratching
    /// `percent` (0 to 100) of it. A threshold of 0 turns the auto-reveal off.
    static func revealsOnPause(scratched percent: Float, threshold: Float) -> Bool {
        threshold > 0 && percent >= threshold
    }

    /// How full the progress bar is, from 0 to 1: the scratched fraction measured
    /// against the reveal threshold (a percentage). With no threshold, it is the
    /// scratched fraction itself.
    static func towardReveal(scratched fraction: Double, threshold: Float) -> Double {
        let target = threshold > 0 ? Double(threshold) / 100 : 1
        return min(max(fraction / target, 0), 1)
    }
}
