//
//  LibraryListViewController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 14..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class LibraryListViewController: NSViewController, NSOutlineViewDelegate {
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    // dummy model
    let data = ["Cell 1", "Cell 2", "Cell 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // delegate
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        let index = outlineView.selectedRow
        //TODO: tell super controller which library selected
        return
    }
}

extension LibraryListViewController : NSOutlineViewDataSource {
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
        guard let cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as? NSTableCellView else {
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
