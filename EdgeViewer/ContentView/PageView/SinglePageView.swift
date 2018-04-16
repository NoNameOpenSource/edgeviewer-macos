//
//  SinglePage.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class SinglePageView: PageView {
    var mangaPage : NSImageView = NSImageView()
    

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func contentViewLayout(manga : Manga,relatedView: NSView) {
        let sizesRatio = manga.Page[manga.currentPage - 1].size.height/manga.Page[manga.currentPage - 1].size.width
        
        let size = relatedView.bounds.size
        let origin = relatedView.bounds.origin
        
        mangaPage.setFrameSize(size)
        mangaPage.setFrameOrigin(origin)
        if sizesRatio >= 1{
            mangaPage.image?.size.height = mangaPage.frame.size.height
            mangaPage.image?.size.width = mangaPage.frame.size.height / sizesRatio
        }else{
            mangaPage.image?.size.width = mangaPage.frame.size.width
            mangaPage.image?.size.height = mangaPage.frame.size.width * sizesRatio
        }
    }
    
    override func updatePage(manga: Manga, relate : NSView) {
        let nextPageView : NSImageView = mangaPage
        
        nextPageView.image = manga.grabPage()
        mangaPage = nextPageView
        mangaPage.subviews.removeAll()
        
        contentViewLayout(manga: manga, relatedView: relate)
        relate.addSubview(mangaPage)
    }
    

}
