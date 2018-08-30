//
//  ShelfViewFlowLayout.swift
//  EdgeViewer
//
//  Created by Sanzhar Almakyn on 6/10/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class ShelfViewFlowLayout: NSCollectionViewFlowLayout {

    let margin: CGFloat = 20
    var currentX: CGFloat = 20
    var currentY: CGFloat = 0
//    Defining the attributes
    override func  layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        var attributes = [NSCollectionViewLayoutAttributes]()
        for j in 0..<self.collectionView!.numberOfSections {
            let count = self.collectionView!.numberOfItems(inSection: 0)
            for i in 0..<count{
                if let attribute = layoutAttributesForItem(at: NSIndexPath(forItem: i, inSection: j) as IndexPath) {
                    attributes.append(attribute)
                    
                }
            }
        }
        return attributes
    }
    
//    Defining the position of the frames and creating them
    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        
//        Not used
//        let x = attr.frame.minX

        let ypos = attributes.frame.minY
        let width = attributes.frame.width
        let height = attributes.frame.height
        if ypos != currentY {
            currentX = margin
            currentY = ypos
        }
        
        attributes.frame = NSMakeRect(currentX, currentY, width, height)
        
        currentX += width + margin
        
        return attributes
    }
}

