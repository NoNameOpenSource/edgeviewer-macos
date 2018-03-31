//
//  user_panel.swift
//  Edgeviewer
//
//  Created by bmmkac on 3/31/18.
//  Copyright © 2018 bmmkac. All rights reserved.
//

import Cocoa


class user_panel: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        self.wantsLayer = true;
        
        self.layer!.cornerRadius = 10;
        
    }
    
}
