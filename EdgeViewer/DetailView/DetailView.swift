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
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBAction func showReadFromBeginningButton(_ sender: Any) {
        print("pressed")
        ReadFromBeginningButton.isHidden = false
    }
    
    @IBOutlet weak var chapterView: NSCollectionView!
    
    var myManga : Manga = Manga(title: "The Best Manga")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = myManga.addNewChapters(howMany: 4) // there are now howMany + 1 chapters
        for i in 0..<myManga.chapters.count {
            myManga.chapters[i].coverImage = #imageLiteral(resourceName: "emptyStar")
            myManga.chapters[i].title = "\(i)"
        }
        myManga.rating = 3
        configureCollectionView()
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
        return 1
    }
    
    // 2
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return myManga.chapters.count
    }
    
    // 3
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
                
        // 4
        let item = chapterView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChapterViewItem"), for: indexPath)
        guard let chapterViewItem = item as? ChapterViewItem else {
            return item
        }
        
        item.textField!.stringValue = myManga.chapters[indexPath.item].title
        item.imageView!.image = myManga.chapters[indexPath.item].coverImage
        
        return item
    }
}
