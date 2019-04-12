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
    var displayedItem: [ButtonType] = [.backward, .forward, .chapter, .pageViewSelector]
    var navigation: [Any] = Array()
    var customizationPalette: CustomizationPalette? = nil
    var chapterController: ChapterController? = nil

    @IBOutlet weak var editToolBox: NSView!
    @IBOutlet weak var panelView: NSView!
    @IBOutlet weak var userPanel: NSCollectionView!
    @IBOutlet weak var panelClipView: NSClipView!
    @IBOutlet weak var panelBorderedView: NSScrollView!
    
    var timer = Timer()
    var animationDictionary = [[NSViewAnimation.Key : NSView]]()
    
    var pageController: NSPageController = NSPageController()
    var book: Book?
    
    var useAnimation: Bool = false
    var inTransition: Int = 0
    
    var keyDownEvent: Any?
    
    @IBOutlet weak var pageView: NSView!
    
    var currentPage = 0 {
        didSet {
            // fix if the page number is out of range
            if(currentPage < 0) {
                currentPage = 0
            } else if(currentPage >= book!.numberOfPages) {
                if (viewType == .singlePage){
                    currentPage = book!.numberOfPages - 1
                    print("last page")
                }else if (viewType == .doublePage){
                    currentPage = book!.numberOfPages - 2
                    print("last two page")
                }
            }
        }
    }
    
    var viewType: ViewType = .singlePage {
        didSet {
            if(viewType == .doublePage && currentPage % 2 != 0) {
                // doublePage only wants even page numbers
                currentPage -= 1
            }
            // there could be a better way, but this works
            // to refresh the pageController for the switched view
            pageController.selectedIndex = currentPage + 1
            pageController.selectedIndex = currentPage
            pageController.completeTransition()
        }
    }
    
    @IBAction func enableEditMode(_ sender: NSMenuItem) {
        guard customizationPalette == nil else { return }
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
        
        guard let book = book else {
            print("book nil")
            return
        }
        
        self.currentPage = book.currentPage
        
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
        
        let pageViewTrackingArea = NSTrackingArea(rect: pageView.visibleRect, options: [.mouseMoved, .mouseEnteredAndExited, .activeAlways, .inVisibleRect], owner: self)
        pageView.addTrackingArea(pageViewTrackingArea)
        
        var pages = [Int]()
        
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
        
        // set up event handling for left/right arrow keys (for changing pages)
        self.keyDownEvent = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        
        pageController.arrangedObjects = pages
        //currentPage = book?.bookMark
        updatePage()
        
        useAnimation = true
    }
        
    override func mouseMoved(with event: NSEvent) {
        timer.invalidate()
        NSCursor.unhide()
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.2
            panelView.animator().alphaValue = 1
        }, completionHandler: {
        })
        checkMouseLocationAndSetTimer(with: event)
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hidePanelViewAndCursor), userInfo: nil, repeats: true)
    }
    
    func checkMouseLocationAndSetTimer(with event: NSEvent) {
        let mouseInPanelViewCoordinates = panelView.convert(event.locationInWindow, from: nil)
        guard !NSMouseInRect(mouseInPanelViewCoordinates, panelView.bounds, false) else { return }
        timer.invalidate()
        setTimer()
    }
    
    override func mouseExited(with event: NSEvent) {
        timer.invalidate()
        hidePanelViewAndCursor()
        NSCursor.unhide()
    }
    
    @objc func hidePanelViewAndCursor() {
        guard customizationPalette == nil else { return }
        guard chapterController == nil else { return }
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.2
            panelView.animator().alphaValue = 0
        }, completionHandler: {
        })
        NSCursor.hide()
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
            //self.pageNumberLabel.stringValue = displayPage
        }
        
        if(useAnimation) {
            pageController.takeSelectedIndexFrom(currentPage)
        } else {
            pageController.selectedIndex = currentPage
        }
        
        //pageController.selectedIndex = currentPage
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
            guard currentPage + 1 != book!.numberOfPages else {
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
        guard let book = book else {
            print("book nil")
            return
        }
        
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
    
    @objc func pageForward(){
        switch viewType {
        case .singlePage:
            currentPage += 1;
            break
        case .doublePage:
            if(currentPage == 0) {
                currentPage += 1;
            } else {
                currentPage += 2;
            }
            break
        default:
            return
        }
        updatePage()
    }
    
    @objc func segueToChapterView(sender : Any) {
        guard chapterController == nil else {
            chapterController?.dismiss(sender)
            return
        }
        
        var data : [String] = []
        if let chapters = book?.chapters {
            for chapter in chapters {
                data.append(chapter.title)
            }
        }
        let button: NSButton = sender as! NSButton
        
        chapterController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ChapterController")) as? ChapterController
        guard let chapterController = chapterController else { return }
        chapterController.data = data
        chapterController.delegate = self
        self.presentViewController(chapterController, asPopoverRelativeTo: chapterController.view.bounds, of: button, preferredEdge: .maxY, behavior: NSPopover.Behavior.semitransient)
        
    }
    
    func chapterViewDidDisappear() {
        chapterController = nil
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
        updatePage()
    }
    
    override func keyDown(with event: NSEvent) {
        let leftArrowKey: UInt16 = 123
        let rightArrowKey: UInt16 = 124
        switch event.keyCode {
        case leftArrowKey:
            pageBack()
        case rightArrowKey:
            pageForward()
        default:
            break
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
        
        if (userPanel.numberOfItems(inSection: 0) > 0) {
            for i in 0..<userPanel.numberOfItems(inSection: 0) {
                if let item = userPanel.item(at: i) as? ButtonItem,
                item.buttonType == .pageViewSelector {
                    switch viewType {
                    case .singlePage:
                        item.image = #imageLiteral(resourceName: "DoublePageViewSelector")
                    case .doublePage:
                        item.image = #imageLiteral(resourceName: "SinglePageViewSelector")
                    default:
                        return
                    }
                }
            }
        }
        
        print("type switched")
        print(viewType);
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
    
    override func viewWillDisappear() {
        if let keyDownEvent = keyDownEvent {
            NSEvent.removeMonitor(keyDownEvent)
            self.keyDownEvent = nil
        }
    }
    
    deinit {
        //print("contentVC for \(book!.title) deinited")
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
            case .pageViewSelector:
                if #available(OSX 10.12, *) {
                    item.image = #imageLiteral(resourceName: "SinglePageViewSelector")
                } else {
                    // Fallback on earlier versions
                }
                item.button.target = self
                item.button.action = #selector(viewTypeSwitch)
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



