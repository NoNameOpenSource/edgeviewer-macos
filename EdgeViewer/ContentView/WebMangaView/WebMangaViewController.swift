//
//  WebMangaViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 4. 14..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Cocoa

class WebMangaViewController: NSViewController, PageViewProtocol {
    
    let book: Book
    @IBOutlet weak var webMangaView: NSView!
    var viewFrame: NSRect = NSRect()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: NSNib.Name(rawValue: "WebMangaView"), bundle: nil)
        if webMangaView == nil {
            webMangaView = self.view.subviews[0].subviews[0]
        }
        
        var currentY: CGFloat = 0
        var width: CGFloat = 0
        for i in 1..<book.numberOfPages {
            let image = book.page(atIndex: book.numberOfPages - i)!
            let imageView = NSImageView(frame: NSRect(x: 0, y: currentY, width: image.size.width, height: image.size.height))
            imageView.image = image
            webMangaView.addSubview(imageView)
            currentY += image.size.height
            if image.size.width > width { width = image.size.width }
        }
        
        viewFrame = NSRect(x: 0, y: 0, width: width, height: currentY)
        webMangaView.frame = viewFrame
        
        if let scrollView = view as? NSScrollView, let documentView = scrollView.documentView {
            documentView.scroll(NSPoint(x: 0, y: currentY))
        }
    }
    
    override func viewDidLayout() {
        if webMangaView.frame != viewFrame {
            webMangaView.frame = viewFrame
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
