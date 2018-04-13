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
    
    var SinglePageView : NSImageView = NSImageView()
    var LeftPage : NSImageView = NSImageView()
    var RightPage : NSImageView = NSImageView()
    
    @IBOutlet weak var ContenView: Page_View!
    
    @IBOutlet weak var BackToDetail: NSButton!
    
    @IBOutlet weak var PageNumberLabel: NSTextField!
    @IBOutlet weak var Chapter: NSButton!
    @IBOutlet weak var Zoom_minus: NSButton!
    @IBOutlet weak var Zoom_Plus: NSButton!
   
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
       
        updatePage(manga: TestManga)
        // Do view setup here.
    }
    
    override func viewWillLayout() {
        layoutSingPageView()
    }
    
    func layoutSingPageView() {
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
            var SizesRatio = TestManga.Page[TestManga.currentPage - 1].size.height/TestManga.Page[TestManga.currentPage - 1].size.width
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
   
    
    
    func nextPage(Object : Manga){
        if ifdoublepage {
            Object.currentPage = Object.currentPage + 2
            if Object.currentPage <= Object.PageNumber {
                print("Loading page \(String(Object.currentPage)) of \(Object.title)")
            }else{
                print("It's the last Page of this chapter")
                Object.currentPage  -= 2
            }
            updatePage(manga: Object)
        }else{
            Object.currentPage = Object.currentPage + 1
            if Object.currentPage <= Object.PageNumber {
                print("Loading page \(String(Object.currentPage)) of \(Object.title)")
            }else{
                print("It's the last Page of this chapter")
                Object.currentPage  -= 1
            }
            updatePage(manga: Object)
        }
        
        
    }
    
    func previousPage(Object : Manga){
        if ifdoublepage {
            Object.currentPage = Object.currentPage - 2
            if Object.currentPage >= 1 {
                print("Loading page \(Object.currentPage) of \(Object.title)")
            }else{
                print("It's the first page of this chapter"    )
                Object.currentPage += 2
            }
            updatePage(manga: Object)
        }else{
            Object.currentPage = Object.currentPage - 1
            if Object.currentPage >= 1 {
                print("Loading page \(Object.currentPage) of \(Object.title)")
            }else{
                print("It's the first page of this chapter"    )
                Object.currentPage += 1
            }
            updatePage(manga: Object)
        }
        
        
    }
    func SwitchPageview(){
        ifdoublepage = true
        updatePage(manga: TestManga)
    }
    
    func SettingBrightness(){}
    func updatePage(manga : Manga) {
  //      if let image = mana.grabPage(pageNumber: self.currentPage)
    //        self.pageImageView.image = image
      //  else
        //    image was nil, so next page does not exist, thus //play beep and do not change page
        PageNumberLabel.stringValue = "\(manga.currentPage)/\(manga.PageNumber)"

        ContenView.subviews[0].subviews.removeAll()
        if manga.currentPage == manga.PageNumber{
            ifdoublepage = false
        }
        if ifdoublepage{
            let NextLeftPage : NSImageView = LeftPage
            let NextRightPage :NSImageView = RightPage
            
            NextLeftPage.image = manga.grabPage()
            NextRightPage.image = manga.grabRightPage()
            
            LeftPage = NextLeftPage
            RightPage = NextRightPage
            
            ContenView.subviews[0].addSubview(LeftPage)
            ContenView.subviews[0].addSubview(RightPage)
            
        }else{

            let NextPageView : NSImageView = SinglePageView
            NextPageView.image = manga.grabPage()
            SinglePageView = NextPageView
            ContenView.subviews[0].addSubview(SinglePageView)
        }
        

        layoutSingPageView()
    }
//    func initializer() {
 //       pageView = PageView(type: .doublePage, withLeftImage: //////NSIMageObject, andRightImage: NSImageObject)
     //   destroyOldOne
    //}
}
