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
            // fix if the page number is out of range
            if(currentPage < 0) {
                currentPage = 0
            } else if(currentPage >= manga!.numberOfPages) {
                currentPage = manga!.numberOfPages - 1
            }
            // update page
            updatePage()
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
        updatePage()
    }
    
    override func viewDidDisappear() {
        manga!.bookMark = self.currentPage;
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
        let image = self.manga!.pages
        
        switch viewController {
            case let viewController as SinglePageViewController:
                viewController.image = image[currentPage]
                break
            case let viewController as DoublePageViewController:
                viewController.leftImage = image[self.currentPage]
                viewController.rightImage = image[self.currentPage + 1]
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
