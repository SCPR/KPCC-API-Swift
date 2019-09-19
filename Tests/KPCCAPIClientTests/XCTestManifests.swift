import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(KPCCAPIClient_SwiftTests.allTests),
    ]
}
#endif
