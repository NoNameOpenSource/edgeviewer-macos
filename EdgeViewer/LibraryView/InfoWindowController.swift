//
//  InfoWindowController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 6. 4..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Cocoa

class InfoWindowController: NSWindowController {

    @IBOutlet weak var coverImageView: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var seriesLabel: NSTextField!
    @IBOutlet weak var authorLabel: NSTextField!
    
    
    @IBAction func okButton(_ sender: NSButton) {
        self.close()
        NSApplication.shared.abortModal()
    }
    
    @IBAction func cancelButton(_ sender: NSButton) {
        self.close()
        NSApplication.shared.abortModal()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
