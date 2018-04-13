//
//  ContentView.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ContentView: NSViewController {

    //faked data
    var TestManga = Manga(Title : "Pandora Heart")
    var CoverPage = NSImage(named:NSImage.Name(rawValue: "images"))
    var FirstPage = NSImage(named: NSImage.Name(rawValue: "first"))
    var LastPage = NSImage(named: NSImage.Name(rawValue: "Last"))
    var FinalPage = NSImage(named: NSImage.Name(rawValue: "download"))
    
    
    // main
    
    // Programmatical Page viewer
    var SinglePageView : NSImageView = NSImageView()
    var LeftPage : NSImageView = NSImageView()
    var RightPage : NSImageView = NSImageView()
    
    var Page_ : Page = Page()
    //StoryBoard View
    
    @IBOutlet weak var MangaPage: NSView!
    @IBOutlet weak var MangaView: Page_View!
    
    @IBOutlet weak var BackToDetail: NSButton!
    
    @IBOutlet weak var PageNumberLabel: NSTextField!
    @IBOutlet weak var Chapter: NSButton!

   
    @IBOutlet weak var BookMark: NSButton!
    @IBOutlet weak var Settings: NSButton!
    var ifdoublepage : Bool = true
    var Brightness : Float = 1.0
    
    
    @IBAction func ViewPrevious(_ sender: Any) {
        previousPage(Object: TestManga)    }
    @IBAction func ViewNext(_ sender: Any) {
        nextPage(Object : TestManga)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        TestManga.addNewPage(Pages: CoverPage!)
        TestManga.addNewPage(Pages: FirstPage!)
        TestManga.addNewPage(Pages: LastPage!)
        TestManga.addNewPage(Pages: FinalPage!)
        TestManga.addNewPage(Pages: TestManga.emptyPage)
        TestManga.currentPage = 1
       
        if ifdoublepage{
            Page_ = SinglePage()
        }
        Page_.ContentViewLayout(manga: TestManga, relatedView: MangaPage)
        Page_.UpdatePage(manga: TestManga, relate: MangaPage)
        
        // Do view setup here.
    }
    
    // func used to change the view size when window size changed
    override func viewWillLayout() {
        Page_.PageViewLayout()
        Page_.ContentViewLayout(manga: TestManga, relatedView: MangaPage)
    }
    
    
    // function used to set the image size inside view base on the page size and view type
/*    func layoutSingPageView() {
        print(PageNumberLabel.bounds.size)
        PageNumberLabel.frame.origin = NSPoint(x: super.view.bounds.origin.x + super.view.bounds.width/2 - 33.0, y : super.view.bounds.origin.y)
        if ifdoublepage{
            let LeftSizesRatio = TestManga.Page[TestManga.currentPage - 1].size.height/TestManga.Page[TestManga.currentPage - 1].size.width
            let RightSizesRatio = TestManga.Page[TestManga.currentPage].size.height/TestManga.Page[TestManga.currentPage].size.width
            let LeftPageSize : NSSize = NSSize(width: self.view.bounds.width/2, height: self.view.bounds.height)
            let RightPageSize : NSSize = NSSize(width: self.view.bounds.width/2, height: self.view.bounds.height)
            let RightPageOrigin : NSPoint = NSPoint(x: self.view.bounds.origin.x + LeftPageSize.width, y: self.view.bounds.origin.y)
            LeftPage.setFrameSize(LeftPageSize)
            LeftPage.setFrameOrigin(self.view.bounds.origin)
            RightPage.setFrameOrigin(RightPageOrigin)
            RightPage.setFrameSize(RightPageSize)
            
            if LeftSizesRatio < 1 {
                LeftPage.image?.size.width = LeftPage.frame.size.width
                LeftPage.image?.size.height = LeftPage.frame.size.width * LeftSizesRatio
            }else{
                LeftPage.image?.size.height = LeftPage.frame.size.height
                LeftPage.image?.size.width = LeftPage.frame.size.height / LeftSizesRatio
            }
            
            if RightSizesRatio  < 1 {
                RightPage.image?.size.width = RightPage.frame.size.width
                RightPage.image?.size.height = RightPage.frame.size.width * RightSizesRatio
            }else{
                RightPage.image?.size.height = RightPage.frame.size.height
                    RightPage.image?.size.width = RightPage.frame.size.height / RightSizesRatio
            }
            
            
        }else{
            let SizesRatio = TestManga.Page[TestManga.currentPage - 1].size.height/TestManga.Page[TestManga.currentPage - 1].size.width
            SinglePageView.setFrameSize(self.view.bounds.size)
            SinglePageView.setFrameOrigin(self.view.bounds.origin)
            if SizesRatio >= 1{
                SinglePageView.image?.size.height = SinglePageView.frame.size.height
                SinglePageView.image?.size.width = SinglePageView.frame.size.height / SizesRatio
            }else{
                SinglePageView.image?.size.width = SinglePageView.frame.size.width
                SinglePageView.image?.size.height = SinglePageView.frame.size.width * SizesRatio
            }
        }
        
    }
   
*/
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
    }
    
    
    // Switch View Size
    func SwitchPageview(){
        if ifdoublepage {
            ifdoublepage = false
        }else{
            ifdoublepage = true
        }
    }
    
    // Update the page
/*    func updatePage(manga : Manga) {
        if manga.currentPage == manga.PageNumber{
            ifdoublepage = false
        }
        if ifdoublepage {
            PageNumberLabel.stringValue = "\(manga.currentPage) & \(manga.currentPage + 1) / \(manga.PageNumber)"
        }else{
            PageNumberLabel.stringValue = "\(manga.currentPage) / \(manga.PageNumber)"
        }

        if ifdoublepage{
            let NextLeftPage : NSImageView = LeftPage
            let NextRightPage :NSImageView = RightPage
        
            NextLeftPage.image = manga.grabPage()
            NextRightPage.image = manga.grabRightPage()
            
            MangaPage.subviews.removeAll()
            LeftPage = NextLeftPage
            RightPage = NextRightPage
            
            MangaPage.addSubview(LeftPage)
            MangaPage.addSubview(RightPage)
            
        }else{

            let NextPageView : NSImageView = SinglePageView
     
            NextPageView.image = manga.grabPage()
            SinglePageView = NextPageView
            MangaPage.subviews.removeAll()
            MangaPage.addSubview(SinglePageView)
        }
        

        layoutSingPageView()
    }
     */
}
