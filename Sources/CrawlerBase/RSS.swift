//
//  RSS.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL

enum URLError: ErrorProtocol {
    case invalidURLString(String)
}

extension NSURL {
    static func from(string: String) throws -> NSURL {
        guard let url = NSURL(string: string) else {
            throw URLError.invalidURLString(string)
        }
        return url
    }
}

enum Row {
    
    struct RSS: QueryRowResultType {
        let rssID: RSSID // TODO: auto increment type
        let title: String
        let url: NSURL
        let createdAt: NSDate
        static func decodeRow(r: QueryRowResult) throws -> RSS {
            return try RSS(rssID: r <| "rss_id",
                           title: r <| "title",
                           url: NSURL.from(string: r <| "url"),
                           createdAt: (r <| "created_at" as SQLDate).date()
            )
        }
    }
}

extension Row.RSS: QueryParameterDictionaryType {
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            //"rss_id": rssID, auto increment
            "title": title,
            "url": url.absoluteString,
            "created_at": createdAt
        ])
    }
}

