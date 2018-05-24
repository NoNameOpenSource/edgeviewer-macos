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
    
    // Create a Local Library Based on XML Parser
    let local: LocalPluginXMLParser = LocalPluginXMLParser()
    lazy var book = local.book
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set up Chapters in Dummy Manga Object
        
        
        
        for i in 0 ..< book.chapters.count {
            book.chapters[i].pageIndex = i * 2
            book.chapters[i].title = "\(i)"
        }
        
        // Write to UI based on properties in Manga Object
        ratingControl.rating = Int(book.rating)
        self.mangaTitle.stringValue = book.title
        self.mangaAuthor.stringValue = book.author
        self.mangaGenre.stringValue = book.genre
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
        self.mangaProgress.doubleValue = book.progress
        configureCollectionView()
        
        var newBook = Book(id: 5)
        newBook.title = "New Book"
        newBook.author = "Shelly"
        newBook.release = 3
        newBook.series = 1
        newBook.seriesName = "Special Series Name"
        newBook.numPages = 8
        newBook.bookmark = 2
        let chapters = [Chapter(title: "First Chapter", pageIndex: 0),
                        Chapter(title: "Second Chapter", pageIndex: 3),
                        Chapter(title: "Third Chapter", pageIndex: 8)]
        newBook.bookmark = 3
        newBook.chapters = chapters
        newBook.genre = "Romance"
        newBook.currentPage = 0
        newBook.numPages = 9
        newBook.rating = 4
        let newDateString = "1996-12-19T16:39:57-00:00"
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let time = RFC3339DateFormatter.date(from: newDateString) {
            newBook.lastUpdated = time
        }
        else {
            print("Unable to retrieve date. Check formatting of date string.")
            newBook.lastUpdated = nil
        }
        newBook.coverImage = #imageLiteral(resourceName: "emptyStar")
        newBook.type = .manga
        
        // MARK: Write to XML Document
        var _ = LocalPluginXMLStorer(book: newBook)
        
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
        return book.chapters.count
    }
    
    // Return an NSCollectionView item for a given path
    // Is called once for each item in the NSCollectionView
    // Don't need to check for "No books" because this should only run when there are more than 0 items
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
                
        // Instantiate an item from the ChapterViewItem nib
        let item = chapterView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChapterViewItem"), for: indexPath)
        guard item is ChapterViewItem else {
            return item
        }
        
        // Set the textField and imageView of the current NSCollectionView item
        item.textField!.stringValue = book.chapters[indexPath.item].title
        // item.imageView!.image = local.books[0].chapters[indexPath.item].pageIndex
        
        return item
    }
}
