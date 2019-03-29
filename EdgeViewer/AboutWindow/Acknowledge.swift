//
//  Acknowledge.swift
//  EdgeViewer
//
//  Created by bmmkac on 10/16/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Acknowledge: NSViewController {
    @IBOutlet weak var info: NSScrollView!
    
    @IBOutlet var acknowledgementsTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        acknowledgementsTextView.textStorage?.append(NSAttributedString(string: """
            https://github.com/marmelroy/Zip
            https://github.com/ZipArchive/ZipArchive
            """))
        acknowledgementsTextView.isEditable = false
    }
}
