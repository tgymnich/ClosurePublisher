import XCTest
import Combine
import Foundation
@testable import ClosurePublisher

@available(OSX 10.15, iOS 13, *)
final class ClosurePublisherTests: XCTestCase {
    func testClosurePublisher() {
        var success = false
        let publisher = Publishers.Closure(closure: { return 1 })
        publisher.sink {
            if $0 == 1 {
                success = true
            }
        }
         XCTAssert(success)
    }
    
    func testThrowingClosurePublisher1() {
        var success = false
        let publisher = Publishers.ThrowingClosure(closure: { return 1 })
        publisher.sink {
            if $0 == 1 {
                success = true
            }
        }
        let pub = Just(1)
    }
    
    func testThrowingClosurePublisher2() {
        var success = false
        let publisher = Publishers.ThrowingClosure { () -> Int in
            let decoder = JSONDecoder()
            let x = try decoder.decode(Int.self, from: Data())
            return x
        }
        publisher.mapError { error -> Error in
            if error != nil {
                success = true
            }
            return error
        }.sink { _ in
            XCTFail()
        }
    }

    static var allTests = [
        ("testClosurePublisher", testClosurePublisher),
        ("testThorwingClosurePublisher1", testThrowingClosurePublisher1),
        ("testThorwingClosurePublisher2", testThrowingClosurePublisher2),
    ]
}
