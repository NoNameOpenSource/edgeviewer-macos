//
//  DoublePage.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class DoublePageView: PageView {
    var firstPage : NSImageView = NSImageView()
    var secondPage : NSImageView = NSImageView()
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func contentViewLayout(manga: Manga, relatedView: NSView) {
        let leftSizesRatio = manga.page[manga.currentPage - 1].size.height/manga.page[manga.currentPage - 1].size.width
        let rightSizesRatio = manga.page[manga.currentPage].size.height/manga.page[manga.currentPage].size.width
        let firstPageSize : NSSize = NSSize(width: relatedView.bounds.width/2, height: relatedView.bounds.height)
        let secondPageSize : NSSize = NSSize(width: relatedView.bounds.width/2, height: relatedView.bounds.height)
        let secondPageOrigin : NSPoint = NSPoint(x: relatedView.bounds.origin.x + firstPageSize.width, y: relatedView.bounds.origin.y)
        firstPage.setFrameSize(firstPageSize)
        firstPage.setFrameOrigin(relatedView.bounds.origin)
        secondPage.setFrameOrigin(secondPageOrigin)
        secondPage.setFrameSize(secondPageSize)
        
        if leftSizesRatio < 1 {
            firstPage.image?.size.width = firstPage.frame.size.width
            firstPage.image?.size.height = firstPage.frame.size.width * leftSizesRatio
        }else{
            firstPage.image?.size.height = firstPage.frame.size.height
            firstPage.image?.size.width = firstPage.frame.size.height / leftSizesRatio
        }
        
        if rightSizesRatio  < 1 {
            secondPage.image?.size.width = secondPage.frame.size.width
            secondPage.image?.size.height = secondPage.frame.size.width * rightSizesRatio
        }else{
            secondPage.image?.size.height = secondPage.frame.size.height
            secondPage.image?.size.width = secondPage.frame.size.height / rightSizesRatio
        }
    }
    
    override func updatePage(manga: Manga, relate: NSView) {
        let NextFirstPage : NSImageView = firstPage
        let NextSecondPage :NSImageView = secondPage
        
        NextFirstPage.image = manga.grabPage()
        NextSecondPage.image = manga.grabRightPage()
        
        relate.subviews.removeAll()
        firstPage = NextFirstPage
        secondPage = NextSecondPage
        
        relate.addSubview(firstPage)
        relate.addSubview(secondPage)
        
        self.contentViewLayout(manga: manga,relatedView: relate)
    }
}
