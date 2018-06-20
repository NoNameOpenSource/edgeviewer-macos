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
        
        let firstPlugin = LocalPlugin.sharedInstance
        segue(toPage: firstPlugin.homePage)
    }
    
    func shelf(_: ShelfViewController, selectedItem pageItem: PageItem) {
        switch pageItem.type {
        case .book:
            segueToDetailView(withBook: pageItem.content as! Book)
        case .link:
            segue(toPage: pageItem.content as! LibraryPage)
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
    
    func segueToDetailView(withBook book: Book) {
        let detailViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DetailViewController")) as! DetailViewController
        let oldShelf = self.splitViewItems[1].viewController
        let segue = NSStoryboardSegue(identifier: NSStoryboardSegue.Identifier(rawValue: "LibraryPageSegue"),
                                      source: oldShelf,
                                      destination: detailViewController,
                                      performHandler: {
                                        self.removeSplitViewItem(self.splitViewItems[1])
                                        self.addSplitViewItem(NSSplitViewItem(viewController: detailViewController))
        })
        detailViewController.book = book;
        oldShelf.prepare(for: segue, sender: user.self)
        segue.perform()
    }
    
    func segueToContentView(withBook book: Book) {
        let contentViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ContentViewController")) as! ContentViewController
        let oldShelf = self.splitViewItems[1].viewController
        let segue = NSStoryboardSegue(identifier: NSStoryboardSegue.Identifier(rawValue: "LibraryPageSegue"),
                                      source: oldShelf,
                                      destination: contentViewController,
                                      performHandler: {
                                        self.removeSplitViewItem(self.splitViewItems[1])
                                        self.addSplitViewItem(NSSplitViewItem(viewController: contentViewController))
        })
        contentViewController.book = book;
        oldShelf.prepare(for: segue, sender: user.self)
        segue.perform()
    }
}
