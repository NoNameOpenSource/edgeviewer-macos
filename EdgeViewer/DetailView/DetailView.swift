//
//  DetailView.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class DetailView: NSViewController {
    
    @IBOutlet weak var ReadFromBeginningButton: NSButton!
    
    @IBAction func showReadFromBeginningButton(_ sender: Any) {
        print("pressed")
        ReadFromBeginningButton.isHidden = false
    }
    
    @IBOutlet weak var chapterView: NSCollectionView!
    
    var myManga : Manga = Manga(title: "The Best Manga")
    
    
    let sectionA: [Manga] = [Manga(title: "DummyA"), Manga(title: "DummyB")]
    var  sections: [[Manga]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = myManga.addNewChapters(howMany: 5) // there are now howMany + 1 chapters
        configureCollectionView()
        sections.append(sectionA)
        // Do view setup here.
    }
    
    
    
    private func configureCollectionView() {
        // 1
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        chapterView.collectionViewLayout = flowLayout
        // 2
        view.wantsLayer = true
        // 3
        chapterView.layer?.backgroundColor = NSColor.black.cgColor
    }
}

extension DetailView : NSCollectionViewDataSource {
    
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
        let item = chapterView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChapterViewItem"), for: indexPath)
        guard let chapterViewItem = item as? ChapterViewItem else {
            return item
        }
        
        let mangaChapter = myManga.chapters
        
        //item.textField!.stringValue = manga.title
        //item.imageView!.image = manga.coverImage
        
        return item
    }
    
}
