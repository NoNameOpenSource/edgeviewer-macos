//
//  DetailViewController.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {
    
    var book: Book? = nil;
    
    //------------------------------------------------------------------------------------------------
    //MARK: Set up UI Outlets
    //------------------------------------------------------------------------------------------------
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var chapterView: NSCollectionView!
    @IBOutlet weak var ReadFromBeginningButton: NSButton!
    @IBOutlet weak var mangaTitle: NSTextField!
    @IBOutlet weak var mangaAuthor: NSTextField!
    @IBOutlet weak var mangaGenre: NSTextField!
    @IBOutlet weak var mangaReleaseDate: NSTextField!
    @IBOutlet var mangaImage: NSImageView!
    @IBOutlet weak var mangaProgress: NSProgressIndicator!
    
    //------------------------------------------------------------------------------------------------
    //MARK: Set up UI Actions
    //------------------------------------------------------------------------------------------------
    @IBAction func showReadFromBeginningButton(_ sender: Any) {
        ReadFromBeginningButton.isHidden = !ReadFromBeginningButton.isHidden
    }

    override func viewDidLoad() {
        guard let book = book else {
            print("bad book identifier")
            return
        }
        
        super.viewDidLoad()
        
        //------------------------------------------------------------------------------------------------
        //MARK: Write to UI based on properties in Manga Object
        //------------------------------------------------------------------------------------------------
        
        ratingControl.rating = Int(book.rating!)
        self.mangaTitle.stringValue = book.title
        self.mangaAuthor.stringValue = book.author!
        self.mangaGenre.stringValue = book.genre!
        
        // Date Formatting
        let localizedDateFormatter = DateFormatter()
        localizedDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        localizedDateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        localizedDateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        if let date = book.lastUpdated {
            self.mangaReleaseDate.stringValue = localizedDateFormatter.string(from: date)
        } else {
            print("date nil")
            mangaReleaseDate.stringValue = "Unknown Release Date"
        }
        
        self.mangaImage.image = book.coverImage
        self.mangaProgress.minValue = 0.0
        self.mangaProgress.maxValue = 1.0
        self.mangaProgress.doubleValue = book.progress
        configureCollectionView()
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Set up Basic Collection View UI Settings
    //------------------------------------------------------------------------------------------------
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
    //
    //
    
    // Returns the number of items in the section
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let book = book else {
            print("bad book identifier")
            return 0
        }
        guard let chapters = book.chapters else {
            print("bad book chapters data")
            return 0
        }
        return chapters.count
    }
    
    // Return an NSCollectionView item for a given path
    // Is called once for each item in the NSCollectionView
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
                
        // Instantiate an item from the ChapterViewItem nib
        let item = chapterView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChapterViewItem"), for: indexPath)
        
        guard item is ChapterViewItem else {
            print("ChapterViewItem not given by chapterView.makeItem")
            return item
        }
        guard let book = book else {
            print("bad book identifier")
            return item
        }
        guard let chapters = book.chapters else {
            print("book chapters data is bad")
            return item
        }
        
        // Set the textField and imageView of the current NSCollectionView item
        item.textField!.stringValue = chapters[indexPath.item].title
        item.imageView!.image = book.page(atIndex: chapters[indexPath.item].pageIndex)
        
        return item
    }
}
