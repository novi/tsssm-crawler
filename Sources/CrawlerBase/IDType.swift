//
//  IDType.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL

struct RSSID: IDType {
    let id: Int
    init(_ id: Int) {
        self.id = id
    }
}

struct ArticleID: IDType {
    let id: Int
    init(_ id: Int) {
        self.id = id
    }
}
