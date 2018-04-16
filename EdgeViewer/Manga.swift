//
//  Manga.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Manga {
    var chapters : [[NSImage]] = [[NSImage()]]
    
    var Author : String = ""
    var title : String = ""
    var rating : Int = 0
    
    let coverImage : NSImage
    
    init(title : String) {
        self.title = title
        self.coverImage = NSImage()
        self.coverImage.backgroundColor = NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }
    
    func addNewPage(page : NSImage, chapter : Int, index : Int?) {
        if (index == nil) { // index not given
            self.chapters[chapter].append(page)
        }
        else { // index given
            self.chapters[chapter].insert(page, at: index!)
        }
    }
    
    func addNewChapter() {
        chapters.append([NSImage()])
    }
    
    func addNewChapters(howMany numNewChapters: Int) -> Int {
        for _ in 0..<numNewChapters {
            addNewChapter()
        }
        return chapters.count
    }
}



