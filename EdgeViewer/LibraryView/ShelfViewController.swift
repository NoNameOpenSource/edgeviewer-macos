//
//  LibraryViewController.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ShelfViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    let sectionA: [Manga] = [Manga(Title: "DummyA"), Manga(Title: "DummyB")]
    let sectionB: [Manga] = [Manga(Title: "DummyC"), Manga(Title: "DummyD")]
    var  sections: [[Manga]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCollectionView()
        sections.append(sectionA)
        sections.append(sectionB)
    }
    
    fileprivate func configureCollectionView() { // this one makes layout
        // 1
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        // 2
        view.wantsLayer = true
        // 3
        collectionView.layer?.backgroundColor = NSColor.lightGray.cgColor
        if #available(OSX 10.12, *) {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        } else {
            // Fallback on earlier versions
        }
    }
}


extension ShelfViewController : NSCollectionViewDataSource {
    
    // 1
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.sections.count
    }
    
    // 2
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    // 3
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        // 4
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let _ = item as? CollectionViewItem else {
            return item
        }
        
        let manga = sections[indexPath[0]][indexPath[1]]
        
        item.textField!.stringValue = manga.title
        item.imageView!.image = manga.cover
        
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
        return NSSize(width: 1000, height: 40)
    }
}


