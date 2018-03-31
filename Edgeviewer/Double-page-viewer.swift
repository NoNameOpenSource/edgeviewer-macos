//
//  Double-page-viewer.swift
//  Edgeviewer
//
//  Created by bmmkac on 3/31/18.
//  Copyright © 2018 bmmkac. All rights reserved.
//

import Cocoa

class Double_page_viewer: NSViewController {

    @IBOutlet weak var page_seperater: NSBox!
    
    @IBOutlet weak var user_panel: NSVisualEffectView!
    @IBOutlet weak var Chapter_Button: NSVisualEffectView!
    @IBOutlet weak var Go_back_button: NSButton!
    @IBOutlet weak var Book_mark_buton: NSButton!
    @IBOutlet weak var Settings_button: NSButton!
    
    @IBOutlet weak var Read_next_button: NSButton!
    @IBOutlet weak var Read_prev_button: NSButton!
    
    @IBOutlet weak var Current_page: NSScrollView!
    @IBOutlet weak var Current_next_page: NSScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
