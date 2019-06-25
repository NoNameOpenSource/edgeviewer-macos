//
//  BookSorter.swift
//  EdgeViewer
//
//  Created by bmmkac on 6/25/19.
//  Copyright © 2019 NoName. All rights reserved.
//

import Foundation


class BookSorter{
    var bookList : [Book]
    var byType : SortType
    var byOrder : SortOrder
    
    enum SortType{
        case author
        case title
        case uodate_date
    }
    
    enum SortOrder{
        case small_to_large
        case large_to_small
    }
    
    private init(bookList : [Book], type : SortType, order : SortOrder){
        self.bookList = bookList
        self.byOrder = order
        self.byType = type
    }
    
    func bookSort()->[Book]{
        switch self.byType {
        case .uodate_date:
            if self.byOrder == .large_to_small{
                return self.bookList.sorted(by: sorterForDate )
            }else{
                return self.bookList.sorted(by: sorterForDate).reversed()
            }
        case .title:
            if self.byOrder == .large_to_small{
                return self.bookList.sorted(by: sorterForTtitle )
            }else{
                return self.bookList.sorted(by: sorterForTtitle).reversed()
            }

        case .author:
            if self.byOrder == .large_to_small{
                return self.bookList.sorted(by: sorterForAuthor )
            }else{
                return self.bookList.sorted(by: sorterForAuthor).reversed()
            }
        default:
            return self.bookList.sorted(by: sorterForDate ).reversed()
        }
        
    }
    
    func sorterForDate(first: Book,second: Book) -> Bool {
        guard first.lastUpdated != nil else {
            return false
        }
        guard second.lastUpdated != nil else {
            return true
        }
        
        return first.lastUpdated! > second.lastUpdated!
    }
    
    func sorterForTtitle(first: Book,second: Book)->Bool{
        var i : Int = 0
        let first_title = first.title
        let second_title = second.title
        while (first_title[i] == second_title[i]){
            i += 1
            if i >= first.title.count {
                return true
            }
            if i >= second.title.count {
                return false
            }
        }
        return first_title[i] > second_title[i]
    }
    
    func sorterForAuthor(first: Book, second:Book) -> Bool {
        var i = 0
        guard first.author != nil else{
            return false
        }
        guard second.author != nil else {
            return true
        }
        
        if first.author!.count == 0 {
            return false
        }
        if second.author!.count == 0 {
            return true
        }
        while first.author![i] == second.author![i]{
            i += 0
            if i >= first.author!.count {
                return true
            }
            if i >= second.author!.count {
                return false
            }
        }
        return first.author![i] > second.author![i]
    }
}
