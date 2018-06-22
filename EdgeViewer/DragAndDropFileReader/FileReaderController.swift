//
//  FileReader.swift
//  EdgeViewer
//
//  Created by bmmkac on 6/21/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class FileReaderController: NSViewController {
    
    @IBOutlet weak var dropView: DropView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        registeDragAndDrop()
    }
    
    func registeDragAndDrop(){
        if #available(OSX 10.13, *) {
            dropView.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL,
                                              NSPasteboard.PasteboardType.fileNameType(forPathExtension: "zip")])
        } else {
            // Fallback on earlier versions
            dropView.registerForDraggedTypes([NSPasteboard.PasteboardType.fileNameType(forPathExtension: "zip")])
        }
    }
    
}
