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
    
    var viewType: ViewType = .singlePage
    var readingMode: ReadingMode = .leftToRight
    
    var currentPage = 0
    var useAnimation: Bool = false
    
    var pages: [Int] = []
    
    init(book: Book) {
        self.book = book
        super.init(nibName: NSNib.Name(rawValue: "PageView"), bundle: nil)
        
        // init pages
        if book.readingMode == .rightToLeft {
            for i in (0..<book.numberOfPages).reversed() {
                pages.append(i);
            }
        }
        else {
            for i in 0..<book.numberOfPages {
                pages.append(i);
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
        switch viewType {
        case .singlePage:
            return NSPageController.ObjectIdentifier("SinglePageViewController")
        default:
            if currentPage == 0 {
                // the first page is cover page
                // it should be displayed with singlepage view
                return NSPageController.ObjectIdentifier("SinglePageViewController")
            }
            guard currentPage + 1 != book.numberOfPages else {
                // there is only one page left
                // therefore double page view cannot be used
                return NSPageController.ObjectIdentifier("SinglePageViewController")
            }
            return NSPageController.ObjectIdentifier("DoublePageViewController")
        }
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        switch viewType {
        case .singlePage:
            return SinglePageViewController()
        default:
            return DoublePageViewController()
        }
    }
    
    func pageController(_ pageController: NSPageController, prepare viewController: NSViewController, with object: Any?) {
        
        guard let currentPage = object as? Int else {
            return
        }
        
        switch viewController {
        case let viewController as SinglePageViewController:
            viewController.image = book.page(atIndex: currentPage)
            break
        case let viewController as DoublePageViewController:
            viewController.leftImage = book.page(atIndex: currentPage)
            viewController.rightImage = book.page(atIndex: currentPage + 1)
            break
        default:
            return
        }
    }
    
    func pageController(_ pageController: NSPageController, frameFor object: Any?) -> NSRect {
        return pageController.view.frame
    }
}
