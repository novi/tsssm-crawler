//
//  HTTPTests.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import XCTest
@testable import CrawlerBase

class HTTPTests: XCTestCase {
    
    func testSimpleRequest() throws {
        let cli = HTTPClient()
        let string = try cli.get(url: NSURL(string: "http://httpbin.org/robots.txt")!)
        
        print(string)
        
        XCTAssert(string.hasPrefix("User-agent: *"))
        XCTAssertEqual(string, "User-agent: *\nDisallow: /deny\n")
    }
    
}
