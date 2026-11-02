import XCTest
@testable import App

final class ScratchProgressTests: XCTestCase {
    // MARK: clearedFraction

    func testEmptyBitmapCountsAsNothingScratched() {
        XCTAssertEqual(ScratchProgress.clearedFraction(ofAlpha: [UInt8]()), 0)
    }

    func testOpaqueCoverIsNotScratched() {
        XCTAssertEqual(ScratchProgress.clearedFraction(ofAlpha: [UInt8](repeating: 255, count: 64)), 0)
    }

    func testFullyClearedCoverIsFullyScratched() {
        XCTAssertEqual(ScratchProgress.clearedFraction(ofAlpha: [UInt8](repeating: 0, count: 64)), 1)
    }

    func testFractionIsShareOfClearedPixels() {
        let alpha: [UInt8] = [0, 255, 255, 255, 0, 255, 255, 255]
        XCTAssertEqual(ScratchProgress.clearedFraction(ofAlpha: alpha), 0.25)
    }

    func testPartlyTransparentPixelsAreNotCleared() {
        // Anti-aliased brush edges leave faint alpha behind; only fully clear pixels count.
        let alpha: [UInt8] = [0, 1, 128, 254]
        XCTAssertEqual(ScratchProgress.clearedFraction(ofAlpha: alpha), 0.25)
    }

    // MARK: revealsOnPause

    func testPauseBelowThresholdDoesNotReveal() {
        XCTAssertFalse(ScratchProgress.revealsOnPause(scratched: 39.9, threshold: 40))
    }

    func testPauseAtThresholdReveals() {
        XCTAssertTrue(ScratchProgress.revealsOnPause(scratched: 40, threshold: 40))
    }

    func testPauseAboveThresholdReveals() {
        XCTAssertTrue(ScratchProgress.revealsOnPause(scratched: 75, threshold: 40))
    }

    func testZeroThresholdTurnsAutoRevealOff() {
        XCTAssertFalse(ScratchProgress.revealsOnPause(scratched: 0, threshold: 0))
        XCTAssertFalse(ScratchProgress.revealsOnPause(scratched: 100, threshold: 0))
    }

    // MARK: towardReveal

    func testBarIsEmptyBeforeScratching() {
        XCTAssertEqual(ScratchProgress.towardReveal(scratched: 0, threshold: 40), 0)
    }

    func testBarMeasuresProgressAgainstThreshold() {
        XCTAssertEqual(ScratchProgress.towardReveal(scratched: 0.2, threshold: 40), 0.5, accuracy: 1e-9)
        XCTAssertEqual(ScratchProgress.towardReveal(scratched: 0.1, threshold: 20), 0.5, accuracy: 1e-9)
    }

    func testBarIsFullAtThreshold() {
        XCTAssertEqual(ScratchProgress.towardReveal(scratched: 0.4, threshold: 40), 1, accuracy: 1e-9)
    }

    func testBarStaysFullPastThreshold() {
        XCTAssertEqual(ScratchProgress.towardReveal(scratched: 0.9, threshold: 40), 1)
    }

    func testBarNeverGoesNegative() {
        XCTAssertEqual(ScratchProgress.towardReveal(scratched: -0.1, threshold: 40), 0)
    }

    func testBarFollowsScratchedFractionWithoutThreshold() {
        XCTAssertEqual(ScratchProgress.towardReveal(scratched: 0.3, threshold: 0), 0.3, accuracy: 1e-9)
        XCTAssertEqual(ScratchProgress.towardReveal(scratched: 1.2, threshold: 0), 1)
    }
}
