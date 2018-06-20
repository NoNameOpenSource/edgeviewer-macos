//
//  ProjectWindow.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 6/20/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ProjectWindow: NSWindow {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
//        Hide the button title
        self.titleVisibility = .hidden
    }
//    Action when button pressed
    @IBAction func goBack(_ sender: AnyObject?) {
    print("Back")
    }
}
