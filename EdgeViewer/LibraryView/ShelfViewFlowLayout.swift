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
        var attributes = super.layoutAttributesForElements(in: rect)
        guard let collectionView = collectionView else {
            return attributes
        }
        let width = itemSize.width
        let height = itemSize.height
        let numberOfItemsInRow = Int((CGFloat(collectionView.frame.width) - margin) / (width + margin))
        guard numberOfItemsInRow != 0 else {
            return attributes
        }
        for attribute in attributes {
            if attribute.representedElementCategory == .item,
               let indexPath = attribute.indexPath {
                let ypos = attribute.frame.minY
                let xpos = margin + (CGFloat(indexPath.item % numberOfItemsInRow) * (margin + width))
                attribute.frame = NSMakeRect(xpos, ypos, width, height)
            }
        }
        return attributes
    }
}

