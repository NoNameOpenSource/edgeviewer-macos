//
//  Page.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Page: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func PageViewLayout() {
        self.bounds.size = super.bounds.size
        self.bounds.size = super.bounds.size
    }
    
    func ContentViewLayout(manga : Manga, relatedView: NSView){}
    func UpdatePage(manga: Manga, relate : NSView){}
    
}
