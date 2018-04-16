//
//  ChapterViewItem.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/15/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ChapterViewItem: NSCollectionViewItem {
    
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
}
