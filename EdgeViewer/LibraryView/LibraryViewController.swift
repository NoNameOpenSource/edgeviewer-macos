//
//  LibraryViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 14..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class LibraryViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // overriding layout generated by AutoLayout
        if let view = splitViewItems[0].viewController.view.superview {
            for constraint in view.constraints {
                if constraint.firstAttribute == .width && constraint.relation == .greaterThanOrEqual {
                    constraint.constant = 150
                }
            }
        }
    }
}
