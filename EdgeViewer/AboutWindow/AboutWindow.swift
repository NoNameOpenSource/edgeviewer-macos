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
    
    @IBAction func openApplicationSupportFolder(_ sender: NSButton) {
        let folderURL = getApplicationSupportBooksDirectory()
        if let folderURL = folderURL {
            NSWorkspace.shared.open(folderURL)
        }
        else {
            print("Could not get Books Folder")
        }
    }
    
    
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
    
    func getApplicationSupportBooksDirectory() -> URL? {
        return getApplicationSupportAppDirectory()?.appendingPathComponent("Books")
    }
    
    // after merge, use static function from LocalPlugin instead of this repeated function
    func getApplicationSupportAppDirectory() -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        if paths.count >= 1 {
            return NSURL(fileURLWithPath: paths[0], isDirectory: true).appendingPathComponent("EdgeViewer")
        }
        print("Could not find application support directory.")
        return nil
    }
    
}
