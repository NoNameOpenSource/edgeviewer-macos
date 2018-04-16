//
//  Page.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class PageView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func pageViewLayout() {
        self.bounds.size = super.bounds.size
        self.bounds.size = super.bounds.size
    }
    
    func contentViewLayout(manga : Manga, relatedView: NSView){}
    func updatePage(manga: Manga, relate : NSView){}
    
}
