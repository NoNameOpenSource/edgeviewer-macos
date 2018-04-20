//
//  SinglePageViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 19..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class SinglePageViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    
    init() {
        super.init(nibName: NSNib.Name(rawValue: "SinglePageViewController"), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        //self.imageView!.image = self.image
        //imageView.imageScaling = .scaleProportionallyDown
    }
    
    override func viewDidAppear() {
        // add constraints to fill entire view
        //self.imageView.layer!.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        //self.view.layer!.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        //self.view.superview!.layer!.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        //self.view.superview!.superview!.layer!.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        /*
        NSLayoutConstraint(item: self.view,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.view.superview,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0.0)
            .isActive = true
        NSLayoutConstraint(item: self.view,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.view.superview,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0.0)
            .isActive = true
        NSLayoutConstraint(item: self.view,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.view.superview,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0.0)
            .isActive = true
        NSLayoutConstraint(item: self.view,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.view.superview,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0.0)
            .isActive = true
 */
    }
    
}
