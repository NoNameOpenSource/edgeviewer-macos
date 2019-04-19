//
//  LazyImageView.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 4. 19..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Cocoa

class LazyImageView: NSView {
    
    let request: URLRequest
    var imageView: NSImageView?
    var loaded = false
    private var loading = false
    
    static var semaphore = DispatchSemaphore(value: 1)
    
    init(request: URLRequest) {
        self.request = request
        super.init(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidMoveToSuperview() {
        if !loaded {
            loadImage()
        } else {
            fillSuperView()
        }
    }
    
    func loadImage() {
        guard !loaded && !loading else { return }
        self.loading = true
        
        let semaphore = LazyImageView.semaphore
        
        // load async
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error while loading image: \(error)")
                return
            }
            if let data = data {
                if let image = NSImage(data: data) {
                    semaphore.wait()
                    DispatchQueue.main.async {
                        self.imageView = NSImageView(frame: NSRect(origin: NSPoint(x: 0, y: 0), size: image.size))
                        self.imageView!.image = image
                        self.loaded = true
                        self.loading = false
                        self.addSubview(self.imageView!)
                        self.fillSuperView()
                        semaphore.signal()
                    }
                }
            }
        }
        
        task.resume()
    }
    
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        fillSuperView()
    }
    
    func fillSuperView() {
        guard let superview = superview else { return }
        self.setFrameSize(NSSize(width: superview.frame.width, height: superview.frame.height))
        if let imageView = imageView {
            imageView.frame = self.frame
        }
    }
}
