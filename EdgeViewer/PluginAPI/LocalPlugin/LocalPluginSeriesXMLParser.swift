//
//  LocalPluginSeriesXMLParser.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 9/24/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Foundation

class LocalPluginSeriesXMLParser {
    public var series: Series?
    
    init(contentsOf url: URL) {
        var xmlDocument: XMLDocument
        print("url: \(url)")
        do {
            xmlDocument = try XMLDocument(contentsOf: url, options: [])
            guard let rootElement = xmlDocument.rootElement() else {
                print("cannot get root element of series xml file: \(url)")
                return
            }
            guard let titleElementValue = rootElement.elements(forName: "title")[0].stringValue else {
                print("cannot get title element value")
                return
            }
            series = Series(owner: LocalPlugin.sharedInstance, identifier: titleElementValue)
            guard let series = series else {
                print("cannot initialize series object with owner LocalPlugin.sharedInstance and identifier \(titleElementValue)")
                return
            }
            series.title = titleElementValue
            
            let stringNodes = rootElement.elements(forName: "string")
            for node in stringNodes {
                let n = node.attribute(forName: "name")?.stringValue
                
                switch n {
                    case "author":
                        if let authorElementValue = rootElement.elements(forName: "author")[0].stringValue {
                            series.author = authorElementValue
                        }
                    case "rating":
                        if let ratingElementValue = rootElement.elements(forName: "rating")[0].stringValue {
                            series.rating = Double(ratingElementValue)
                        }
                    case "genre":
                        if let genreElementValue = rootElement.elements(forName: "genre")[0].stringValue {
                            series.author = genreElementValue
                        }
                    default :
                        break
                }
            }
            
            
            
            
            // TODO: consider using switch statement
            
            
            
            if let lastUpdatedElementValue = rootElement.elements(forName: "date")[0].stringValue {
                if lastUpdatedElementValue == "Unknown Release"{
                    series.lastUpdated = nil
                }else{
                    let RFC3339DateFormatter = DateFormatter()
                    RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
                    RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    if let time = RFC3339DateFormatter.date(from: lastUpdatedElementValue) {
                        series.lastUpdated = time
                    } else{
                        print("Unable to retrieve date. Check formatting of date string.")
                        series.lastUpdated = nil
                    }
                }
            }
        }
        catch {
            print("cannot initialize XMLDocument from series xml file: \(url)")
        }
    }
}
