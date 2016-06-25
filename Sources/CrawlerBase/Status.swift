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
    
    public enum LatestStatus {
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
        var status: LatestStatus_ {
            switch self {
            case .success: return .success
            case .failure: return .failure
            }
        }
        var errorMessage: String {
            switch self {
            case .success: return ""
            case .failure(let message): return message
            }
        }
        var nextUpdates: NSDate {
            switch self {
            case .success: return NSDate(timeIntervalSinceNow: 3600) // next updates for 1 hour after
            case .failure: return NSDate(timeIntervalSinceNow: 3600*24) // a day after
            }
        }
    }
    
    public struct CollectStatus: QueryRowResultType {
        let rssID: RSSID
        let latestStatus: LatestStatus
        let latestStatusAt: NSDate
        let nextUpdate: NSDate
        public static func decodeRow(r: QueryRowResult) throws -> CollectStatus {
            return try CollectStatus(rssID: r <| "rss_id",
                                 latestStatus: LatestStatus(status: r <| "latest_status",
                                                            errorMessage: r <| "error_message"),
                                 latestStatusAt: (r <| "latest_status_at" as SQLDate).date(),
                nextUpdate: (r <| "next_updates" as SQLDate).date())
        }
    }
}

extension Row.CollectStatus {
    
    struct RSSIDResult: QueryRowResultType {
        let rssID: RSSID
        static func decodeRow(r: QueryRowResult) throws -> RSSIDResult {
            return try RSSIDResult(rssID: r <| "rss_id")
        }
    }
    
    public static func fetchOutdated(pool: ConnectionPool) throws -> [RSSID] {
        return try pool.execute { conn in
            let res: [RSSIDResult] = try conn.query("SELECT rss.rss_id as rss_id FROM collect_status RIGHT JOIN rss ON rss.rss_id = collect_status.rss_id WHERE next_updates < now() OR next_updates IS NULL;")
            return res.map{ $0.rssID }
        }
    }
    
    public static func updateLatestStatus(rssID: RSSID, status: Row.LatestStatus, conn: Connection) throws {
        _ = try conn.query("INSERT INTO collect_status (rss_id,latest_status,error_message,latest_status_at,next_updates) VALUES (?,?,?,?,?) ON DUPLICATE KEY UPDATE latest_status=VALUES(latest_status),error_message=VALUES(error_message),latest_status_at=VALUES(latest_status_at),next_updates=VALUES(next_updates)",
        [rssID, status.status, status.errorMessage, NSDate(), status.nextUpdates]
        )
    }
}