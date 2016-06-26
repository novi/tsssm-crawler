//
//  RSSListViewController.swift
//  RSSManager
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Cocoa
import CrawlerBase

final class RSSListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, RSSNewViewControllerDelegate {
    
    private var rss: [Row.RSS] = []
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        fetchData()
    }
    
    private func fetchData() {
        do {
            self.rss = try Row.RSS.fetchAll(pool: Context.shared.pool)
            tableView.reloadData()
        } catch {
            self.presentError(title: "fetch RSS all", error: error)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rss.count
    }
    
    private enum Column: String {
        case ID = "rss_id"
        case title = "title"
        case url = "url"
        case createdAt = "created_at"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let column = Column(rawValue: tableColumn?.identifier ?? "")!
        let view = tableView.make(withIdentifier: column.rawValue, owner: nil) as! NSTableCellView
        
        let theRSS = rss[row]
        
        switch column {
        case .ID:
            view.textField?.stringValue = "\(theRSS.rssID.id)"
        case .title:
            view.textField?.stringValue = theRSS.title
        case .url:
            view.textField?.stringValue = theRSS.url.absoluteString
        case .createdAt:
            view.textField?.stringValue = "\(theRSS.createdAt)"
        }
        
        return view
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: AnyObject?) {
        if let newVc = segue.destinationController as? RSSNewViewController {
            print(newVc)
            newVc.delegate = self
        }
    }
    
    func RSSDidCreate(vc: RSSNewViewController) {
        fetchData()
    }
    
    
}

