//
//  ViewController.swift
//  RSSManager
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension NSViewController {
    
    func presentError(title: String, error: ErrorProtocol?) {
        let errMessage: String
        if let errObj = error {
            errMessage = "\n\(errObj)"
        } else {
            errMessage = ""
        }
        
        let err = NSError(domain: "", code: -1, userInfo: [
            NSLocalizedDescriptionKey as NSObject: "\(title)\(errMessage)" as AnyObject
            ])
        self.presentError(err as NSError)
    }
}