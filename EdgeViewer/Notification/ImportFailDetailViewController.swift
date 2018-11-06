//
//  ImportFailDetailViewController.swift
//  EdgeViewer
//
//  Created by bmmkac on 11/4/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa


@objc class ImportFailDetail : NSObject{
    @objc var failFileName : String
    @objc var failMessage : String
    
    init(name:String,message:String) {
        self.failFileName = name
        self.failMessage = message
    }
}


class ImportFailDetailViewController: NSViewController {
    @IBOutlet var importFail: NSArrayController!
    var failMessage : [[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for fails in failMessage {
            self.importFail.addObject(ImportFailDetail(name: fails[0],message: fails[1]))
        }
        
        print(importFail.arrangedObjects)
        
    }
    
    override func viewDidDisappear() {
        self.importFail.remove(contentsOf: failMessage)
    }
    
}
