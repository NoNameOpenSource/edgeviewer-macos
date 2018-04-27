//
//  DetailViewController.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {
    
    // Set up UI Outlets
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var chapterView: NSCollectionView!
    @IBOutlet weak var ReadFromBeginningButton: NSButton!
    
    @IBOutlet weak var mangaTitle: NSTextField!
    @IBOutlet weak var mangaAuthor: NSTextField!
    @IBOutlet weak var mangaGenre: NSTextField!
    @IBOutlet weak var mangaReleaseDate: NSTextField!
    @IBOutlet var mangaImage: NSImageView!
    @IBOutlet weak var mangaProgress: NSProgressIndicator!
    
    // Set up UI Action
    @IBAction func showReadFromBeginningButton(_ sender: Any) {
        ReadFromBeginningButton.isHidden = !ReadFromBeginningButton.isHidden
    }
    
    // Create a Dummy Manga Object
    var myManga : Manga = Manga(title: "The Best Manga")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = myManga.addNewChapters(howMany: 2) // there are now howMany + 1 chapters
        
        // Set up properties in Dummy Manga Object
        myManga.rating = 3
        myManga.author = "Steven"
        myManga.genre = "Mystery"
        myManga.releaseDate = "May 5, 2000"
        myManga.coverImage = #imageLiteral(resourceName: "highlightedStar")
        myManga.progress = 50
        
        // Set up Chapters in Dummy Manga Object
        for i in 0 ..< myManga.chapters.count {
            myManga.chapters[i].coverImage = #imageLiteral(resourceName: "emptyStar")
            myManga.chapters[i].title = "\(i)"
        }
        
        // Write to UI based on properties in Manga Object
        ratingControl.rating = myManga.rating
        self.mangaTitle.stringValue = myManga.title
        self.mangaAuthor.stringValue = myManga.author
        self.mangaGenre.stringValue = myManga.genre
        self.mangaReleaseDate.stringValue = myManga.releaseDate
        self.mangaImage.image = myManga.coverImage
        self.mangaProgress.doubleValue = myManga.progress
                
        configureCollectionView()
    }
    
    
    // Set up Basic Collection View UI Settings
    private func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 100.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        flowLayout.scrollDirection = NSCollectionView.ScrollDirection.horizontal
        chapterView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        chapterView.layer?.backgroundColor = NSColor.black.cgColor
    }
}

extension DetailViewController : NSCollectionViewDataSource {
    
    // A single section is assumed
    
    // Returns the number of items in the section
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return myManga.chapters.count
    }
    
    // Return an NSCollectionView item for a given path
    // Is called once for each item in the NSCollectionView
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
                
        // Instantiate an item from the ChapterViewItem nib
        let item = chapterView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChapterViewItem"), for: indexPath)
        guard item is ChapterViewItem else {
            return item
        }
        
        // Set the textField and imageView of the current NSCollectionView item
        item.textField!.stringValue = myManga.chapters[indexPath.item].title
        item.imageView!.image = myManga.chapters[indexPath.item].coverImage
        
        return item
    }
}
