//
//  ButtonItem.swift
//  EdgeViewer
//
//  Created by bmmkac on 6/7/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ButtonItem: NSCollectionViewItem {
    
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 5.0 : 1.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView?.frame.size = self.view.bounds.size
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        // Sets white boarder when the width is greater than zero
        view.layer?.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        // Sets the boarders to 0.0
        view.layer?.borderWidth = 1.0
    }
    
}

