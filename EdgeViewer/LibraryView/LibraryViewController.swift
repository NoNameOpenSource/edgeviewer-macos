//
//  LibraryViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 14..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

protocol ShelfViewDelegate {
    func shelf(_: ShelfViewController, selectedItem pageItem: PageItem)
}

class LibraryViewController: NSSplitViewController, ShelfViewDelegate {
    
    var listViewController: LibraryListViewController? = nil
    var shelfViewController: ShelfViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        for item in splitViewItems {
            switch item.viewController {
                case let viewController as ShelfViewController:
                    shelfViewController = viewController
                case let viewController as LibraryListViewController:
                    listViewController = viewController
                default:
                    print("error")
            }
        }
        
        // overriding layout generated by AutoLayout
        if let view = listViewController!.view.superview {
            for constraint in view.constraints {
                if constraint.firstAttribute == .width && constraint.relation == .greaterThanOrEqual {
                    constraint.constant = 150
                }
            }
        }
        
        let firstPlugin = JSPlugin(pluginName: "test.js")
        segue(toPage: firstPlugin.homePage)
    }
    
    func shelf(_: ShelfViewController, selectedItem pageItem: PageItem) {
        switch pageItem.type {
        case .book:
            return
        case .link:
            return
        }
    }
    
    func segue(toPage page: LibraryPage) {
        let newShelf = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ShelfViewController")) as! ShelfViewController
        newShelf.libraryPage = page
        let oldShelf = self.splitViewItems[1].viewController
        let segue = NSStoryboardSegue(identifier: NSStoryboardSegue.Identifier(rawValue: "LibraryPageSegue"),
                                      source: oldShelf,
                                      destination: newShelf,
                                      performHandler: {
                                        self.removeSplitViewItem(self.splitViewItems[1])
                                        self.addSplitViewItem(NSSplitViewItem(viewController: newShelf))
                                        newShelf.delegate = self
        })
        oldShelf.prepare(for: segue, sender: user.self)
        segue.perform()
        shelfViewController = newShelf
    }
}
