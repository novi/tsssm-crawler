//
//  main.swift
//  RSSCrawler
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import CrawlerBase
import CrawlerConfig
import MySQL


var willTerminate = false

signal(SIGINT) { _ in
    willTerminate = true
}

let pool = ConnectionPool(options: Config.local.DB)

while true {
    if willTerminate {
        exit(0) // exit gracefully
    }
    
    // fetch RSSs to crawl
    let rssIDs = try Row.CollectStatus.fetchOutdated(pool: pool)
    
    for rssID in rssIDs {
        do {
            // fetch URL of the RSS
            let rss = try Row.RSS.fetch(byID: rssID, pool: pool)
            
            // send request for RSS
            let articles = try RSSFetcher(rssURL: rss.url).fetchAndParse()
            
            // save parsed articles
            try pool.transaction { conn in
                for article in articles {
                    try Row.Article.makeForInsert(rss: article, forRSSID: rssID).saveOrIgnore(conn: conn)
                }
                try Row.CollectStatus.updateLatestStatus(rssID: rssID, status: .success, conn: conn) // mark the rss as successful
            }
        } catch {
            // crawl failed, set status
            try pool.execute { conn in
                try Row.CollectStatus.updateLatestStatus(rssID: rssID, status: .failure("\(error)"), conn: conn)
            }
        }
    }
    
    sleep(5) // fetch RSSs to crawl every 5 seconds
}