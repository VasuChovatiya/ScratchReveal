import XCTest
@testable import App

final class AutoScratchTests: XCTestCase {
    private let size = CGSize(width: 300, height: 200)

    func testNoRowsGivesNoPoints() {
        XCTAssertTrue(AutoScratch.path(in: size, rows: 0).isEmpty)
    }

    func testOneRowRunsAcrossTheMiddle() {
        let points = AutoScratch.path(in: size, rows: 1)

        XCTAssertFalse(points.isEmpty)
        XCTAssertTrue(points.allSatisfy { $0.y == 100 })
    }

    func testEveryRowHasTheSameNumberOfPoints() {
        let points = AutoScratch.path(in: size, rows: 9)
        let rows = Dictionary(grouping: points, by: \.y)

        XCTAssertEqual(rows.count, 9)
        XCTAssertEqual(Set(rows.values.map(\.count)).count, 1)
    }

    func testRowsRunTopToBottomInsideTheMargins() throws {
        let points = AutoScratch.path(in: size, rows: 9)
        let yValues = points.map(\.y)

        XCTAssertEqual(yValues, yValues.sorted())
        XCTAssertEqual(try XCTUnwrap(yValues.first), 200 * 0.08, accuracy: 1e-9)
        XCTAssertEqual(try XCTUnwrap(yValues.last), 200 * 0.92, accuracy: 1e-9)
    }

    func testPointsStayInsideTheHorizontalMargins() {
        let points = AutoScratch.path(in: size, rows: 3)

        XCTAssertTrue(points.allSatisfy { $0.x >= 300 * 0.06 - 1e-9 && $0.x <= 300 * 0.94 + 1e-9 })
    }

    func testRowsZigZag() throws {
        let points = AutoScratch.path(in: size, rows: 2)
        let first = points.filter { $0.y == points[0].y }.map(\.x)
        let second = points.filter { $0.y != points[0].y }.map(\.x)

        XCTAssertEqual(first, first.sorted())
        XCTAssertEqual(second, first.reversed())
        XCTAssertEqual(try XCTUnwrap(second.first), try XCTUnwrap(first.last))
    }
}
