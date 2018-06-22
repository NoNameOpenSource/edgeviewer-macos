//
//  ContentView.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

enum ViewType {
    case singlePage
    case doublePage
    case verticalScroll
}

class ContentViewController: NSViewController, NSPageControllerDelegate {
    
    var book: Book? = nil
    var currentPage = 0 {
        didSet {
            if let book = book {
                // fix if the page number is out of range
                if(currentPage < 0) {
                    currentPage = 0
                } else if(currentPage >= book.numberOfPages) {
                    currentPage = book.numberOfPages - 1
                }
                if pageController.arrangedObjects.count >= currentPage {
                    updatePage()
                }
            }
        }
    }
    var viewType: ViewType = .singlePage {
        didSet {
            // there could be a better way, but this works
            pageController.selectedIndex = currentPage + 1;
            pageController.selectedIndex = currentPage;
        }
    }
    var pageController: NSPageController = NSPageController()
    
    @IBOutlet weak var pageView: NSView!
    @IBOutlet weak var backToDetail: NSButton!
    @IBOutlet weak var pageNumberLabel: NSTextField!
    @IBOutlet weak var chapter: NSButton!
    @IBOutlet weak var bookMark: NSButton!
    @IBOutlet weak var settings: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        pageController.view = pageView
        pageController.delegate = self
        
        guard let book = book else {
            print("book nil")
            return
        }
        
        self.currentPage = book.currentPage
        
        // Setup PageView
        var pages = [NSImage]()
        for i in 0..<book.numberOfPages {
            if let page = book.page(atIndex: i) {
                pages.append(page)
            }
        }
        pageController.arrangedObjects = pages
        updatePage()
    }
    
    override func viewDidDisappear() {
        if let book = book {
            book.bookmark = self.currentPage;
        }
    }
    
    func updatePage() {
        if let book = book {
            var displayPage = "Cover"
            if currentPage != 0 {
                displayPage = "\(currentPage) / \(book.numberOfPages - 1)"
            }
            self.pageNumberLabel.stringValue = displayPage
        }
        NSAnimationContext.runAnimationGroup({ context in
            self.pageController.animator().selectedIndex = currentPage
        }) {
            self.pageController.completeTransition()
        }
        pageController.selectedIndex = currentPage
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: UI Action
    //------------------------------------------------------------------------------------------------
    
    @IBAction func viewPrevious(_ sender: Any) {
       switch self.viewType {
        case .singlePage:
            currentPage -= 1;
            break
        case .doublePage:
            currentPage -= 2;
            break
        default:
            return
        }
    }
    
    @IBAction func viewNext(_ sender: Any) {
        switch self.viewType {
            case .singlePage:
                currentPage += 1;
                break
            case .doublePage:
                currentPage += 2;
                break
            default:
                return
        }
    }
    
    @IBAction func switchViewType(_ sender: Any){
        switch self.viewType {
        case .singlePage:
            self.viewType = .doublePage
            break
        case .doublePage:
            self.viewType = .singlePage
            break
        default:
            return
        }
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: PageControllerDelegate
    //------------------------------------------------------------------------------------------------
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        switch self.viewType {
        case .singlePage:
            return NSPageController.ObjectIdentifier("SinglePageViewController")
        default:
            return NSPageController.ObjectIdentifier("DoublePageViewController")
        }
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        switch self.viewType {
        case .singlePage:
            return SinglePageViewController()
        default:
            return DoublePageViewController()
        }
    }
    
    func pageController(_ pageController: NSPageController, prepare viewController: NSViewController, with object: Any?) {
        guard let book = book else {
            print("book nil")
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
    
    // func used to change the view size when window size changed
    override func viewWillLayout() {
        pageNumberLabel.frame.origin = NSPoint(x: super.view.bounds.origin.x + super.view.bounds.width/2 - 33.0, y : super.view.bounds.origin.y)
    }
    
}
