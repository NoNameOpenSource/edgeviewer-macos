//
//  ButtonItem.swift
//  EdgeViewer
//
//  Created by bmmkac on 6/7/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

enum ButtonType: String {
    case backward = "Backward"
    case forward = "Foward"
    case custom = "Custom"
    case chapter = "Chapter"
    case none = "None"
    
}

class ButtonItem: NSCollectionViewItem {
    
    @IBOutlet weak var button: NSButton!
    
    var image: NSImage? {
        get {
            return button.image
        }
        set(newValue) {
            button.image = newValue
        }
    }
    
    var isEnabled: Bool {
        get {
            return button.isEnabled
        }
        set(newValue) {
            button.isEnabled = newValue
        }
    }
    
    var buttonType: ButtonType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
    }
    
}

