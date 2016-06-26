//
//  DBScheme.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL

protocol DBScheme {
    var tableName: String { get }
    var createScheme: String { get }
    
    func dropTable(pool: ConnectionPool) throws
    func createTable(pool: ConnectionPool) throws
    func dropAndCreateTable(pool: ConnectionPool) throws
}


extension DBScheme {
    
    func createTable(pool: ConnectionPool) throws {
        _ = try pool.execute { conn in
            try conn.query(createScheme, [tableName])
        }
        print("table `\(tableName)` created")
    }
    
    func dropTable(pool: ConnectionPool) throws {
        _ = try pool.execute { conn in
            try conn.query("DROP TABLE IF EXISTS ?? ;", [tableName])
        }
    }
    
    func dropAndCreateTable(pool: ConnectionPool) throws {
        try dropTable(pool: pool)
        try createTable(pool: pool)
    }
}


struct RSSScheme: DBScheme {
    
    let tableName = "rss"
    
    let createScheme = "CREATE TABLE ?? (" +
        "`rss_id` int(11) unsigned NOT NULL AUTO_INCREMENT," +
        "`title` mediumtext COLLATE utf8mb4_bin NOT NULL," +
        "`url` mediumtext COLLATE utf8mb4_bin NOT NULL," +
        "`created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP," +
        "PRIMARY KEY (`rss_id`)" +
    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;"
}

struct CollectStatusScheme: DBScheme {
    
    let tableName = "collect_status"
    
    let createScheme = "CREATE TABLE ?? (" +
    "`rss_id` int(11) unsigned NOT NULL," +
    "`latest_status` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT ''," +
    "`error_message` mediumtext COLLATE utf8mb4_bin NOT NULL," +
    "`latest_status_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP," +
    "`next_updates` datetime NOT NULL DEFAULT '2001-01-01 00:00:00'," +
    "PRIMARY KEY (`rss_id`)" +
    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;"
}


func AllScheme() -> [DBScheme] {
    return [RSSScheme(), CollectStatusScheme()]
}

