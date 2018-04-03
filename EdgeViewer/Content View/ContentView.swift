//
//  ContentView.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ContentView: NSViewController {

    @IBOutlet weak var BackToDetail: NSButton!
    @IBOutlet weak var Chapter: NSButton!
    @IBOutlet weak var Zoom_minus: NSButton!
    @IBOutlet weak var Zoom_Plus: NSButton!
    @IBOutlet weak var Previous: NSButton!
    @IBOutlet weak var Next: NSButtonCell!
    @IBOutlet weak var BookMark: NSButton!
    @IBOutlet weak var Settings: NSButton!
    var Currentpage : Int = 1
    var ifdoublepage : Bool = false
    var Brightness : Float = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    
    func nextPage(_ Manga : Manga, Page : Int){
        Currentpage = Currentpage + 1
        if Currentpage <= Manga.PageNumber {
            print("Loading page \(String(Currentpage)) of \(Manga.title)")
        }else{
            print("It's the last Page of this chapter")
        }
    }
    
    func previousPage(_ Manga: Manga, Page : Int){
        Currentpage = Currentpage - 1
        if Currentpage >= 1 {
            print("Loading page \(Currentpage) of \(Manga.title)")
        }else{
            print("It's the first page of this chapter"	)
        }
    }
    
    func updatePage(){
        
    }
   
    func BrightnessChange(){}
}
