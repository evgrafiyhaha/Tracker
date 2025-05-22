import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewControllerLight() {
        let vc = TabBarController()

        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

    func testViewControllerDark() {
        let vc = TabBarController()

        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}
