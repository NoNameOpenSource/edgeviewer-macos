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
    var displayedItem: [ButtonType] = [.backward, .forward, .chapter]
    var navigation: [Any] = Array()
    var customizationPalette: CustomizationPalette? = nil

    @IBOutlet weak var editToolBox: NSView!
    @IBOutlet weak var panelView: NSView!
    @IBOutlet weak var userPanel: NSCollectionView!
    @IBOutlet weak var panelClipView: NSClipView!
    @IBOutlet weak var panelBorderedView: NSScrollView!
    
    var timer = Timer()
    var doNotHidePanelView = false
    var animationDictionary = [[NSViewAnimation.Key : NSView]]()
    
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
    
    @IBAction func enableEditMode(_ sender: NSMenuItem) {
        for i in 0..<userPanel.numberOfItems(inSection: 0) {
            let button = userPanel.item(at: IndexPath(item: i, section: 0)) as! ButtonItem
            button.isEnabled = false
        }
        showCustomizationPalette()
    }
    
    func showCustomizationPalette() {
        customizationPalette = CustomizationPalette(nibName: NSNib.Name(rawValue: "CustomizationPalette"), bundle: nil)
        guard let customizationPalette = customizationPalette else { return }
        customizationPalette.delegate = self
        
        let constraintA = NSLayoutConstraint(item: customizationPalette.view,
                                        attribute: .centerX,
                                        relatedBy: .equal,
                                           toItem: self.view,
                                        attribute: .centerX,
                                       multiplier: 1.0,
                                         constant: 0.0
        )
        let constraintB = NSLayoutConstraint(item: customizationPalette.view,
                                        attribute: .width,
                                        relatedBy: .equal,
                                           toItem: nil,
                                        attribute: .width,
                                       multiplier: 1.0,
                                         constant: 480.0
        )
        let constraintC = NSLayoutConstraint(item: customizationPalette.view,
                                        attribute: .height,
                                        relatedBy: .equal,
                                           toItem: nil,
                                        attribute: .height,
                                       multiplier: 1.0,
                                         constant: 272.0
        )
        let constraintD = NSLayoutConstraint(item: customizationPalette.view,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                           toItem: userPanel,
                                        attribute: .top,
                                       multiplier: 1.0,
                                         constant: 0.0
        )
        customizationPalette.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customizationPalette.view)
        self.view.addConstraints([constraintA, constraintB, constraintC, constraintD])
    }
    
    func dismissCustomizationPalette() {
        for i in 0..<userPanel.numberOfItems(inSection: 0) {
            let button = userPanel.item(at: IndexPath(item: i, section: 0)) as! ButtonItem
            button.isEnabled = true
        }
        customizationPalette!.view.removeFromSuperview()
        customizationPalette = nil
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
        
        if let visualEffectView = userPanel.superview?.superview?.superview as? NSVisualEffectView {
            visualEffectView.wantsLayer = true
            visualEffectView.layer?.masksToBounds = true
            visualEffectView.layer?.cornerRadius = 5.0
        }
        
        //userPanel.wantsLayer = true
        userPanel.backgroundColors = [NSColor.clear]
        
        configureCollectionView()
        userPanel.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "com.ggomong.EdgeViewer.toolbar")])
        
        let pageViewTrackingArea = NSTrackingArea(rect: pageView.visibleRect, options: [.mouseMoved, .activeInKeyWindow], owner: self)
        pageView.addTrackingArea(pageViewTrackingArea)
        panelView.isHidden = true
        
        updatePage()
    }
    
    override func mouseMoved(with event: NSEvent) {
        timer.invalidate()
        panelView.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hidePanelView), userInfo: nil, repeats: true)
    }
    
    @objc func hidePanelView() {
        if (!doNotHidePanelView) {
            panelView.isHidden = true
        }
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
    
    @objc func segueToChapterView(sender : Any) {
        doNotHidePanelView = true
        var data : [String] = []
        for chapter in (manga?.chapter)! {
            data.append(String(chapter))
        }
        let button: NSButton = sender as! NSButton
        
        if let popoverContent = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ChapterController")) as? ChapterController {
            popoverContent.data = data
            self.presentViewController(popoverContent, asPopoverRelativeTo: popoverContent.view.bounds, of: button, preferredEdge: .maxY, behavior: NSPopover.Behavior.semitransient)
            
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
        if #available(OSX 10.12, *) {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        } else {
            // Fallback on earlier versions
        }
    }
}

extension ContentViewController: NSCollectionViewDataSource{
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedItem.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        var item = userPanel.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ButtonItem"), for: indexPath) as! ButtonItem
        item.buttonType = displayedItem[indexPath.item]
        switch(displayedItem[indexPath.item]) {
            case .backward:
                if #available(OSX 10.12, *) {
                    item.image = NSImage(named: .goBackTemplate)
                } else {
                    // Fallback on earlier versions
                }
                item.button.target = self
                item.button.action = #selector(pageBack)
                if(customizationPalette != nil) {
                    item.isEnabled = false
                }
            case .forward:
                if #available(OSX 10.12, *) {
                    item.image = NSImage(named: .goForwardTemplate)
                } else {
                    // Fallback on earlier versions
                }
                item.button.target = self
                item.button.action = #selector(pageForward)
                if(customizationPalette != nil) {
                    item.isEnabled = false
                }
            case .chapter:
                if #available(OSX 10.12, *) {
                    item.image = NSImage(named: .listViewTemplate)
                } else {
                    // Fallback on earlier versions
                }
                item.button.target = self
                item.button.action = #selector(segueToChapterView)
                if(customizationPalette != nil) {
                    item.isEnabled = false
                }
            default:
                break
        }
        return item
    }
}

extension ContentViewController : NSCollectionViewDelegate{
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        draggingIndexPath = indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        draggingIndexPath = []
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        let pb = NSPasteboardItem()
        pb.setString(displayedItem[indexPath.item].rawValue, forType: NSPasteboard.PasteboardType(rawValue: "com.ggomong.EdgeViewer.toolbar"))
        
        return pb;
    }
    
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
        switch(draggingInfo.draggingSource()) {
            case _ as NSCollectionView:
                return .move
            case _ as PaletteItem:
                return .copy
            default:
                return .generic
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        var movePassed : Bool = true
        userPanel.animator().performBatchUpdates({
            switch(draggingInfo.draggingSource()) {
                case let draggingSource as NSCollectionView:
                    for i in draggingIndexPath{
                        let tmp = self.displayedItem.remove(at: i.item)
                        self.displayedItem.insert(tmp, at:
                            (indexPath.item <= i.item) ? indexPath.item : (indexPath.item - 1))
                    }
                case let draggingSource as PaletteItem:
                    let tmp = ButtonType(rawValue: draggingInfo.draggingPasteboard().string(forType: NSPasteboard.PasteboardType(rawValue: "com.ggomong.EdgeViewer.toolbar"))!)!
                    if !(displayedItem.contains(tmp)){
                        self.displayedItem.insert(tmp, at: indexPath.item)
                        self.userPanel.reloadData()
                    } else {
                        movePassed = false
                    }
                default:
                    break // ignore any external source
            }
        }) { finished in
            self.userPanel.reloadData()
        }
        return movePassed
    }
}



