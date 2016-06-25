import XCTest
import CrawlerBaseSuite


var tests = [XCTestCaseEntry]()

tests += CrawlerBaseSuite.allTests()
//tests += .allTests()

XCTMain(tests)