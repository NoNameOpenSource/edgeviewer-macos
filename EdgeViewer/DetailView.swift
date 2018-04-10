//
//  DetailView.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class DetailView: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBOutlet weak var ReadFromBeginningButton: NSButton!
    
    @IBAction func showReadFromBeginningButton(_ sender: Any) {
        print("pressed")
        ReadFromBeginningButton.isHidden = false
    }
}
