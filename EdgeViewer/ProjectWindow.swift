//
//  ProjectWindow.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 6/20/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

let leftArrowKey = 123
let rightArrowKey = 124

class ProjectWindow: NSWindow {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
//        Hide the button title
        self.titleVisibility = .hidden
    }
//    Action when button pressed
    @IBAction func goBack(_ sender: AnyObject?) {
        guard let libraryViewController = self.contentViewController as? LibraryViewController else { return }
        libraryViewController.navig()
    }
    
    //------------------------------------------------------------------------------------------------
    // MARK: Flip Through Pages With Arrow Keys in Content View
    //------------------------------------------------------------------------------------------------
    override func keyDown(with event: NSEvent) {
        guard let childViewController = self.contentViewController?.childViewControllers.filter({ $0 is ContentViewController }).first else {
            print("Could not get child view controllers of contentViewController: contentViewController is probably nil")
            return
        }
        switch childViewController {
            case let viewController as ContentViewController:
                let character = Int(event.keyCode)
                switch character {
                    case leftArrowKey:
                        viewController.currentPage -= 1
                    case rightArrowKey:
                        viewController.currentPage += 1
                    default:
                        super.keyDown(with: event)
                return // only get the first ContentViewController
                }
            default:
                print("Could not find a child view controller of type ContentViewController")
                break
        }
    }
}
