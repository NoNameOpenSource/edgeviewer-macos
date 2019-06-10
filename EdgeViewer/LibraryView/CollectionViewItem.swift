//
//  CollectionViewItem.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    var thumbnail: LazyImageView? {
        didSet {
            if self.view.subviews.count == 3 {
                if let thumbnail = thumbnail {
                    self.view.replaceSubview(self.view.subviews[0], with: thumbnail)
                } else {
                    self.view.subviews[0].removeFromSuperview()
                }
            } else {
                if let thumbnail = thumbnail {
                    self.view.addSubview(thumbnail, positioned: .below, relativeTo: self.view.subviews[0])
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        // Sets white boarder when the width is greater than zero
        view.layer?.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Sets the boarders to 0.0
        view.layer?.borderWidth = 0.0
    }
    
    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2 {
            if let shelfViewController = collectionView?.delegate as? ShelfViewController {
                shelfViewController.collectionView(collectionView!, didDoubleClick: self)
            }
        } else {
            super.mouseDown(with: event)
        }
    }
}
