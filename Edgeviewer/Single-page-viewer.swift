//
//  Single-page-viewer.swift
//  Edgeviewer
//
//  Created by bmmkac on 3/31/18.
//  Copyright © 2018 bmmkac. All rights reserved.
//

import Cocoa

class Single_page_viewer: NSViewController {


    @IBOutlet var viewer: NSView!
    
    @IBOutlet weak var user_panel: NSVisualEffectView!
    @IBOutlet weak var Settings_Button: NSButton!
    @IBOutlet weak var Chapter_button: NSButton!
    @IBOutlet weak var Go_back_button: NSButton!
    @IBOutlet weak var Book_Mark_Button: NSButton!
    

    
    @IBOutlet weak var Read_prev_button: NSButton!
    @IBOutlet weak var Read_Next_Button: NSButton!
    
    @IBOutlet weak var Content: NSView!
    
    @IBAction func Chapter(_ sender: Any) {
    }
    
    @IBAction func Go_back_button(_ sender: NSButton) {
    }
    
    
    
    @IBOutlet weak var ContentViewer: NSScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do view setup here.
    }
    
}
