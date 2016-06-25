//
//  Status.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL

extension Row {
    
    enum LatestStatus_: String, SQLEnumType {
        case success = "success"
        case failure = "failure"
    }
    
    enum LatestStatus {
        case success
        case failure(String)
        init(status: LatestStatus_, errorMessage: String) {
            switch status {
            case .success:
                self = .success
            case .failure:
                self = .failure(errorMessage)
            }
        }
        var nextUpdates: NSDate {
            fatalError("implement me")
        }
    }
    
    struct CollectStatus: QueryRowResultType {
        let rssID: RSSID
        let latestStatus: LatestStatus
        let latestStatusAt: NSDate
        let nextUpdate: NSDate
        static func decodeRow(r: QueryRowResult) throws -> CollectStatus {
            return try CollectStatus(rssID: r <| "rss_id",
                                 latestStatus: LatestStatus(status: r <| "latest_status",
                                                            errorMessage: r <| "error_message"),
                                 latestStatusAt: (r <| "latest_status_at" as SQLDate).date(),
                nextUpdate: (r <| "next_updates" as SQLDate).date())
        }
    }
}

extension Row.CollectStatus {
    static func updateLatestStatus(rssID: RSSID, status: Row.LatestStatus, conn: Connection) throws {
        
    }
}