//
//  Manga.swift
//  Edgeviewer
//
//  Created by bmmkac on 3/27/18.
//  Copyright © 2018 bmmkac. All rights reserved.
//

import Cocoa

class Manga: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBOutlet weak var readFromBeginningTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var readFromBeginningButton: NSButton!
    

    @IBAction func showReadFromBeginningBuggon(_ sender: NSButton) {
        print("pressed")
        readFromBeginningButton.isHidden = false
        readFromBeginningTopConstraint.constant = 7
    }
    
}
