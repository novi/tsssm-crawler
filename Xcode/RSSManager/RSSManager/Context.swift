//
//  Context.swift
//  RSSManager
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL
import CrawlerConfig


final class Context {
    static let shared = Context()
    let pool: ConnectionPool
    init() {
        self.pool = ConnectionPool(options: Config.local.DB)
    }
}
