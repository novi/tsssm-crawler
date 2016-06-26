//
//  RSSNewViewController.swift
//  RSSManager
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Cocoa
import CrawlerBase

protocol RSSNewViewControllerDelegate: NSObjectProtocol {
    func RSSDidCreate(vc: RSSNewViewController)
}

final class RSSNewViewController: NSViewController {
    weak var delegate: RSSNewViewControllerDelegate?
    
    
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var urlField: NSTextField!
    
    private enum Error: ErrorProtocol {
        case titleEmptyError
        case urlEmptyError
    }
    
    @IBAction func createTapped(_ sender: AnyObject) {
        do {
            guard urlField.stringValue.isEmpty == false else {
                throw Error.urlEmptyError
            }
            guard titleField.stringValue.isEmpty == false else {
                throw Error.titleEmptyError
            }
            let url = try NSURL.from(string: urlField.stringValue)
            try Row.RSS.createNew(title: titleField.stringValue, url: url, pool: Context.shared.pool)
            delegate?.RSSDidCreate(vc: self)
        } catch {
            self.presentError(title: "RSS create error", error: error)
        }
        self.dismiss(self)
    }
}
