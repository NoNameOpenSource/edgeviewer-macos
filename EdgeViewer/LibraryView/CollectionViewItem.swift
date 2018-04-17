//
//  CollectionViewItem.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        // Sets white boarder when the width is greater than zero
        view.layer?.borderColor = NSColor.black.cgColor
        // Sets the boarders to 0.0
        view.layer?.borderWidth = 0.0
    }
}
