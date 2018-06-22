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
    func segueToContentView()
}

class DetailViewController: NSViewController, RatingControlDelegate, CoverImageDelegate {
    
    var book: Book? = nil
    var senderDelegate: LibraryViewController? = nil
    
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
    @IBAction func readButton(_ sender: NSButton) {
        segueToContentView()
    }
    
    override func viewDidLoad() {
        ratingControl.ratingControlDelegate = self
        
        guard let book = book else {
            print("bad book identifier")
            return
        }
        
        super.viewDidLoad()
        
        //------------------------------------------------------------------------------------------------
        //MARK: Write to UI based on properties in Manga Object
        //------------------------------------------------------------------------------------------------
        if let rating = book.rating {
            ratingControl.rating = Int(rating)
        } else {
            print("book rating nil")
        }
        self.mangaTitle.stringValue = book.title
        if let author = book.author {
            self.mangaAuthor.stringValue = author
        } else {
            print("book author nil")
        }
        if let genre = book.genre {
            self.mangaGenre.stringValue = genre
        } else {
            print("book genre nil")
        }
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
        self.coverImage.image = book.coverImage
        self.coverImage.delegate = self
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
    
    //------------------------------------------------------------------------------------------------
    //MARK: Update Rating Based on Information from RatingControl
    //------------------------------------------------------------------------------------------------
    func updateRating(_: RatingControl, rating: Double) {
        if let book = book {
            LocalPlugin.sharedInstance.update(rating: rating, ofBook: book)
        } else {
            print("unable to update rating of nil book")
        }
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Segue to Content View (with book's currentPage updated according to pageIndex of chapter that user double-clicked)
    //------------------------------------------------------------------------------------------------
    func chapterSegue(_ collectionView: NSCollectionView, didDoubleClick item: NSCollectionViewItem) {
        if let book = book {
            if let chapters = book.chapters {
                if let indexPath = collectionView.indexPath(for: item) {
                    let chapter = chapters[indexPath.item]
                    book.currentPage = chapter.pageIndex
                } else {
                    print("unable to update book.currentPage: nil collectionView.indexPath(for: item")
                }
            } else {
                print("unable to update book.currentPage: nil book.chapters")
            }
        } else {
            print("unable to update book.currentPage: nil book")
        }
        segueToContentView()
    }
    
    func segueToContentView() {
        if let book = book {
            if let senderDelegate = senderDelegate {
                senderDelegate.segueToContentView(withBook: book)
            } else {
                print("unable to segue to Content View: nil senderDelegate")
            }
        } else {
            print("unable to segue to Content View: nil book")
        }
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

extension DetailViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    }
}
