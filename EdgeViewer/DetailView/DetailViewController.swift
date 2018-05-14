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
    let local: LocalPluginParser = LocalPluginParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Chapters in Dummy Manga Object
        
        if local.books.count == 0 {
            print("No books.")
            return
        }
        
        for i in 0 ..< local.books[0].chapters.count {
            local.books[0].chapters[i].coverImage = #imageLiteral(resourceName: "emptyStar")
            local.books[0].chapters[i].title = "\(i)"
        }
        
        // Write to UI based on properties in Manga Object
        ratingControl.rating = local.books[0].rating
        self.mangaTitle.stringValue = local.books[0].title
        self.mangaAuthor.stringValue = local.books[0].author
        self.mangaGenre.stringValue = local.books[0].genre
        let localizedDateFormatter = DateFormatter()
        localizedDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        localizedDateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        localizedDateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        if let date = local.books[0].releaseDate {
            self.mangaReleaseDate.stringValue = localizedDateFormatter.string(from: date)
        } else {
            print("date nil")
            mangaReleaseDate.stringValue = "Unknown Release Date"
        }
        
        self.mangaImage.image = local.books[0].coverImage
        self.mangaProgress.doubleValue = local.books[0].progress
        configureCollectionView()
        
        
        // MARK: Write to XML Document
        
        var xmlDoc: XMLDocument
        
        let applicationSupportDirectoryURL: URL? = getApplicationSupportDirectory()?.appendingPathComponent("EdgeViewer")
        
        // Create EdgeViewer directory in user's Application Support directory
        do {
            try FileManager.default.createDirectory(at: applicationSupportDirectoryURL!, withIntermediateDirectories: true)
        }
        catch {
            print("Could not create directory: \(error)")
        }
        
        if let xmlDocumentLocation: URL = applicationSupportDirectoryURL?.appendingPathComponent("LocalLibrary.xml") {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: xmlDocumentLocation.absoluteString) { // LocalLibrary.xml file exists
                // Get existing content from LocalLibrary.xml
                do {
                    xmlDoc = try XMLDocument(contentsOf: xmlDocumentLocation, options: XMLNode.Options())
                }
                catch {
                    print("Could not get XMLDocument object from XML file: \(error)")
                    return
                }
            } else { // LocalLibrary.xml file does not exist
                print("LocalLibrary.xml file did not exist and will be created.")
                xmlDoc = XMLDocument(rootElement: XMLElement(name: "books"))
            }
            
            // Set up XMLDocument element with new values
            var elements = [XMLNode]()
            let titleEl: XMLNode = XMLNode.element(withName: "title", stringValue: "My Great New Book") as! XMLNode
            elements.append(titleEl)
            let newBook: XMLNode = XMLNode.element(withName: "book", children: elements, attributes: [XMLNode]()) as! XMLNode
            xmlDoc.rootElement()?.addChild(newBook)
            let xmlDataString: Data = xmlDoc.xmlData
            
            // Write XMLDocument contents to LocalLibrary.xml (overwrites, doesn't append)
            do {
                try xmlDataString.write(to: xmlDocumentLocation)
            } catch {
                print(error)
            }
        }
        else { // if let xmlDocumentLocation
            print("Could not find EdgeViewer folder in ~/Library/ApplicationSupport directory")
        }
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
        if local.books.count == 0 {
            print("No books.")
            return 0
        }
        else {
            return local.books[0].chapters.count
        }
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
        item.textField!.stringValue = local.books[0].chapters[indexPath.item].title
        item.imageView!.image = local.books[0].chapters[indexPath.item].coverImage
        
        return item
    }
}
