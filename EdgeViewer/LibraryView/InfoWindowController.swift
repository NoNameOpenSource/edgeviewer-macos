//
//  InfoWindowController.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 6. 4..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Cocoa

class InfoWindowController: NSWindowController, NSTextFieldDelegate {

    @IBOutlet weak var coverImageView: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var seriesLabel: NSTextField!
    @IBOutlet weak var authorLabel: NSTextField!
    
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var seriesField: NSTextField!
    @IBOutlet weak var authorField: NSTextField!
    
    var book: Book?
    
    @IBAction func okButton(_ sender: NSButton) {
        book!.title = titleField.stringValue
        book!.seriesName = seriesField.stringValue == "" ? nil : seriesField.stringValue
        book!.author = authorField.stringValue == "" ? nil : authorField.stringValue
        
        // save the book
        
        self.close()
        NSApplication.shared.abortModal()
    }
    
    @IBAction func cancelButton(_ sender: NSButton) {
        self.close()
        NSApplication.shared.abortModal()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        if let book = book {
            titleLabel.stringValue = book.title
            seriesLabel.stringValue = book.seriesName ?? ""
            authorLabel.stringValue = book.author ?? ""
            if let url = book.pages[0].imageView.request.url {
                coverImageView.image = NSImage(byReferencing: url)
            }
            
            titleField.stringValue = titleLabel.stringValue
            seriesField.stringValue = seriesLabel.stringValue
            authorField.stringValue = authorLabel.stringValue
        }
    }
    
    
    override func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        if textField == titleField {
            titleLabel.stringValue = titleField.stringValue
        } else if textField == seriesField {
            seriesLabel.stringValue = seriesField.stringValue
        } else {
            authorLabel.stringValue = authorField.stringValue
        }
    }
}
