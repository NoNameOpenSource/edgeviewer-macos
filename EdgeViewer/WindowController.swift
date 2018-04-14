//
//  WindowController.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = window, let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            window.setFrame(NSRect(x: screenRect.origin.x, y: screenRect.origin.y, width: screenRect.width/2.0, height: screenRect.height), display: true)
        }
    }
    
    @IBAction func openAnotherFolder(_ sender: AnyObject) {
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories  = true
        openPanel.canChooseFiles        = false
        openPanel.showsHiddenFiles      = false
        
        openPanel.beginSheetModal(for: self.window!) { (response) -> Void in
            guard response.rawValue == NSFileHandlingPanelOKButton else {return}
            let viewController = self.contentViewController as? ViewController
            if let viewController = viewController, let URL = openPanel.url {
                viewController.loadDataForNewFolderWithUrl(URL)
            }
        }
    }
    
}

