//
//  CollectionViewItem.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
}
