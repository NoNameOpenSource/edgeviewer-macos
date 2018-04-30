//
//  ChapterItem.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/30/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ChapterItem: NSCollectionViewItem {
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 4.0 : 0.0
        }
    }
    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = #colorLiteral(red: 0.9117823243, green: 0.9118037224, blue: 0.9117922187, alpha: 1)
        
        // Sets white boarder when the width is greater than zero
        view.layer?.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Sets the boarders to 0.0
        view.layer?.borderWidth = 0.0
    }
}
