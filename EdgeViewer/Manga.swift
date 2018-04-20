//
//  Manga.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Manga {
    var chapters : [Chapter] = [Chapter()]
    
    var title: String = ""
    var author: String = ""
    var genre: String = ""
    var rating: Int = 0
    var releaseDate: String = ""
    var coverImage = NSImage()
    
    init(title: String) {
        self.title = title
        
    }
    
    func addNewPage(page: NSImage, chapterIndex : Int, pageIndex: Int?) {
        guard let pIndex = pageIndex else {
            self.chapters[chapterIndex].pages.append(page)
            return
        }
        self.chapters[chapterIndex].pages.insert(page, at: pIndex)
    }
    
    func addNewChapter() {
        chapters.append(Chapter())
    }
    
    func addNewChapters(howMany numNewChapters: Int) -> Int {
        for _ in 0..<numNewChapters {
            addNewChapter()
        }
        return chapters.count
    }
}



