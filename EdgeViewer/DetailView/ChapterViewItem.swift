//
//  ChapterViewItem.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/15/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ChapterViewItem: NSCollectionViewItem {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
    
    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2 { // user did double-click
            if let chapterViewController = collectionView?.delegate as? DetailViewController {
                chapterViewController.bookSegue(collectionView!, didDoubleClick: self)
            } else {
                print("could not get DetailViewController from collectionView.delegate")
            }
        } else {
            // user did not double-click
            super.mouseDown(with: event)
        }
    }
}
