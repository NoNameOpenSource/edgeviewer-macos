//
//  ChapterController.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 5/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ChapterController: NSViewController{

    @IBOutlet weak var outlineView: NSOutlineView!
 
    let data = ["Chapter 1", "Chapter 2", "Chapter 3","Chapter 4"]
    var chapterSelectionHandler: ((Int) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do view setup here.
    }
    
}
extension ChapterController: NSOutlineViewDataSource{
 
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return data.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        // no indent, item always root
        return data[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item  = item as? String else {
            //TODO: error handling
            // item is not string
            return nil
        }
        guard let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CellID"), owner: self) as? NSTableCellView else {
            //TODO: error handling
            // failed to makeView ( cell )
            return nil
        }
        if let textField = cell.textField {
            textField.stringValue = item
        }
        if let imageView = cell.imageView {
            // need proper icon
            imageView.image = NSImage(named: NSImage.Name.columnViewTemplate)
        }
        return cell
    }
    
}
extension ChapterController: NSOutlineViewDelegate{
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        let index = outlineView.selectedRow
        guard let chapterSelectionHandler = chapterSelectionHandler else { return }
        chapterSelectionHandler(index)
}
    
}

