//
//  JSPlugin.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 27..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa
import JavaScriptCore

// for now it lives in home folder of the user
let pluginFolder = Bundle.main.resourcePath! + "/"

class JSPlugin: Plugin {
    func series(withIdentifier identifier: Any) -> Series? {
        guard let function = context.objectForKeyedSubscript("loadSeries") else {
            return nil
        }
        guard let seriesJS = function.call(withArguments: [identifier]) else {
            return nil
        }
        let title = seriesJS.forProperty("title")!.toString()!
        let series = Series(owner: self, identifier: identifier)
        series.title = title
        return series
    }
    
    func update(book: Book) {
        return
    }
    
    func update(currentPage: Int, ofBook book: Book) {
        return
    }
    
    func update(rating: Double, ofBook book: Book) {
        return
    }
    
    
    let name: String
    var version: Double
    let folder: URL
    
    var homePage: LibraryPage {
        get {
            let group = DispatchGroup()
            var page = context.evaluateScript("loadHomePage();")!
            if page.toString() == "[object Promise]"  {
                let promise = JSPromise(withJSValue: page)!
                let callBack: @convention(block) (JSValue) -> Void = { jsValue in
                    page = jsValue
                    group.leave()
                }
                let castedFunction = unsafeBitCast(callBack, to: AnyObject.self)
                promise.then(onFulfilled: castedFunction)
                group.enter()
                group.wait(timeout: .distantFuture)
            }
            return self.page(fromJavascriptObject: page)!
        }
    }
    
    let context = JSContext()!
    
    let request: @convention(block) (String, JSValue?) -> Void  = { url, callback in
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
          
            //TODO: handle error with (if let error = error)
            guard let httpResponse = response as? HTTPURLResponse else {
                // request failed
                return
            }
            if let mimeType = httpResponse.mimeType,
                mimeType == "text/html" || mimeType == "application/json",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                if let callback = callback {
                    _ = callback.call(withArguments: [httpResponse.statusCode, mimeType, string])!
                }
            }
        }
        task.resume()
    }
    
    let consoleLog: @convention(block) (String) -> Void = { string in
        print(string)
    }
    
    init(pluginName: String) {
        self.name = pluginName
        self.version = 0.1
        self.folder = URL(fileURLWithPath: pluginFolder)
        let path = pluginFolder + pluginName
        let contentData = FileManager.default.contents(atPath: path)
        let content = String(data: contentData!, encoding: .utf8)
        let consoleLog = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        let request = unsafeBitCast(self.request, to: AnyObject.self)
        context.setObject(consoleLog, forKeyedSubscript: "consoleLog" as NSCopying & NSObjectProtocol)
        context.setObject(request, forKeyedSubscript: "request" as NSCopying & NSObjectProtocol)
        context.evaluateScript(content)
        _ = homePage
    }
    
    init(folder: URL) {
        self.name = "test"
        self.version = 0.1
        self.folder = folder
        let contentData = FileManager.default.contents(atPath: folder.path + "/plugin.js")
        let content = String(data: contentData!, encoding: .utf8)
        let consoleLog = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        let request = unsafeBitCast(self.request, to: AnyObject.self)
        context.setObject(consoleLog, forKeyedSubscript: "consoleLog" as NSCopying & NSObjectProtocol)
        context.setObject(request, forKeyedSubscript: "request" as NSCopying & NSObjectProtocol)
        context.evaluateScript("""
            function callMethod(obj, func, ...args) {
                return obj[func](...args);
            }
        """)
        context.evaluateScript(content)
    }
    
    func page(fromJavascriptObject object:JSValue) -> LibraryPage? {
        guard let identifier = object.forProperty("identifier")?.toString() else {
            return nil
        }
        guard let type = object.forProperty("type")?.toString() else {
            return nil
        }
        let page = LibraryPage(owner: self, identifier: identifier, type: LibraryPage.LibraryPageType(fromString: type))
        
        if let items = object.forProperty("items"),
           !items.isUndefined,
           let length = items.forProperty("length")?.toInt32(),
           length > 0 {
            for i in 0..<length {
                if let pageItem = pageItem(fromJavascriptObject: items.forProperty(String(i))) {
                    page.items.append(pageItem)
                }
            }
        }
        
        return page
    }
    
    func pageItem(fromJavascriptObject object: JSValue) -> PageItem? {
        guard let identifier = object.forProperty("identifier")?.toString() else {
            return nil
        }
        guard let type = object.forProperty("type")?.toString() else {
            return nil
        }
        let pageItem = PageItem(owner: self, identifier: identifier, type: PageItem.PageItemType(fromString: type))
        
        if let name = object.forProperty("name"),
           !name.isUndefined {
            pageItem.name = name.toString()
        }
        
        if let thumbnail = object.forProperty("thumbnail"),
            !thumbnail.isUndefined {
            pageItem.thumbnailURL = thumbnail.toString()
        }
        
        return pageItem
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Plugin protocol
    //------------------------------------------------------------------------------------------------
    
    func page(withIdentifier identifier: Any) -> LibraryPage? {
        return nil
    }
    
    func book(withIdentifier identifier: Any) -> Book? {
        guard let function = context.objectForKeyedSubscript("loadBook") else {
            return nil
        }
        guard let bookJS = function.call(withArguments: [identifier]) else {
            return nil
        }
        let title = bookJS.forProperty("title")!.toString()!
        let numberOfPages: Int = Int(bookJS.forProperty("identifier")!.toInt32())
        let book = Book(owner: self, identifier: identifier, type: .manga)
        return book
    }
    
    func page(ofBook book: Book, pageNumber: Int) -> NSImage? {
        guard let function = context.objectForKeyedSubscript("loadPageOfBook") else {
            return nil
        }
        guard let pageURL = function.call(withArguments: [book.identifier, 0]).toString() else {
            return nil
        }
        print(pageURL)
        let url = URL(string: pageURL)
        guard url != nil else {
            return nil
        }
        let image = NSImage(contentsOf: url!)
        if let bits = image?.representations.first as? NSBitmapImageRep {
            let data = bits.representation(using: .jpeg, properties: [:])
            try? data?.write(to: URL(fileURLWithPath: pluginFolder + "image.jpg"))
        }
        return image
    }
}
