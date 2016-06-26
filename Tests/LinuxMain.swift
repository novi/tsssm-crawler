import XCTest
import CrawlerBaseTestSuite


var tests = [XCTestCaseEntry]()

tests += CrawlerBaseTestSuite.allTests()
//tests += .allTests()

XCTMain(tests)