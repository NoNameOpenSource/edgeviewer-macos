//
//  DoublePageViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 20..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class DoublePageViewController: NSViewController {
    
    @IBOutlet weak var leftView: NSView!
    @IBOutlet weak var rightView: NSView!
    
    init() {
        super.init(nibName: NSNib.Name(rawValue: "DoublePageViewController"), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.wantsLayer = true
        leftView.wantsLayer = true
        rightView.wantsLayer = true
        view.layer?.backgroundColor = #colorLiteral(red: 0.1293984056, green: 0.1294192672, blue: 0.1293913424, alpha: 1)
        leftView.layer?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        rightView.layer?.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    func addImageViews(_ leftImageView: LazyImageView, _ rightImageView: LazyImageView)  {
        // left
        if leftView.subviews.count != 0 {
            leftView.replaceSubview(leftView.subviews[0], with: leftImageView)
        } else {
            leftView.addSubview(leftImageView)
        }
        
        // right
        if rightView.subviews.count != 0 {
            rightView.replaceSubview(rightView.subviews[0], with: rightImageView)
        } else {
            rightView.addSubview(rightImageView)
        }
    }
}
