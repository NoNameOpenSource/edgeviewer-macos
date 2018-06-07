//
//  ButtomItem.swift
//  EdgeViewer
//
//  Created by bmmkac on 5/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ButtomItem: NSCollectionViewItem {
    @IBOutlet weak var buttomImage: NSImageView!
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5.0 : 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       buttomImage.image = NSImage(named: NSImage.Name(rawValue: "BackIcon"))
        
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        // Sets white boarder when the width is greater than zero
        view.layer?.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Sets the boarders to 0.0
        view.layer?.borderWidth = 0.0
    }
    
}
