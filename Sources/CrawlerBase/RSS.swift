//
//  RSS.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL

public enum URLError: ErrorProtocol {
    case invalidURLString(String)
}

extension NSURL {
    public static func from(string: String) throws -> NSURL {
        guard let url = NSURL(string: string) else {
            throw URLError.invalidURLString(string)
        }
        return url
    }
}

public enum Row {
    
    public struct RSS: QueryRowResultType {
        public let rssID: AutoincrementID<RSSID>
        public let title: String
        public let url: NSURL
        public let createdAt: NSDate
        public static func decodeRow(r: QueryRowResult) throws -> RSS {
            return try RSS(rssID: r <| "rss_id",
                           title: r <| "title",
                           url: NSURL.from(string: r <| "url"),
                           createdAt: (r <| "created_at" as SQLDate).date()
            )
        }
    }
}

extension Row.RSS: QueryParameterDictionaryType {
    public func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "rss_id": rssID,
            "title": title,
            "url": url.absoluteString,
            "created_at": createdAt
        ])
    }
}

extension Row.RSS {
    
    public enum Error: ErrorProtocol {
        case noRSS(RSSID)
    }
    
    public static func fetch(byID rssID: RSSID, pool: ConnectionPool) throws -> Row.RSS {
        let rss: [Row.RSS] = try pool.execute { conn in
            try conn.query("SELECT rss_id,title,url,created_at FROM rss WHERE rss_id = ? LIMIT 1", [rssID])
        }
        guard let first = rss.first else {
            throw Error.noRSS(rssID)
        }
        return first
    }
    
    public static func fetchAll(pool: ConnectionPool) throws -> [Row.RSS] {
        return try pool.execute { conn in
            try conn.query("SELECT rss_id,title,url,created_at FROM rss")
        }
    }
    
    public static func createNew(title: String, url: NSURL, pool: ConnectionPool) throws {
        try pool.execute { conn in
            let rss = Row.RSS(rssID: .noID, title: title, url: url, createdAt: NSDate())
            try conn.query("INSERT INTO rss SET ?", [rss])
        }
    }
}

