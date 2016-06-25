//
//  Content.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL


extension Row {
    public struct Article: QueryRowResultType {
        let articleID: ArticleID // TODO: auto increment type
        let rssID: RSSID
        let title: String
        let link: NSURL
        let guid: String
        let description: String
        let publishedAt: NSDate
        
        public static func decodeRow(r: QueryRowResult) throws -> Article {
            return try Article(articleID: r <| "article_id",
                               rssID: r <| "rss_id",
                               title: r <| "title",
                               link: NSURL.from(string: r <| "link"),
                               guid: r <| "guid",
                               description: r <| "description",
                               publishedAt: (r <| "published_at" as SQLDate).date()
            )
        }
    }
}


extension Row.Article: QueryParameterDictionaryType {
    public func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            //"article_id": "",
            "rss_id": rssID,
            "title": title,
            "link": link.absoluteString,
            "guid": guid,
            "description": description,
            "published_at": publishedAt
            ])
    }
    
    public func saveOrIgnore(conn: Connection) throws {
        let status: QueryStatus = try conn.query("INSERT IGNORE INTO articles SET ? ", [self])
        print("saveOrIgnore, \(status)")
    }
}



extension Row.Article {
    
    public static func makeForInsert(rss: RSSFetcher.Article, forRSSID: RSSID) -> Row.Article {
        return Row.Article(articleID: ArticleID(0),
                           rssID: forRSSID,
                           title: rss.title,
                           link: rss.link,
                           guid: rss.link.absoluteString,
                             description: rss.description,
                             publishedAt: rss.publishedAt)
    }
}
