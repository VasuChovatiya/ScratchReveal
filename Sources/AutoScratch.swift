import UIKit

/// Demo-only: replays a scratch gesture on the library's image view so the
/// screen can be recorded without a finger. Enabled by the `-autoplay` launch argument.
final class FakeTouch: UITouch {
    var point: CGPoint = .zero
    override func location(in view: UIView?) -> CGPoint { point }
}

enum AutoScratch {
    static var isEnabled: Bool { ProcessInfo.processInfo.arguments.contains("-autoplay") }

    /// Zig-zags across the view top to bottom, then lifts the finger.
    static func play(on view: UIView, rows: Int = 9, delay: TimeInterval = 1.5) {
        let target: UIResponder = view
        let touch = FakeTouch()
        let points = path(in: view.bounds.size, rows: rows)
        guard let first = points.first else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            touch.point = first
            target.touchesBegan([touch], with: nil)
            for (index, point) in points.enumerated().dropFirst() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.012) {
                    touch.point = point
                    target.touchesMoved([touch], with: nil)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(points.count) * 0.012 + 0.1) {
                target.touchesEnded([touch], with: nil)
            }
        }
    }

    /// Touch points for a zig-zag that covers the middle 88% × 84% of `size`,
    /// left to right on even rows and back on odd ones. One row runs across the middle.
    static func path(in size: CGSize, rows: Int) -> [CGPoint] {
        guard rows > 0 else { return [] }
        let xs = stride(from: 0.06, through: 0.94, by: 0.04).map { size.width * CGFloat($0) }
        return (0..<rows).flatMap { r -> [CGPoint] in
            let y = rows == 1 ? size.height / 2 : size.height * (0.08 + 0.84 * CGFloat(r) / CGFloat(rows - 1))
            return (r % 2 == 0 ? xs : xs.reversed()).map { CGPoint(x: $0, y: y) }
        }
    }
}
