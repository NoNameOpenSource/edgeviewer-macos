//
//  ChapterController.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 5/13/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ChapterController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
 
    var data = ["Chapter 1", "Chapter 2", "Chapter 3","Chapter 4"]
    
    var delegate: ContentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do view setup here.
    }
    
    override func viewDidDisappear() {
        guard let delegate = delegate else { return }
        delegate.chapterViewDidDisappear()
    }
    
}

extension ChapterController: NSOutlineViewDataSource {
 
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return data.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return data[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item  = item as? String else {
            return nil
        }
        guard let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CellID"), owner: self) as? NSTableCellView else {
            return nil
        }
        if let textField = cell.textField {
            textField.stringValue = item
        }
        
        return cell
    }
}

extension ChapterController: NSOutlineViewDelegate{
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if let myoutline = notification.object as? NSOutlineView {
            let selected = myoutline.selectedRowIndexes.map { Int($0) }
            print(selected)
        }
    }
}

