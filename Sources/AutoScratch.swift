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
        var points: [CGPoint] = []
        let width = view.bounds.width, height = view.bounds.height
        for r in 0..<rows {
            let y = height * (0.08 + 0.84 * CGFloat(r) / CGFloat(rows - 1))
            let xs = stride(from: 0.06, through: 0.94, by: 0.04).map { width * CGFloat($0) }
            points += (r % 2 == 0 ? xs : xs.reversed()).map { CGPoint(x: $0, y: y) }
        }
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
}
