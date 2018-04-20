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
    
    // set star sizes according to size of RatingControl UI element
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
        initializeStars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeStars()
    }
    
    //MARK: Overrides
    
    override func mouseDown(with event: NSEvent) {
        print("Event: ", event.locationInWindow)
        let eventLocation: NSPoint = convert(event.locationInWindow, from: nil)
        rating = (Int(eventLocation.x) / Int(starSize.width)) + 1
    }
    
    
    //MARK: Methods

    private func updateStars() {
        if rating <= starCount { // make sure rating is not higher than number of stars
            // add filled stars to show rating
            for i in 0..<rating {
                ratingStars[i].image = #imageLiteral(resourceName: "filledStar")
            }
        }
    }

    private func initializeStars() {
        ratingStars.reserveCapacity(starCount) // array optimization
        self.spacing = 0 // prevent from adding space between each star
        
        for _ in 0..<starCount {
            let emptyStarImage = NSImageView()
            emptyStarImage.image = #imageLiteral(resourceName: "emptyStar")
            
            emptyStarImage.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            emptyStarImage.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // initialize images to empty stars
            addArrangedSubview(emptyStarImage)
            // initialize star array with empty stars to match UI
            ratingStars.append(emptyStarImage)
        }
        updateStars()
    }

}
