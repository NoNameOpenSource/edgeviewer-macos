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
        
        let bounds = view.subviews[0].bounds
        view.subviews[0].bounds = NSRect(x: 0, y: currentY, width: bounds.width, height: bounds.height)
    }
    
    override func viewWillLayout() {
        let leftPadding = (view.subviews[0].frame.width - viewFrame.width) / 2
        if webMangaView.frame != viewFrame {
            webMangaView.setFrameSize(NSSize(width: webMangaView.frame.width, height: viewFrame.height))
            
            for subView in webMangaView.subviews {
                subView.frame = NSRect(x: leftPadding, y: subView.frame.minY, width: subView.frame.width, height: subView.frame.height)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
