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
   
    var draggingIndexPath : Set<IndexPath> = []
    var displayedItem : [String] = ["ForwardButtom","ButtomItem", "BackWardButtom", "SwitchModeButtom"]
    
    @IBOutlet weak var userPanel: NSCollectionView!
    
    var pageController: NSPageController = NSPageController()
    var manga: Manga? = nil;
    @IBOutlet weak var pageView: NSView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        pageController.view = pageView
        pageController.delegate = self
        
        // Dummy Data for testing purpose
        setUpDummyData()
        // Setup PageView
        pageController.arrangedObjects = manga!.pages
        currentPage = (manga?.bookMark)!
        
        userPanel.isSelectable = true;
        
        
        userPanel.backgroundColors = [NSColor.gray]
        configureCollectionView()
        configureCollectionView()
        userPanel.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        updatePage()
    }
    
    override func viewDidDisappear() {
        manga!.bookMark = currentPage;
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
    
 
    //------------------------------------------------------------------------------------------------
    //MARK: PageControllerDelegate
    //------------------------------------------------------------------------------------------------
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        switch viewType {
        case .singlePage:
            return NSPageController.ObjectIdentifier("SinglePageViewController")
        default:
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
        let image = manga!.pages
        
        switch viewController {
            case let viewController as SinglePageViewController:
                viewController.image = image[currentPage]
                break
            case let viewController as DoublePageViewController:
                viewController.leftImage = image[currentPage]
                viewController.rightImage = image[currentPage + 1]
                break
            default:
                return
        }
    }
    
    func pageController(_ pageController: NSPageController, frameFor object: Any?) -> NSRect {
        return pageController.view.frame
    }
    
    // func used to change the view size when window size changed
    
    @objc func pageForward(){
        switch viewType {
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
    
    @objc public func pageBack(){
        switch viewType {
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
    
    @objc public func viewTypeSwitch(){
        switch viewType {
        case .singlePage:
            viewType = .doublePage
            break
        case .doublePage:
            viewType = .singlePage
            break
        default:
            return
        }
    }
    
    fileprivate func configureCollectionView() { // this one makes layout
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 50.0, height: 50.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        userPanel.collectionViewLayout = flowLayout
        view.wantsLayer = true
        userPanel.layer?.backgroundColor = NSColor.lightGray.cgColor
        if #available(OSX 10.12, *) {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        } else {
            // Fallback on earlier versions
        }
    }

}

extension ContentViewController: NSCollectionViewDataSource{
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedItem.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        print(displayedItem[indexPath.item])
        var item = userPanel.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: displayedItem[indexPath.item]), for: indexPath)
        
        switch item {
        case is ButtomItem:
            guard let _ = item as? ButtomItem else{
                
                return item
            }
            
            
        case let someForwardButtom as ForwardButtom:
            someForwardButtom.forward.target = self
            someForwardButtom.forward.action = #selector(pageForward)
            guard let _ = item as? ForwardButtom else{
                item = someForwardButtom
                return item
            }
            
        case let someBackWardButtom as BackWardButtom:
            someBackWardButtom.backward.target = self
            someBackWardButtom.backward.action = #selector(pageBack)
            guard let _ = item as? BackWardButtom else{
                item = someBackWardButtom
                return item
            }
            
        case let someSwitchModeButtom as SwitchModeButtom:
            someSwitchModeButtom.switchTypeViewButtom.target = self
            someSwitchModeButtom.switchTypeViewButtom.action = #selector(viewTypeSwitch)
            guard let _ = item as? SwitchModeButtom else{
                item = someSwitchModeButtom
                return item
            }
        default:
            break
        }
        return item
    }
}

extension ContentViewController : NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        draggingIndexPath = indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        let pb = NSPasteboardItem()

        pb.setString(displayedItem[indexPath.item], forType: NSPasteboard.PasteboardType.string)
        return pb;
    }
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {

        return .move
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        for i in draggingIndexPath{
            let tmp = displayedItem.remove(at: i.item)
            displayedItem.insert(tmp, at:
                (indexPath.item <= i.item) ? indexPath.item : (indexPath.item - 1))
            //NSAnimationContext.current.duration = 0.5
            userPanel.animator().moveItem(at: i, to: indexPath)
        }

        return true
    }
}
