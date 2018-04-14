//
//  CollectionViewItem.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
    }
}
class ImageFile {
    
    fileprivate(set) var thumbnail: NSImage?
    fileprivate(set) var fileName: String
    
    init?(url: URL) {
        fileName = url.lastPathComponent
        thumbnail = nil
        let imageSource = CGImageSourceCreateWithURL(url.absoluteURL as CFURL, nil)
        if let imageSource = imageSource {
            guard CGImageSourceGetType(imageSource) != nil else { return }
            let thumbnailOptions = [
                String(kCGImageSourceCreateThumbnailFromImageIfAbsent): true,
                String(kCGImageSourceThumbnailMaxPixelSize): 160
                ] as [String : Any]
            if let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary?) {
                thumbnail = NSImage(cgImage: thumbnailRef, size: NSSize.zero)
            } else {
                return nil
            }
        }
    }
    
}
