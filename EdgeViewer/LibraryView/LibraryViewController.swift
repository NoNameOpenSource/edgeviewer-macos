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
        checkConstraintsOfSubview(view: view)
        
    }
    
    func checkConstraintsOfSubview(view: NSView) {
        for view in view.subviews {
            print("\(view.className) has \(view.constraints.count) constraints:")
            for constraint in view.constraints {
                if(constraint.secondItem != nil) {
                    print("\t\(constraint.firstItem!.className!) \(nameOfAttribute(attribute: constraint.firstAttribute)) \(nameOfRelation(relation: constraint.relation)) \(constraint.secondItem!.className!) \(nameOfAttribute(attribute: constraint.firstAttribute))")
                } else {
                    print("\t\(constraint.firstItem!.className!)\(nameOfAttribute(attribute: constraint.firstAttribute)) \(nameOfRelation(relation: constraint.relation)) \(constraint.constant)")
                }
            }
            checkConstraintsOfSubview(view: view)
        }
    }
    
    func nameOfAttribute(attribute: NSLayoutConstraint.Attribute) -> String {
        switch(attribute) {
            case .bottom:
                return "bottom"
            case .left:
                return "left"
            case .right:
                return "right"
            case .top:
                return "top"
            case .leading:
                return "leading"
            case .trailing:
                return "trailing"
            case .width:
                return "width"
            case .height:
                return "height"
            case .centerX:
                return "centerX"
            case .centerY:
                return "centerY"
            case .lastBaseline:
                return "lastBaseline"
            case .firstBaseline:
                return "firstBaseline"
            case .notAnAttribute:
                return "notAnAttribute"
        }
    }
    
    func nameOfRelation(relation: NSLayoutConstraint.Relation) -> String {
        switch(relation) {
        case .lessThanOrEqual:
            return "<="
        case .equal:
            return "=="
        case .greaterThanOrEqual:
            return ">="
        }
    }
}
