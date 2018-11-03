//
//  AppDelegate.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 2..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {

    
    
    
    @available(OSX 10.14, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
 
    @available(OSX 10.14, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response)
        if response.notification.request.identifier == "import" {
            print("imported")
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if #available(OSX 10.14, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: {allowed, error in
                
                if allowed {
                    print("Authorization is \(allowed)")
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }


}

