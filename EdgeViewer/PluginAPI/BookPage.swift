//
//  BookPage.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 4. 18..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Cocoa

class BookPage {
    var imageView: LazyImageView
    var pageName: String = ""
    var pageType: ViewType = .singlePage
    
    init(request: URLRequest, pageName: String, pageType: ViewType) {
        self.imageView = LazyImageView(request: request)
        self.pageName = pageName
        self.pageType = pageType
    }
    
    func loadImage() {
        self.imageView.loadImage()
    }
}
