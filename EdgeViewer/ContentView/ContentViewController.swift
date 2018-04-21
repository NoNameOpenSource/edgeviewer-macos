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
    
    var manga: Manga? = nil
    var currentPage = 0 {
        didSet {
            updatePage()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        pageController.view = pageView
        pageController.delegate = self
        
        // Dummy Data for testing purpose
        setUpDummyData()
        
        // Setup PageView
        pageController.arrangedObjects = manga!.pages
    }
    
    func setUpDummyData() {
        let testManga = Manga(title: "Pandora Heart")
        let pages: [NSImage?] = [NSImage(named: NSImage.Name(rawValue: "images")),
                                 NSImage(named: NSImage.Name(rawValue: "first")),
                                 NSImage(named: NSImage.Name(rawValue: "Last")),
                                 NSImage(named: NSImage.Name(rawValue: "download"))]
        
        for page in pages {
            if let page = page {
                testManga.addNewPage(image: page)
            }
        }
        self.currentPage = 0
        
        manga = testManga
    }
    
    // Switch View Size
    func switchViewType(){
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
    
    func updatePage() {
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
        currentPage -= 1;
    }
    
    @IBAction func viewNext(_ sender: Any) {
        currentPage += 1;
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: PageControllerDelegate
    //------------------------------------------------------------------------------------------------
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        return NSPageController.ObjectIdentifier("SinglePageViewController")
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        
        return SinglePageViewController()
    }
    
    func pageController(_ pageController: NSPageController, prepare viewController: NSViewController, with object: Any?) {
        if let viewController = viewController as? SinglePageViewController {
            viewController.imageView.image = manga!.pages[currentPage]
        }
    }
    
    func pageController(_ pageController: NSPageController, frameFor object: Any?) -> NSRect {
        return pageController.view.frame
    }
    
    // func used to change the view size when window size changed
    override func viewWillLayout() {
        pageNumberLabel.frame.origin = NSPoint(x: super.view.bounds.origin.x + super.view.bounds.width/2 - 33.0, y : super.view.bounds.origin.y)
        //pageView.pageViewLayout()
        //pageView.contentViewLayout(manga: manga!, relatedView: mangaPage)
    }
    
}
