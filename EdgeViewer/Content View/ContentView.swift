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
    var FirstPage = NSImage()
    var LastPage = NSImage()
    
    
    
    
    
    
    
    @IBOutlet weak var MangaView: Single_Page_Viewer!
    @IBOutlet weak var BackToDetail: NSButton!
    @IBOutlet weak var Chapter: NSButton!
    @IBOutlet weak var Zoom_minus: NSButton!
    @IBOutlet weak var Zoom_Plus: NSButton!
   
    @IBOutlet weak var BookMark: NSButton!
    @IBOutlet weak var Settings: NSButton!
    var ifdoublepage : Bool = false
    var Brightness : Float = 1.0
    
    let CurrentPic = NSImage(named: NSImage.Name(rawValue: "images"))
    
    @IBAction func ViewPrevious(_ sender: Any) {
        previousPage(Object: TestManga)    }
    @IBAction func ViewNext(_ sender: Any) {
        nextPage(Object : TestManga)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MangaView.image = NSImage(named: NSImage.Name(rawValue: "images"))
        TestManga.PageNumber = 3
        TestManga.Page.append(FirstPage)
        TestManga.Page.append(LastPage)
        TestManga.currentPage = 1
        print(TestManga.Page.count)
        print(TestManga.currentPage)
        
        // Do view setup here.
    }
    
    
    func nextPage(Object : Manga){
        Object.currentPage = Object.currentPage + 1
        if Object.currentPage <= Object.PageNumber {
            print("Loading page \(String(Object.currentPage)) of \(Object.title)")
        }else{
            print("It's the last Page of this chapter")
            Object.currentPage  -= 1
        }
    }
    
    func previousPage(Object : Manga){
        Object.currentPage = Object.currentPage - 1
        if Object.currentPage >= 1 {
            print("Loading page \(Object.currentPage) of \(Object.title)")
        }else{
            print("It's the first page of this chapter"	)
            Object.currentPage += 1
        }
    }
    func SwitchToDoublePage(){
        ifdoublepage = true
        updatePage()
    }
    
    func SettingBrightness(){}
    func updatePage(){
        
        
    }
   
    func BrightnessChange(_ Bright : Float){
        Brightness = Bright
    }
}
