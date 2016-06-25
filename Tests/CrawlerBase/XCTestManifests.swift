//
//  XCTestManifests.swift
//  CrawlerKit
//
//  Created by Yusuke Ito on 6/4/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import XCTest

#if !os(OSX)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase( HTTPTests.allTests ),
            testCase( RSSTests.allTests ),
        ]
    }
#endif
