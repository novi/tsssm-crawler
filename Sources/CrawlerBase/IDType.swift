//
//  IDType.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import MySQL

public struct RSSID: IDType {
    public let id: Int
    public init(_ id: Int) {
        self.id = id
    }
}

public struct ArticleID: IDType {
    public let id: Int
    public init(_ id: Int) {
        self.id = id
    }
}
