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
    var plugins: [Plugin] = [Plugin]()
    var navigation: [Any] = Array()

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
        
        plugins.append(LocalPlugin.sharedInstance)
        loadPlugins()
        segue(toPage: plugins[0].homePage)
    }
    
    func loadPlugins() {
        guard let pluginDirectory = LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Plugins") else { return }
        do {
            let fileManager = FileManager.default
            let pluginFolders = try fileManager.contentsOfDirectory(at: pluginDirectory, includingPropertiesForKeys: nil, options: [])
            for (pluginFolder) in pluginFolders {
                if fileManager.fileExists(atPath: pluginFolder.path + "/plugin.js") {
                    let plugin = JSPlugin(folder: pluginFolder)
                    plugins.append(plugin)
                }
            }
        }
        catch {
            print("could not get contents of \(pluginDirectory.absoluteString)")
            return
        }
    }
    
    func shelf(_: ShelfViewController, selectedItem pageItem: PageItem) {
        switch pageItem.type {
        case .book:
            segueToDetailView(withSeries: pageItem.content as! Series)
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
        navigation.append(page)
    }
    
    func segueToDetailView(withSeries series: Series) {
        let detailViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DetailViewController")) as! DetailViewController
        let oldShelf = self.splitViewItems[1].viewController
        let segue = NSStoryboardSegue(identifier: NSStoryboardSegue.Identifier(rawValue: "LibraryPageSegue"),
                                      source: oldShelf,
                                      destination: detailViewController,
                                      performHandler: {
                                        self.removeSplitViewItem(self.splitViewItems[1])
                                        self.addSplitViewItem(NSSplitViewItem(viewController: detailViewController))
        })
        detailViewController.senderDelegate = self
        detailViewController.series = series;
        oldShelf.prepare(for: segue, sender: user.self)
        segue.perform()
        navigation.append(series)
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
        navigation.append(book)
        
        
    }
    
    // return to previous view deleting the last element in array
    func navig () {
        navigation.removeLast()
        switch(navigation.popLast()) {
        case let series as Series:
            segueToDetailView(withSeries: series)

        case let page as LibraryPage:
            segue(toPage: page)
        default:
            break
        }
    }
}
