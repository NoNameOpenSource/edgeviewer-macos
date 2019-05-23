//
//  PageViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 4. 13..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Cocoa

class PageViewController: NSViewController, NSPageControllerDelegate, PageViewProtocol {
    var pageController: NSPageController = NSPageController()
    
    let book: Book
    
    var viewType: ViewType
    var readingMode: ReadingMode = .leftToRight
    
    var currentPage: Int {
        get {
            return pageController.selectedIndex
        }
        set {
            moveTo(index: newValue)
        }
    }
    var useAnimation: Bool = false
    
    var pages: [(Int, Int)] = []
    
    init(book: Book, viewType: ViewType) {
        self.book = book
        self.viewType = viewType
        super.init(nibName: NSNib.Name(rawValue: "PageView"), bundle: nil)
        
        // init pages
        if viewType == .singlePage {
            for i in 0..<book.numberOfPages {
                pages.append((i, -1));
            }
        } else {
            var i = 0
            while i < book.numberOfPages {
                if book.pages[i].pageType == .singlePage,
                   i + 1 != book.numberOfPages,
                   book.pages[i + 1].pageType == .singlePage {
                    pages.append((i, i + 1))
                    i += 2
                } else {
                    pages.append((i, -1))
                    i += 1
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        pageController.delegate = self
        pageController.view = self.view
        pageController.arrangedObjects = pages
        pageController.selectedIndex = book.currentPage
    }
    
    func moveForward() {
        pageController.navigateForward(nil)
    }
    
    func moveBackward() {
        pageController.navigateBack(nil)
    }
    
    func moveTo(index: Int) {
        currentPage = index
        
        if(useAnimation) {
            pageController.takeSelectedIndexFrom(currentPage)
        } else {
            pageController.selectedIndex = currentPage
        }
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: PageControllerDelegate
    //------------------------------------------------------------------------------------------------
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        let pages = object as! (Int, Int)
        if pages.1 == -1 {
            return NSPageController.ObjectIdentifier("SinglePageViewController")
        } else {
            return NSPageController.ObjectIdentifier("DoublePageViewController")
        }
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        switch identifier {
        case NSPageController.ObjectIdentifier("SinglePageViewController"):
            return SinglePageViewController()
        default:
            return DoublePageViewController()
        }
    }
    
    func pageController(_ pageController: NSPageController, prepare viewController: NSViewController, with object: Any?) {
        
        guard let pages = object as? (Int, Int) else {
            return
        }
        
        switch viewController {
            case let viewController as SinglePageViewController:
                let imageView = book.pages[pages.0].imageView
                imageView.loadImage()
                viewController.view.frame = pageController.view.frame
                viewController.addImageView(imageView)
                break
            case let viewController as DoublePageViewController:
                let leftImageView = book.pages[pages.0].imageView
                leftImageView.loadImage()
                let rightImageView = book.pages[pages.1].imageView
                rightImageView.loadImage()
                viewController.view.frame = pageController.view.frame
                viewController.addImageViews(leftImageView, rightImageView)
                break
            default:
                return
        }
    }
    
    func pageController(_ pageController: NSPageController, frameFor object: Any?) -> NSRect {
        return pageController.view.frame
    }
    
    func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        // this fixes bug that autoresizing not working after transition
        pageController.completeTransition()
    }
}
