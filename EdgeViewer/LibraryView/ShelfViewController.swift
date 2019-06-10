//
//  LibraryViewController.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ShelfViewController: NSViewController, DropViewDelegate {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var dropView: DropView!
    
    let sectionA: [Manga] = [Manga(title: "DummyA"), Manga(title: "DummyB"),Manga(title: "DummyC"), Manga(title: "DummyD"),Manga(title: "DummyD"),Manga(title: "DummyD"),Manga(title: "DummyD"),Manga(title: "DummyD"),Manga(title: "DummyD")]
    let sectionB: [Manga] = [Manga(title: "DummyC"), Manga(title: "DummyD")]
    var  sections: [[Manga]] = []
    
    var delegate: ShelfViewDelegate? = nil
    
    var libraryPage: LibraryPage? = nil
    
    @IBOutlet var bookMenu: NSMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let libraryPage = libraryPage {
            // prepare only when page available
            configureCollectionView()
            sections.append(sectionA)
            sections.append(sectionB)
        }
        
        collectionView.menu = bookMenu
        dropView.delegate = self
    }
   
    @IBAction func bookInfo(_ sender: NSMenuItem) {
        guard collectionView.selectionIndexPaths.count != 0 else { return }
        
        let indexPath = collectionView.selectionIndexPaths.first!
        let pageItem = libraryPage!.items[indexPath.item]
        guard pageItem.type == .book else { return }
        guard let book = pageItem.owner.book(withIdentifier: pageItem.identifier) else { return }
        let panelController = InfoWindowController(windowNibName: NSNib.Name(rawValue: "InfoWindowController"))
        panelController.book = book
        let panel = panelController.window!
        panel.level = .popUpMenu
        panel.isMovableByWindowBackground = true
        NSApplication.shared.runModal(for: panel)
    }
    
    fileprivate func configureCollectionView() { // this one makes layout
        let flowLayout = ShelfViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 140.0, height: 160.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.lightGray.cgColor
        if #available(OSX 10.12, *) {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        } else {
            // Fallback on earlier versions
        }
       
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDoubleClick item: NSCollectionViewItem) {
        if let delegate = delegate,
           let indexPath = collectionView.indexPath(for: item) {
            
            let pageItem = libraryPage!.items[indexPath.item]
            delegate.shelf(self, selectedItem: pageItem)
        }
    }
    
    func dropView(_: DropView, didRecieveBook newBook: LocalPluginBook) {
        if let delegate = delegate {
            delegate.shelf(self, didRecieveBook: newBook)
        }
    }
}

extension ShelfViewController : NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let libraryPage = libraryPage else {
            return 0
        }
        return libraryPage.items.count
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let casted = item as? CollectionViewItem else {
            return item
        }
        guard let libraryPage = libraryPage else {
            return item
        }
        
        let pageItem = libraryPage.items[indexPath.item]
        item.textField!.stringValue = pageItem.name
        //item.imageView!.image = NSImage(contentsOf: URL.init(string: pageItem.thumbnailURL!)!)
        /*
        if item.view.subviews.count == 3 {
            if let thumbnail = pageItem.thumbnail {
                item.view.replaceSubview(item.view.subviews[0], with: thumbnail)
            } else {
                item.view.subviews[0].removeFromSuperview()
            }
        } else {
            if let thumbnail = pageItem.thumbnail {
                item.view.addSubview(pageItem.thumbnail!, positioned: .below, relativeTo: item.view.subviews[0])
            }
        }
        */
        
        casted.thumbnail = pageItem.thumbnail
        
        //item.view.menu = bookMenu
        
        //if pageItem.thumbnail!.loaded == false { pageItem.thumbnail!.loadImage() }
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView,viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.SupplementaryElementKind.sectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderView"), for: indexPath) as? HeaderView
        view?.sectionTitle.stringValue = "Section \(indexPath.section)"
        let numberOfItemsInSection = self.sections[indexPath.section].count
        view?.imageCount.stringValue = "\(numberOfItemsInSection) image files"
        return view!
    }
}

extension ShelfViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        //return NSSize(width: 1000, height: 40)
        return NSSize(width: 1000, height: 0)
    }
}

extension ShelfViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    }
}


