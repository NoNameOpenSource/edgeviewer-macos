//
//  CustomizationPalette.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 6. 24..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class CustomizationPalette: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
    }
    
}

class PaletteItem: NSView, NSDraggingSource {
    var buttonType: ButtonType = .none
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        if let identifier = self.identifier {
            switch(identifier.rawValue) {
            case "BackButton":
                buttonType = .backward
            case "ForwardButton":
                buttonType = .forward
            case "ChapterButton":
                buttonType = .chapter
            default:
                break
            }
        }
    }
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        switch(context) {
        case .outsideApplication:
            return NSDragOperation()
        case .withinApplication:
            return .generic
        }
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setString(buttonType.rawValue, forType: NSPasteboard.PasteboardType(rawValue: "com.ggomong.EdgeViewer.toolbar"))
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        
        //draggingItem.setDraggingFrame(self.bounds, contents:self)
        
        guard let bitmap = self.bitmapImageRepForCachingDisplay(in: self.bounds) else { return }
        self.cacheDisplay(in: self.bounds, to: bitmap)
        let image = NSImage()
        image.addRepresentation(bitmap)
        draggingItem.setDraggingFrame(self.bounds, contents:image)
        
        beginDraggingSession(with: [draggingItem], event: theEvent, source: self)
        
    }
}
