//
//  SourceListController.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class SourceListController: NSViewController {
@IBOutlet weak var collectionView: NSCollectionView!
    let imageDirectoryLoader = ImageDirectoryLoader()
    fileprivate func configureCollectionView() {
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
        collectionView.layer?.backgroundColor = NSColor.black.cgColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        let initialFolderUrl = URL(fileURLWithPath: "/Library/Desktop Pictures", isDirectory: true)
        imageDirectoryLoader.loadDataForFolderWithUrl(initialFolderUrl)
        configureCollectionView()
    }
    
        func loadDataForNewFolderWithUrl(_ folderURL: URL) {
        imageDirectoryLoader.loadDataForFolderWithUrl(folderURL)
    }
        // Do view setup here.
    }
    

extension SourceListController : NSCollectionViewDataSource {
    
    // 1
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return imageDirectoryLoader.numberOfSections
    }
    
    // 2
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDirectoryLoader.numberOfItemsInSection(section)
    }
    
    // 3
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        // 4
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        // 5
        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
        collectionViewItem.imageFile = imageFile
        return item
    }
    
}
