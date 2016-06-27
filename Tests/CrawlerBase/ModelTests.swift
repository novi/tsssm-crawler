//
//  ModelTests.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import XCTest
@testable import CrawlerBase
import MySQL

extension ModelTests {
    static var allTests : [(String, (ModelTests) -> () throws -> Void)] {
        return [
            ("testRSSStatusOutdated", testRSSStatusOutdated),
            ("testRSSStatusUptodate", testRSSStatusUptodate),
            ("testRSSStatusUptodateAndOutdated", testRSSStatusUptodateAndOutdated)
        ]
    }
}

struct LocalDB: ConnectionOption {
    let host: String = "127.0.0.1"
    let port: Int = 3306
    let user: String = "root"
    let password: String = ""
    let database: String = "test"
}

class ModelTests: XCTestCase {

    let pool = ConnectionPool(options: LocalDB())
    
    override func setUp() {
        super.setUp()
        
        AllScheme().forEach { try! $0.dropAndCreateTable(pool: pool) }
    }
    
    func insertOneRSS() throws {
        let now = NSDate()
        let rss = Row.RSS(rssID: .noID, title: "my rss", url: NSURL(string: "https://apple.com")!, createdAt: now)
        
        try pool.execute { conn in
            let rssInsert: QueryStatus = try conn.query("INSERT INTO rss SET ? ", [rss])
            XCTAssertEqual(rssInsert.insertedId, 1) // rss_id of the RSS
            XCTAssertEqual(rssInsert.affectedRows, 1)
        }
    }
    
    func makeSureCollectStatusIsAllClear() throws {
        // TODO: implement me
    }

    func testRSSStatusOutdated() throws {
        
        // insert a RSS
        try insertOneRSS()
        
        // collect_status is all clear
        try makeSureCollectStatusIsAllClear()
        
        let rssIDs = try Row.CollectStatus.fetchOutdated(pool: pool)
        
        // the RSS that have inserted is marked as outdated (not yet crawled)
        XCTAssertEqual(rssIDs.count, 1)
        XCTAssertEqual(rssIDs[0], RSSID(1))
        
    }
    
    func testRSSStatusUptodate() throws {
        
        // insert a RSS
        try insertOneRSS()
        
        // collect_status is all clear
        try makeSureCollectStatusIsAllClear()
        
        // mark the RSS as collected
        try pool.execute { conn in
            try Row.CollectStatus.updateLatestStatus(rssID: RSSID(1), status: .success, conn: conn)
        }
        
        // the RSS up to date
        let rssIDs = try Row.CollectStatus.fetchOutdated(pool: pool)
        XCTAssertEqual(rssIDs.count, 0)
    }
    
    func testRSSStatusUptodateAndOutdated() throws {
        
        // insert a RSS
        try insertOneRSS()
        
        // collect_status is all clear
        try makeSureCollectStatusIsAllClear()
        
        // mark the RSS as collected
        try pool.execute { conn in
            try Row.CollectStatus.updateLatestStatus(rssID: RSSID(1), status: .success, conn: conn)
        }
        
        do {
            // the RSS up to date
            let rssIDs = try Row.CollectStatus.fetchOutdated(pool: pool)
            XCTAssertEqual(rssIDs.count, 0)
        }
        
        // update collect_status.next_updates to 2001-01-01 00:00:00
        // to simulate the RSS is outdated
        try pool.execute { conn in
            let status: QueryStatus = try conn.query("UPDATE collect_status SET next_updates = ?", ["2001-01-01 00:00:00"])
            XCTAssertEqual(status.affectedRows, 1)
        }
        
        do {
            let rssIDs = try Row.CollectStatus.fetchOutdated(pool: pool)
            
            // the RSS should be outdated (crawled once and outdated)
            XCTAssertEqual(rssIDs.count, 1)
            XCTAssertEqual(rssIDs[0], RSSID(1))
        }
    }
    
    func testArticleInsert() throws {
        // TODO: implement me
    }
}
