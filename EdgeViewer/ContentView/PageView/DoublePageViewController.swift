//
//  DoublePageViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 20..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class DoublePageViewController: NSViewController {
    
    init() {
        super.init(nibName: NSNib.Name(rawValue: "DoublePageViewController"), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
