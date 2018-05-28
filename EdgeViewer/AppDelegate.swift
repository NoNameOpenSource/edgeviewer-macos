//
//  AppDelegate.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 2..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var Notification : UserPanelView?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let firstPlugin = JSPlugin(pluginName: "test.js")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }


}

