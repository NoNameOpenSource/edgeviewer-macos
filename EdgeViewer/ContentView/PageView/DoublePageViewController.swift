//
//  DoublePageViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 20..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class DoublePageViewController: NSViewController {
    
    var leftImage: NSImage? {
        didSet {
            if isViewLoaded {
                leftImageView.image = leftImage
            }
        }
    }
    var rightImage: NSImage? {
        didSet {
            if isViewLoaded {
                rightImageView.image = rightImage
            }
        }
    }
    @IBOutlet weak var leftImageView: NSImageView!
    @IBOutlet weak var rightImageView: NSImageView!

    
    init() {
        super.init(nibName: NSNib.Name(rawValue: "DoublePageViewController"), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if leftImageView.image != leftImage {
            leftImageView.image = leftImage
        }
        if rightImageView.image != rightImage {
            rightImageView.image = rightImage
        }
        
        view.wantsLayer = true
        view.layer?.backgroundColor = #colorLiteral(red: 0.1293984056, green: 0.1294192672, blue: 0.1293913424, alpha: 1)
    }
    
}
