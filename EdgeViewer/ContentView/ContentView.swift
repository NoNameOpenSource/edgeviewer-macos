//
//  ContentView.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ContentView: NSViewController {
    
    var manga: Manga? = nil
    var pageView : PageView = PageView()
    
    @IBOutlet weak var MangaPage: NSView!
    @IBOutlet weak var BackToDetail: NSButton!
    @IBOutlet weak var PageNumberLabel: NSTextField!
    @IBOutlet weak var Chapter: NSButton!

   
    @IBOutlet weak var BookMark: NSButton!
    @IBOutlet weak var Settings: NSButton!
    var ifdoublepage : Bool = true
 
    var Brightness : Float = 1.0
    
    
    @IBAction func ViewPrevious(_ sender: Any) {
        previousPage(Object: manga!)    }
    @IBAction func ViewNext(_ sender: Any) {
        nextPage(Object : manga!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dummy Data for testing purpose
        let testManga = Manga(Title: "Pandora Heart")
        let pages: [NSImage?] = [NSImage(named:NSImage.Name(rawValue: "images")),
                                NSImage(named: NSImage.Name(rawValue: "first")),
                                NSImage(named: NSImage.Name(rawValue: "Last")),
                                NSImage(named: NSImage.Name(rawValue: "download"))]
        
        for page in pages {
            if let page = page {
                testManga.addNewPage(Pages: page)
                testManga.currentPage = 1
            }
        }
        
        manga = testManga
       
        updatePage()
        
        // Do view setup here.
    }
    
    // func used to change the view size when window size changed
    override func viewWillLayout() {
        PageNumberLabel.frame.origin = NSPoint(x: super.view.bounds.origin.x + super.view.bounds.width/2 - 33.0, y : super.view.bounds.origin.y)
        pageView.PageViewLayout()
        pageView.ContentViewLayout(manga: manga!, relatedView: MangaPage)
    }
    
    //go to next page
    func nextPage(Object : Manga){
        if ifdoublepage {
            Object.currentPage = Object.currentPage + 2
            if Object.currentPage <= Object.PageNumber {
                print("Loading page \(String(Object.currentPage)) of \(Object.title)")
            }else{
                print("It's the last Page of this chapter")
                Object.currentPage  -= 2
            }
        }else{
            Object.currentPage = Object.currentPage + 1
            if Object.currentPage <= Object.PageNumber {
                print("Loading page \(String(Object.currentPage)) of \(Object.title)")
            }else{
                print("It's the last Page of this chapter")
                Object.currentPage  -= 1
            }
        }
        updatePage()
    }
    
    // Go to previous page
    func previousPage(Object : Manga){
        if ifdoublepage {
            Object.currentPage = Object.currentPage - 2
            if Object.currentPage >= 1 {
                print("Loading page \(Object.currentPage) of \(Object.title)") // for now be console
            }else{
                print("It's the first page of this chapter"    )
                Object.currentPage += 2
            }
        }else{
            Object.currentPage = Object.currentPage - 1
            if Object.currentPage >= 1 {
                print("Loading page \(Object.currentPage) of \(Object.title)")
            }else{
                print("It's the first page of this chapter"    )
                Object.currentPage += 1
            }
        }
        updatePage()
    }
    
    
    // Switch View Size
    func SwitchPageview(){
        if ifdoublepage {
            ifdoublepage = false
        }else{
            ifdoublepage = true
        }
    }
    
    func definePageType(){
        if ifdoublepage {
            pageView = DoublePageView()
        }else{
            self.pageView = SingleePageView()
        }
    }
    
    func updatePage(){
        if manga!.currentPage == manga!.PageNumber{
            ifdoublepage = false
        }
        
        if ifdoublepage {
            PageNumberLabel.stringValue = "\(manga!.currentPage) & \(manga!.currentPage + 1) / \(manga!.PageNumber)"
        }else{
            PageNumberLabel.stringValue = "\(manga!.currentPage) / \(manga!.PageNumber)"
        }
        MangaPage.subviews.removeAll()
        definePageType()
        pageView.UpdatePage(manga: manga!, relate: MangaPage)
    }
    
}
