//
//  ShelfView.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 6. 10..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Cocoa

class ShelfView: NSCollectionView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func rightMouseDown(with event: NSEvent) {
        guard let point = event.window?.contentView?.convert(event.locationInWindow, to: self) else { return }
        guard let indexPath = self.indexPathForItem(at: point) else { return }
        selectionIndexPaths = [indexPath]
        super.rightMouseDown(with: event)
    }
}
