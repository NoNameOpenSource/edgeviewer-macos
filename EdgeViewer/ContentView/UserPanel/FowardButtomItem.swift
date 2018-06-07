//
//  FowardButtomItem.swift
//  EdgeViewer
//
//  Created by bmmkac on 5/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class FowardButtomItem: ButtomItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.imageView?.image = NSImage(named: NSImage.Name(rawValue: "BackIcon"))        // Do view setup here.
    }
}
