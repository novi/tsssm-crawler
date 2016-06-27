//
//  ArticleListViewController.swift
//  RSSManager
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Cocoa
import CrawlerBase

final class ArticleListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var nextUpdatesLabel: NSTextField!
    
    @IBOutlet weak var tableView: NSTableView!
    
    private var articles: [Row.Article] = []
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.view.window?.title = self.title ?? ""
        fetchData()
        tableView.doubleAction = #selector(rowDoubleClicked)
    }
    
    internal var rssID: RSSID? 
    
    private func fetchData() {
        guard let rssID = self.rssID else {
            // has no RSS ID in this view controller to show articles
            articles = []
            statusLabel.stringValue = "No RSS selected"
            nextUpdatesLabel.stringValue = ""
            tableView.reloadData()
            return
        }
        do {
            self.articles = try Row.Article.fetchArticles(byRSS: rssID, pool: Context.shared.pool)
            tableView.reloadData()
            
            let status = try Row.CollectStatus.fetch(byRSS: rssID, pool: Context.shared.pool)
            statusLabel.stringValue = status.flatMap({ "\($0.latestStatus) on \($0.latestStatusAt)" }) ?? "Not yet crawled"
            nextUpdatesLabel.stringValue = status.flatMap({ "next updates: \($0.nextUpdate)" }) ?? ""
            
        } catch {
            self.presentError(title: "fetch articles", error: error)
        }
    }
    
    // MARK: Table View
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return articles.count
    }
    
    private enum Column: String {
        case ID = "article_id"
        case title = "title"
        case link = "link"
        case description = "description"
        case publishedAt = "published_at"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let column = Column(rawValue: tableColumn?.identifier ?? "")!
        let view = tableView.make(withIdentifier: column.rawValue, owner: nil) as! NSTableCellView
        
        let article = articles[row]
        
        switch column {
        case .ID:
            view.textField?.stringValue = article.articleID.description
        case .title:
            view.textField?.stringValue = article.title
        case .link:
            view.textField?.stringValue = article.link.absoluteString
        case .description:
            view.textField?.stringValue = article.description
        case .publishedAt:
            view.textField?.stringValue = "\(article.publishedAt)"
        }
        
        return view
    }
    
    @objc func rowDoubleClicked(_ sender: AnyObject) {
        if tableView.clickedRow >= 0 {
            let article = articles[tableView.clickedRow]
            NSWorkspace.shared().open(article.link)
        }
    }
    
    // MARK: 
    
    @IBAction func reloadClicked(_ sender: AnyObject) {
        fetchData()
    }
    
}