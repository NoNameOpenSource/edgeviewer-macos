//
//  ContentViewer.swift
//  Edgeviewer
//
//  Created by bmmkac on 4/1/18.
//  Copyright © 2018 bmmkac. All rights reserved.
//

import Cocoa

class ContentViewer: NSViewController {

    @IBOutlet weak var Settings: NSButton!
    @IBOutlet weak var ReturnToDetailView: NSButton!
    @IBOutlet weak var BookMark: NSButton!
    @IBOutlet weak var PageNumber: NSTextField!
    @IBOutlet weak var GoForward: NSButton!
    @IBOutlet weak var GoBackWard: NSButton!
    @IBOutlet weak var Chapter: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
