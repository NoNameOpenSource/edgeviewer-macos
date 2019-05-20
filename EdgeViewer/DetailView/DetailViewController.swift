//
//  DetailViewController.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

protocol RatingControlDelegate {
    // allow RatingControl to tell DetailViewController when user has updated book's rating
    func updateRating(_: RatingControl, rating: Double)
}

protocol CoverImageDelegate {
    func segueToContentView(withBook book: Book)
}

class DetailViewController: NSViewController, RatingControlDelegate, CoverImageDelegate {
    
    var series: Series? = nil
    var books: [Book]?
    
    var delegate: DetailViewDelegate?
    
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
    @IBOutlet weak var coverImage: CoverImage!
    @IBOutlet weak var mangaProgress: NSProgressIndicator!
    
    //------------------------------------------------------------------------------------------------
    //MARK: Set up UI Actions
    //------------------------------------------------------------------------------------------------
    @IBAction func showReadFromBeginningButton(_ sender: Any) {
        ReadFromBeginningButton.isHidden = !ReadFromBeginningButton.isHidden
    }
    
    override func viewDidLoad() {
        ratingControl.ratingControlDelegate = self
        
        guard let series = series else {
            print("bad series identifier")
            return
        }
        
        super.viewDidLoad()
        
        //------------------------------------------------------------------------------------------------
        //MARK: Write to UI based on properties in Series Object
        //------------------------------------------------------------------------------------------------
        if let rating = series.rating {
            ratingControl.rating = Int(rating)
        } else {
            print("book rating nil")
        }
        self.mangaTitle.stringValue = series.title
        if let author = series.author {
            self.mangaAuthor.stringValue = author
        } else {
            print("series author nil")
        }
        if let genre = series.genre {
            self.mangaGenre.stringValue = genre
        } else {
            print("book genre nil")
        }
        // Date Formatting
        let localizedDateFormatter = DateFormatter()
        localizedDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        localizedDateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        localizedDateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        if let date = series.lastUpdated {
            self.mangaReleaseDate.stringValue = localizedDateFormatter.string(from: date)
        } else {
            print("date nil")
            mangaReleaseDate.stringValue = "Unknown Release Date"
        }
        self.coverImage.image = series.coverImage
        self.mangaProgress.minValue = 0.0
        self.mangaProgress.maxValue = 1.0
        self.mangaProgress.doubleValue = 0
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
    
    //------------------------------------------------------------------------------------------------
    //MARK: Update Rating Based on Information from RatingControl
    //------------------------------------------------------------------------------------------------
    func updateRating(_: RatingControl, rating: Double) {
        if let series = series {
            LocalPlugin.sharedInstance.update(rating: rating, ofSeries: series)
        } else {
            print("unable to update rating of nil book")
        }
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Segue to Content View (with book's currentPage updated according to pageIndex of chapter that user double-clicked)
    //------------------------------------------------------------------------------------------------
    func bookSegue(_ collectionView: NSCollectionView, didDoubleClick item: NSCollectionViewItem) {
        if series != nil {
            if let books = books {
                if let indexPath = collectionView.indexPath(for: item) {
                    let book = books[indexPath.item]
                    segueToContentView(withBook: book)
                } else {
                    print("unable to update book.currentPage: nil collectionView.indexPath(for: item")
                }
            } else {
                print("unable to update book.currentPage: nil book.chapters")
            }
        } else {
            print("unable to update book.currentPage: nil book")
        }
    }
    
    func segueToContentView(withBook book: Book) {
        if let delegate = delegate {
            if let series = series {
                delegate.detailView(self, selectedBook: book, fromSeries: series)
            } else {
                delegate.detailView(self, selectedBook: book)
            }
        } else {
            print("unable to segue to Content View: nil delegate")
        }
    }
}

extension DetailViewController : NSCollectionViewDataSource {
    
    // A single section is assumed
    //
    //
    
    // Returns the number of items in the section
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let series = series else {
            print("bad series")
            return 0
        }
        books = series.books
        guard let books = books else {
            print("bad books data")
            return 0
        }
        return books.count
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
        guard let books = books else {
            print("bad books array")
            return item
        }
        
        // Set the textField and imageView of the current NSCollectionView item
        item.textField!.stringValue = books[indexPath.item].title
        //item.imageView!.image = books[indexPath.item].page(atIndex: 0)
        
        return item
    }
}

extension DetailViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    }
}
