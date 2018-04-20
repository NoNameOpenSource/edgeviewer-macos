//
//  RatingControl.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class RatingControl: NSStackView {
    
    //MARK: Properties
    
    var rating = 0 {
        didSet {
            updateStars()
        }
    }
        
    private lazy var starSize: CGSize = CGSize(width: self.bounds.width / CGFloat(starCount), height: self.bounds.height)
    
    private var ratingStars = [NSImageView]()
    
    private var starCount: Int = 5 {
        didSet {
            updateStars()
        }
    }

    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ratingStars.reserveCapacity(starCount)
        initializeStars()
        self.spacing = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ratingStars.reserveCapacity(starCount)
        initializeStars()
        self.spacing = 0
    }
    
    //MARK: Overrides
    
    override func mouseDown(with event: NSEvent) {
        print("Event: ", event.locationInWindow)
        let eventLocation: NSPoint = convert(event.locationInWindow, from: nil)
        rating = (Int(eventLocation.x) / Int(starSize.width)) + 1
    }
    
    
    //MARK: Methods

    private func updateStars() {
        for i in 0..<rating {
            ratingStars[i].image = #imageLiteral(resourceName: "filledStar")
        }
        if rating < starCount {
            for i in rating..<starCount {
                ratingStars[i].image = #imageLiteral(resourceName: "emptyStar")
            }
        }
    }

    private func initializeStars() {
        for _ in 0..<starCount {
            let emptyStarImage = NSImageView()
            emptyStarImage.image = #imageLiteral(resourceName: "emptyStar")
            
            //emptyStarImage.translatesAutoresizingMaskIntoConstraints = false
            emptyStarImage.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            emptyStarImage.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            addArrangedSubview(emptyStarImage)
            ratingStars.append(emptyStarImage)
        }
        updateStars()
    }

}













