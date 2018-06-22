//
//  CoverImage.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 6/21/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class CoverImage: NSImageView {
    
    var delegate: CoverImageDelegate?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(with event: NSEvent) {
        print("did reach this function!")
        if event.clickCount > 1 { // user did double-click
            print("user did double click")
            if let delegate = delegate {
                delegate.segueToContentView()
            } else {
                print("delegate nil")
            }
        } else {
            // user did not double-click
            super.mouseDown(with: event)
        }
    }
}
