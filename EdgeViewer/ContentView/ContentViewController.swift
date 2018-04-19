//
//  ContentView.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

enum ViewType {
    case singlePage
    case doublePage
    case verticalScroll
}

class ContentViewController: NSViewController {
    
    var manga: Manga? = nil
    var pageView: PageView = PageView()
    
    var currentPage = 0
    
    @IBOutlet weak var mangaPage: NSView!
    @IBOutlet weak var backToDetail: NSButton!
    @IBOutlet weak var pageNumberLabel: NSTextField!
    @IBOutlet weak var chapter: NSButton!

   
    @IBOutlet weak var bookMark: NSButton!
    @IBOutlet weak var settings: NSButton!
    var viewType: ViewType = .singlePage
 
    var brightness: Float = 1.0
    
    
    @IBAction func viewPrevious(_ sender: Any) {
        previousPage(object: manga!)    }
    @IBAction func viewNext(_ sender: Any) {
        nextPage(object : manga!)
    }
    
    func setUpDummyData() {
        let testManga = Manga(title: "Pandora Heart")
        let pages: [NSImage?] = [NSImage(named: NSImage.Name(rawValue: "images")),
                                 NSImage(named: NSImage.Name(rawValue: "first")),
                                 NSImage(named: NSImage.Name(rawValue: "Last")),
                                 NSImage(named: NSImage.Name(rawValue: "download"))]
        
        for page in pages {
            if let page = page {
                testManga.addNewPage(Pages: page)
            }
        }
        self.currentPage = 1
        
        manga = testManga
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dummy Data for testing purpose
        setUpDummyData()
       
        updatePage()
        
        // Do view setup here.
    }
    
    // func used to change the view size when window size changed
    override func viewWillLayout() {
        pageNumberLabel.frame.origin = NSPoint(x: super.view.bounds.origin.x + super.view.bounds.width/2 - 33.0, y : super.view.bounds.origin.y)
        pageView.pageViewLayout()
        pageView.contentViewLayout(manga: manga!, relatedView: mangaPage)
    }
    
    //go to next page
    func nextPage(object : Manga){
        if self.viewType == .doublePage {
            self.currentPage = object.currentPage + 2
            if self.currentPage <= object.numberOfPages {
                print("Loading page \(String(self.currentPage)) of \(object.title)")
            }else{
                print("It's the last Page of this chapter")
                self.currentPage  -= 2
            }
        }else{
            self.currentPage = object.currentPage + 1
            if self.currentPage <= object.numberOfPages {
                print("Loading page \(String(self.currentPage)) of \(object.title)")
            }else{
                print("It's the last Page of this chapter")
                self.currentPage  -= 1
            }
        }
        updatePage()
    }
    
    // Go to previous page
    func previousPage(object : Manga){
        if self.viewType == .doublePage {
            self.currentPage = object.currentPage - 2
            if self.currentPage >= 1 {
                print("Loading page \(self.currentPage) of \(object.title)") // for now be console
            }else{
                print("It's the first page of this chapter"    )
                self.currentPage += 2
            }
        }else{
            self.currentPage = self.currentPage - 1
            if self.currentPage >= 1 {
                print("Loading page \(self.currentPage) of \(object.title)")
            }else{
                print("It's the first page of this chapter"    )
                self.currentPage += 1
            }
        }
        updatePage()
    }
    
    
    // Switch View Size
    func switchPageview(){
        switch self.viewType {
            case .singlePage:
                self.viewType = .doublePage
            default:
                self.viewType = .singlePage
        }
    }
    
    func definePageType(){
        if self.viewType == .doublePage {
            pageView = DoublePageView()
        }else{
            self.pageView = SinglePageView()
        }
    }
    
    func updatePage(){
        if manga!.currentPage == manga!.numberOfPages{
            self.viewType = .singlePage
        }
        
        pageNumberLabel.stringValue = "\(manga!.currentPage) / \(manga!.numberOfPages)"
        
        mangaPage.subviews.removeAll()
        definePageType()
        pageView.updatePage(manga: manga!, relate: mangaPage)
    }
    
}
