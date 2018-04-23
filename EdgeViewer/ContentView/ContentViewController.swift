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
    
    var manga: Manga? = nil;
    var currentPage = 0 {
        didSet {
            switch self.viewType {
            case .singlePage:
                if currentPage < 0 || currentPage >= manga!.numberOfPages{
                    currentPage = oldValue;
                }else{
                    updatePage()
                }
            case .doublePage:
                if currentPage == ( 0 - 2 ) || currentPage == manga!.numberOfPages{
                    currentPage = oldValue
                }else if currentPage == ( 0 - 1){
                    self.viewType = .singlePage
                    currentPage = oldValue - 1
                }else if currentPage == manga!.numberOfPages - 1{
                    self.viewType = .singlePage
                    currentPage = oldValue + 1
                    updatePage()
                }else{
                    updatePage()
                }
            default:
                return
            }
        }
    }
    var viewType: ViewType = .singlePage
    let pageController: NSPageController = NSPageController();
    
    @IBOutlet weak var pageView: NSView!
    @IBOutlet weak var mangaPage: NSView!
    @IBOutlet weak var backToDetail: NSButton!
    @IBOutlet weak var pageNumberLabel: NSTextField!
    @IBOutlet weak var chapter: NSButton!
    @IBOutlet weak var bookMark: NSButton!
    @IBOutlet weak var settings: NSButton!
    
    override func viewWillAppear() {
        setUpDummyData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        pageController.view = pageView
        pageController.delegate = self
        
        // Dummy Data for testing purpose
        setUpDummyData()
        // Setup PageView
        pageController.arrangedObjects = manga!.pages
        updatePage()
    }
    
    override func viewDidDisappear() {
        manga!.bookMark = self.currentPage;
        print(manga!.bookMark);
    }
    
    func setUpDummyData() {
        let testManga = Manga(title: "Pandora Heart")
        let pages: [NSImage?] = [NSImage(named: NSImage.Name(rawValue: "images")),
                                 NSImage(named: NSImage.Name(rawValue: "first")),
                                 NSImage(named: NSImage.Name(rawValue: "Last")),
                                 NSImage(named: NSImage.Name(rawValue: "download"))]
        testManga.bookMark = 2
        for page in pages {
            if let page = page {
                testManga.addNewPage(image: page)
            }
        }
        
        manga = testManga
    }
    
    func updatePage() {
        self.pageNumberLabel.stringValue = "\(currentPage + 1) / \(manga!.numberOfPages)"
        NSAnimationContext.runAnimationGroup({ context in
            self.pageController.animator().selectedIndex = currentPage
        }) {
            self.pageController.completeTransition()
        }
        print(self.pageController.animator())
        pageController.selectedIndex = currentPage
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: UI Action
    //------------------------------------------------------------------------------------------------
    
    @IBAction func viewPrevious(_ sender: Any) {

        if currentPage > 0 {
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
        updatePage()
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: PageControllerDelegate
    //------------------------------------------------------------------------------------------------
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        switch self.viewType {
        case .singlePage:
            return NSPageController.ObjectIdentifier("SinglePageViewController")
        case .doublePage:
            return NSPageController.ObjectIdentifier("DoublePageViewController")
        default:
            return NSPageController.ObjectIdentifier("DoublePageViewController")
        }
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        switch self.viewType {
        case .singlePage:
            return SinglePageViewController()
        case .doublePage:
            return DoublePageViewController()
        default:
            return DoublePageViewController()
        }
    }
    
    func pageController(_ pageController: NSPageController, prepare viewController: NSViewController, with object: Any?) {
        let image = self.manga!.pages
        
        
        if let viewController = viewController as? SinglePageViewController {
            viewController.imageView.image = image[self.currentPage]
        }
        
        if let viewController = viewController as? DoublePageViewController {
            viewController.leftImageView.image = image[self.currentPage]
            viewController.rightImageView.image = image[self.currentPage + 1]
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
