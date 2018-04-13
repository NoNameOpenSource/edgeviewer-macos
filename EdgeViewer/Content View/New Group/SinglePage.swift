//
//  SinglePage.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class SinglePage: Page {
    var MangaPage : NSImageView = NSImageView()
    

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func ContentViewLayout(manga : Manga,relatedView: NSView) {
        let SizesRatio = manga.Page[manga.currentPage - 1].size.height/manga.Page[manga.currentPage - 1].size.width
        
        let size = relatedView.bounds.size
        let origin = relatedView.bounds.origin
        
        MangaPage.setFrameSize(size)
        MangaPage.setFrameOrigin(origin)
        if SizesRatio >= 1{
            MangaPage.image?.size.height = MangaPage.frame.size.height
            MangaPage.image?.size.width = MangaPage.frame.size.height / SizesRatio
        }else{
            MangaPage.image?.size.width = MangaPage.frame.size.width
            MangaPage.image?.size.height = MangaPage.frame.size.width * SizesRatio
        }
    }
    
    override func UpdatePage(manga: Manga, relate : NSView) {
        let NextPageView : NSImageView = MangaPage
        
        NextPageView.image = manga.grabPage()
        MangaPage = NextPageView
        MangaPage.subviews.removeAll()
        relate.addSubview(MangaPage)
        ContentViewLayout(manga: manga, relatedView: relate)
    }
}
