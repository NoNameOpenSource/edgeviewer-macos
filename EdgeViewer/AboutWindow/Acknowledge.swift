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
    
    @IBOutlet weak var appSupport: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        appSupport.target = self;
        appSupport.action = #selector(openFolder);
    }
    
    @objc func openFolder(){
        let folderPath = "/Users/bmmkac/Library/Containers/com.ggomong.EdgeViewer/Data/Library/Application Support";
        let folderURL = URL(fileURLWithPath: folderPath);
        NSWorkspace.shared.open(folderURL);
    }
    
}
