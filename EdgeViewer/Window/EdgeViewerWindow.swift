//
//  EdgeViewerWindow.swift
//  EdgeViewer
//
//  Created by bmmkac on 3/10/19.
//  Copyright © 2019 NoName. All rights reserved.
//

import Cocoa

class EdgeViewerWindow: NSWindowController {

    override func windowDidLoad() {
        weak var mainWindow: ProjectWindow!
        super.windowDidLoad()
        self.windowFrameAutosaveName = NSWindow.FrameAutosaveName.init(rawValue: "EdgeViewer")
        self.window!.setFrameAutosaveName(NSWindow.FrameAutosaveName(rawValue: "EdgeViewer"))
    }

}
