//
//  RSSTests.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import XCTest
@testable import CrawlerBase


extension RSSTests {
    static var allTests : [(String, (RSSTests) -> () throws -> Void)] {
        return [
            ("testParseRSS2", testParseRSS2)
        ]
    }
}


class RSSTests: XCTestCase {
    
    let rssString = "<?xml version=\"1.0\" encoding=\"utf-8\"?><rss version=\"2.0\"><channel><title>Apple Japan プレスリリース</title><link>http://www.apple.com/jp/pr/</link><description>アップル社のプレスリリース</description><language>en-US</language><copyright>2011 Apple, Inc.</copyright><category>Apple</category><generator>In house</generator><item><title>Apple、iOSとして史上最大のリリースとなるiOS 10をプレビュー</title><link>http://www.apple.com/jp/pr/library/2016/06/13Apple-Previews-iOS-10-The-Biggest-iOS-Release-Ever.html</link><description>2016年6月14日、Apple&amp;reg;は本日、世界で最も先進的なモバイルオペレーティングシステムのiOS 10を公開し史上最大のアップデートをしました。…Appleの10万人の社員は世界で最も素晴らしい製品を創り出すこと、そして自分たちが生まれてきた世界をさらに良いものとして次世代へ残すことに邁進しています。&lt;br /&gt;</description><pubDate>Mon, 13 Jun 2016 19:00:00 +0000</pubDate></item><item><title>Apple、メジャーアップデートとなるmacOS Sierraをプレビュー</title><link>http://www.apple.com/jp/pr/library/2016/06/13Apple-Previews-Major-Update-with-macOS-Sierra.html</link><description>&lt;div&gt; 2016年6月14日、Apple&amp;reg;は本日、世界で最も先進的なデスクトップオペレーティングシステムに、Mac&amp;reg;をこれまで以上にスマートで役立つ存在にする機能を加えたメジャーアップデート、macOS Sierra&amp;trade;（マックオーエス・シエラ）をプレビューしました。…Appleの10万人の社員は世界で最も素晴らしい製品を創り出すこと、そして自分たちが生まれてきた世界をさらに良いものとして次世代へ残すことに邁進しています。&lt;br /&gt;</description><pubDate>Mon, 13 Jun 2016 19:00:00 +0000</pubDate></item></channel></rss>"


    func testParseRSS2() throws {
        let parser = RSSFetcher(rssURL: NSURL(string: "http://dummy.com/path")!)
        let articles = try parser.parseRSS2(xml: rssString)
        
        XCTAssertEqual(articles.count, 2)
        
        XCTAssertEqual(articles[0].title, "Apple、iOSとして史上最大のリリースとなるiOS 10をプレビュー")
        XCTAssertEqual(articles[0].link, NSURL(string: "http://www.apple.com/jp/pr/library/2016/06/13Apple-Previews-iOS-10-The-Biggest-iOS-Release-Ever.html")!)
        XCTAssertEqual(articles[0].description, "2016年6月14日、Apple&reg;は本日、世界で最も先進的なモバイルオペレーティングシステムのiOS 10を公開し史上最大のアップデートをしました。…Appleの10万人の社員は世界で最も素晴らしい製品を創り出すこと、そして自分たちが生まれてきた世界をさらに良いものとして次世代へ残すことに邁進しています。<br />")
        // TODO: pubDate tests
        
        XCTAssertEqual(articles[1].title, "Apple、メジャーアップデートとなるmacOS Sierraをプレビュー")
        XCTAssertEqual(articles[1].link, NSURL(string: "http://www.apple.com/jp/pr/library/2016/06/13Apple-Previews-Major-Update-with-macOS-Sierra.html")!)
        XCTAssertEqual(articles[1].description, "<div> 2016年6月14日、Apple&reg;は本日、世界で最も先進的なデスクトップオペレーティングシステムに、Mac&reg;をこれまで以上にスマートで役立つ存在にする機能を加えたメジャーアップデート、macOS Sierra&trade;（マックオーエス・シエラ）をプレビューしました。…Appleの10万人の社員は世界で最も素晴らしい製品を創り出すこと、そして自分たちが生まれてきた世界をさらに良いものとして次世代へ残すことに邁進しています。<br />")
        
        let row = Row.Article.makeForInsert(rss: articles[0], forRSSID: RSSID(123))
        XCTAssertEqual(row.rssID, RSSID(123))
        XCTAssertEqual(row.guid, articles[0].link.absoluteString)
        XCTAssertEqual(row.title, articles[0].title)
        XCTAssertEqual(row.link, articles[0].link)
        XCTAssertEqual(row.description, articles[0].description)
        
    }
}
