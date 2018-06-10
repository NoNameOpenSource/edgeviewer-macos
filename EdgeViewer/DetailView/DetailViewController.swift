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
    let local = LocalPluginXMLParser(identifier: )
    lazy var book = local.book
    
    
    
    override func viewDidLoad() {
        LocalPluginXMLStorer.storeBookData(ofBook: book)
        super.viewDidLoad()
        
        // Set up Chapters in Dummy Manga Object
        
//        for i in 0 ..< book.chapters!.count {
//            book.chapters![i].title = "\(i)"
//        }
        
        // Write to UI based on properties in Manga Object
        ratingControl.rating = Int(book.rating!)
        self.mangaTitle.stringValue = book.title
        self.mangaAuthor.stringValue = book.author!
        self.mangaGenre.stringValue = book.genre!
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
        
        
        
        
        
//        // MARK: Read Images
//        let bookImageDirectory: URL? = LocalPlugin.getApplicationSupportDirectory()?.appendingPathComponent("EdgeViewer/Books/\(book.title)/Images")
//        do {
//            try FileManager.default.createDirectory(at: bookImageDirectory!, withIntermediateDirectories: true)
//        }
//        catch {
//            print("Could not create directory: \(error)")
//        }
//
//        let bookImageDirectoryString = bookImageDirectory?.absoluteString
//
//        var imagesOfPages = [NSImage]()
//        let fileManager = FileManager.default
//        do {
//            let filePaths = try fileManager.contentsOfDirectory(at: bookImageDirectory!, includingPropertiesForKeys: [localizedNameKey], options: [])
//            for filePath in filePaths {
//                do {
//                    NSURL.get
//                    try print("filename: \(filePath.getResourceValue(forKeys: kCFURLNameKey) as NSString))")
//                }
//                catch {
//                    print("Could not get resourceValue kCFURLNameKey")
//                }
//
//                imagesOfPages.append(NSImage(contentsOf: filePath)!)
//            }
//        }
//        catch {
//            print("could not get file paths from \(bookImageDirectoryString ?? "") directory: \(error)")
//        }
//        print(imagesOfPages)
        LocalPlugin.sharedInstance.page(ofBook: book, pageNumber: 5)
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
    
    private func getApplicationSupportDirectory() -> NSURL? {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        if paths.count >= 1 {
            return NSURL(fileURLWithPath: paths[0], isDirectory: true)
        }
        print("Could not find application support directory.")
        return nil
    }
}

extension DetailViewController : NSCollectionViewDataSource {
    
    // A single section is assumed
    
    // Returns the number of items in the section
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: get number of books in Local Library
        return 1
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
        item.textField!.stringValue = book.chapters![indexPath.item].title
        //item.imageView!.image = book.chapters[indexPath.item].coverImage
        
        return item
    }
}
