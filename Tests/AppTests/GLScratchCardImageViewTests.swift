import UIKit
import XCTest
@testable import App

/// Scratches a real `GLScratchCardImageView` with fake touches and checks what it reports.
final class GLScratchCardImageViewTests: XCTestCase {
    /// The view measures a copy of the cover shrunk to point size, which blurs the
    /// edge rows of a stroke so they read as not cleared: a 100-point band reads up to 2% low.
    private let edgeTolerance: Float = 2.5

    private var view: GLScratchCardImageView!
    private var spy: DelegateSpy!

    override func setUp() {
        super.setUp()
        let size = CGSize(width: 100, height: 100)
        let cover = UIGraphicsImageRenderer(size: size).image { context in
            UIColor.gray.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        view = GLScratchCardImageView(frame: CGRect(origin: .zero, size: size))
        view.image = cover
        view.topLayerImageReference = cover
        // Square ends keep the scratched area an exact rectangle.
        view.lineType = .butt
        spy = DelegateSpy()
        view.addDelegate(delegate: spy)
    }

    override func tearDown() {
        view = nil
        spy = nil
        super.tearDown()
    }

    func testStrokeReportsScratchedAreaAsPercentage() throws {
        view.lineWidth = 20
        scratch(from: CGPoint(x: 0, y: 50), to: [CGPoint(x: 100, y: 50)])

        // A 100 × 20 band across a 100 × 100 card.
        let reported = try XCTUnwrap(spy.percentages.last)
        XCTAssertEqual(reported, 20, accuracy: edgeTolerance)
    }

    func testPercentageGrowsAsTheStrokeContinues() {
        view.lineWidth = 20
        scratch(from: CGPoint(x: 0, y: 50), to: [CGPoint(x: 50, y: 50), CGPoint(x: 100, y: 50)])

        XCTAssertEqual(spy.percentages.count, 2)
        XCTAssertEqual(spy.percentages[0], 10, accuracy: edgeTolerance)
        XCTAssertEqual(spy.percentages[1], 20, accuracy: edgeTolerance)
        XCTAssertGreaterThan(spy.percentages[1], spy.percentages[0])
    }

    func testScratchStartsOnceForManyMoves() {
        scratch(from: CGPoint(x: 10, y: 10), to: [CGPoint(x: 20, y: 10), CGPoint(x: 30, y: 10), CGPoint(x: 40, y: 10)])

        XCTAssertEqual(spy.started, 1)
    }

    func testPartialScratchDoesNotEndTheScratch() {
        view.lineWidth = 20
        scratch(from: CGPoint(x: 0, y: 50), to: [CGPoint(x: 100, y: 50)])

        XCTAssertEqual(spy.ended, 0)
    }

    func testScratchingEverythingEndsTheScratchOnce() {
        view.lineWidth = 400
        scratch(from: CGPoint(x: 0, y: 50), to: [CGPoint(x: 100, y: 50), CGPoint(x: 0, y: 50)])

        XCTAssertEqual(spy.percentages.first, 100)
        XCTAssertEqual(spy.ended, 1)
    }

    private func scratch(from start: CGPoint, to points: [CGPoint]) {
        let touch = FakeTouch()
        touch.point = start
        view.touchesBegan([touch], with: nil)
        for point in points {
            touch.point = point
            view.touchesMoved([touch], with: nil)
        }
    }
}

private final class DelegateSpy: GLScratchCarImageViewDelegate {
    var percentages: [Float] = []
    var started = 0
    var ended = 0

    func scratchpercentageDidChange(value: Float) { percentages.append(value) }
    func didScratchStarted() { started += 1 }
    func didScratchEnded() { ended += 1 }
}
