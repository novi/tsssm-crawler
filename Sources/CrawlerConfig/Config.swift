//
//  Config.swift
//  CrawlerConfig
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL

struct LocalDB: ConnectionOption {
    let host: String = "127.0.0.1"
    let port: Int = 3306
    let user: String = "root"
    let password: String = ""
    let database: String = "crawler_demo"
    let encoding: Connection.Encoding = .UTF8MB4
}

public struct Config {
    public static let local = Config(DB: LocalDB())
    
    public let DB: ConnectionOption
}

