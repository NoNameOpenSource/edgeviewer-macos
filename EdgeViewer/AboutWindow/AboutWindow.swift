//
//  AboutScreen.swift
//  EdgeViewer
//
//  Created by bmmkac on 10/16/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class AboutWindow: NSViewController {
    @IBOutlet weak var appIcon: NSImageView!
    @IBOutlet weak var appName: NSTextField!
    @IBOutlet weak var appVersion: NSTextField!
    @IBOutlet weak var appCopyright: NSTextField!
    @IBOutlet var backgroundView: NSView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        backgroundView.wantsLayer = true;
    }
    
    
    override func viewWillAppear() {
        backgroundView.layer?.backgroundColor = NSColor.white.cgColor
        
        if var InfoData = Bundle.main.infoDictionary {
            appName.stringValue = InfoData["CFBundleName"] as! String
            appVersion.stringValue = "Version "
            appVersion.stringValue += InfoData["CFBundleShortVersionString"] as! String
            appCopyright.stringValue = InfoData["NSHumanReadableCopyright"] as! String
            if let appImage = NSImage(named: NSImage.Name(rawValue: "AppIcon")){
                appIcon.image = appImage
            }
        }else{
            print("Info File do not exist or is unaccessible")
            appName.stringValue = "EdgeViewer"
            appVersion.stringValue = "Version 1.0 "
            
        }
        
    }
    
}
