//
//  LibraryViewController.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ChapterCollectionViewController: NSViewController {
    
    
    @IBOutlet weak var chapterView: NSCollectionView!
    
    var chapters: [[String]] = [["Begin","0"],["climax","1"],["end","2"],["Extra","3"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension ChapterCollectionViewController : NSCollectionViewDataSource {
    

    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(chapters.count)")
        return chapters.count
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        
        var item =  chapterView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChapterItem"), for: indexPath)

        
        let chapter = chapters[indexPath[1]]
        
        item.textField!.stringValue = chapter[0]
        return item
    }
    
}





