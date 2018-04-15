//
//  DoublePage.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class DoublePageView: PageView {
    var FirstPage : NSImageView = NSImageView()
    var SecondPage : NSImageView = NSImageView()
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func ContentViewLayout(manga: Manga, relatedView: NSView) {
        let LeftSizesRatio = manga.Page[manga.currentPage - 1].size.height/manga.Page[manga.currentPage - 1].size.width
        let RightSizesRatio = manga.Page[manga.currentPage].size.height/manga.Page[manga.currentPage].size.width
        let FirstPageSize : NSSize = NSSize(width: relatedView.bounds.width/2, height: relatedView.bounds.height)
        let SecondPageSize : NSSize = NSSize(width: relatedView.bounds.width/2, height: relatedView.bounds.height)
        let SecondPageOrigin : NSPoint = NSPoint(x: relatedView.bounds.origin.x + FirstPageSize.width, y: relatedView.bounds.origin.y)
        FirstPage.setFrameSize(FirstPageSize)
        FirstPage.setFrameOrigin(relatedView.bounds.origin)
        SecondPage.setFrameOrigin(SecondPageOrigin)
        SecondPage.setFrameSize(SecondPageSize)
        
        if LeftSizesRatio < 1 {
            FirstPage.image?.size.width = FirstPage.frame.size.width
            FirstPage.image?.size.height = FirstPage.frame.size.width * LeftSizesRatio
        }else{
            FirstPage.image?.size.height = FirstPage.frame.size.height
            FirstPage.image?.size.width = FirstPage.frame.size.height / LeftSizesRatio
        }
        
        if RightSizesRatio  < 1 {
            SecondPage.image?.size.width = SecondPage.frame.size.width
            SecondPage.image?.size.height = SecondPage.frame.size.width * RightSizesRatio
        }else{
            SecondPage.image?.size.height = SecondPage.frame.size.height
            SecondPage.image?.size.width = SecondPage.frame.size.height / RightSizesRatio
        }
    }
    
    override func UpdatePage(manga: Manga, relate: NSView) {
        let NextFirstPage : NSImageView = FirstPage
        let NextSecondPage :NSImageView = SecondPage
        
        NextFirstPage.image = manga.grabPage()
        NextSecondPage.image = manga.grabRightPage()
        
        relate.subviews.removeAll()
        FirstPage = NextFirstPage
        SecondPage = NextSecondPage
        
        relate.addSubview(FirstPage)
        relate.addSubview(SecondPage)
        
        self.ContentViewLayout(manga: manga,relatedView: relate)
    }
}
