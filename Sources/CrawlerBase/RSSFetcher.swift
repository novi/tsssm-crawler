//
//  RSSFetcher.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/25/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation


public struct RSSFetcher {
    
    public enum FetcherError: ErrorProtocol {
        case fetchError
        case noRootElement
        case noChannelElement
    }
    
    public let url: NSURL
    public init(rssURL: NSURL) {
        self.url = rssURL
    }
    
    public func fetchAndParse() throws -> [Article] {
        return try parseRSS2(data: fetch())
    }
    
    internal func fetch() throws -> NSData {
        fatalError()
    }
    
    internal func parseRSS2(data: NSData) throws -> [Article] {
        let doc = try NSXMLDocument(data: data, options: 0)
        guard let root = doc.rootElement() else {
            throw FetcherError.noRootElement
        }
        guard let channel = root.elements(forName: "channel").first else {
            throw FetcherError.noChannelElement
        }
        return try channel.elements(forName: "item").map(Article.init)
    }
}

extension RSSFetcher {
    public struct Article {
        let title: String
        let link: NSURL
        let description: String
        let publishedAt: NSDate
        init(_ element: NSXMLElement) throws {
            title = element.elements(forName: "title").first?.stringValue ?? ""
            link = try NSURL.from(string: element.elements(forName: "link").first?.stringValue ?? "")
            description = element.elements(forName: "description").first?.stringValue ?? ""
            publishedAt = NSDate() // TODO: date parse
        }
    }
}