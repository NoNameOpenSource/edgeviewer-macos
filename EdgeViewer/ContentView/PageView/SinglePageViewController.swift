//
//  SinglePageViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 19..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class SinglePageViewController: NSViewController {
    
    init() {
        super.init(nibName: NSNib.Name(rawValue: "SinglePageViewController"), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.wantsLayer = true
        view.layer?.backgroundColor = #colorLiteral(red: 0.1293984056, green: 0.1294192672, blue: 0.1293913424, alpha: 1)
    }
    
    func addImageView(_ imageView: LazyImageView)  {
        if view.subviews.count != 0 {
            view.replaceSubview(view.subviews[0], with: imageView)
        } else {
            view.addSubview(imageView)
        }
    }
}
