//
//  RatingControl.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/9/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class RatingControl: NSStackView {
    
    var ratingControlDelegate: RatingControlDelegate? = nil
    
    //MARK: Properties
    
    var rating = 0 {
        didSet {
            updateStars()
            if let ratingControlDelegate = ratingControlDelegate {
                ratingControlDelegate.updateRating(self, rating: Double(rating))
            }
            else {
                print("rating control delegate is nil")
            }
        }
    }
    
    // set star sizes proportionate to size of RatingControl UI element
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
    
    // when user clicks in this view,
    // grab location and calculate which star image user clicked on
    override func mouseDown(with event: NSEvent) {
        let eventLocation: NSPoint = convert(event.locationInWindow, from: nil)
        rating = (Int(eventLocation.x) / Int(starSize.width)) + 1
    }
    
    
    //MARK: Methods

    // update UI stars according to current rating
    private func updateStars() {
        if rating <= starCount { // make sure rating is not higher than number of stars
            // add filled stars to show rating
            for i in 0..<rating {
                ratingStars[i].image = #imageLiteral(resourceName: "filledStar")
            }
            // fill in remaining with empty stars
            for i in rating..<starCount {
                ratingStars[i].image = #imageLiteral(resourceName: "emptyStar")
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
