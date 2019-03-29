//
//  ImportNotification.swift
//  EdgeViewer
//
//  Created by bmmkac on 11/4/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa
import Foundation

class ImportFailMessage {
    var failFileName : String?
    var failReason : String
    
    init(name : String,reason : String){
        self.failReason = reason
        self.failFileName = name
    }
}


class ImportNotification: NSViewController {
    
    
    @IBOutlet var importFail: NSArrayController!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
    }
    
}
