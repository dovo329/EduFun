//
//  Card.swift
//  CollectionViewTest
//
//  Created by Douglas Voss on 6/11/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class Card {
    var isFlipped : Bool = false
    var imageName : String?
    var matched : Bool = false
    var row : Int = 0
    var column : Int = 0
    
    init () {
        self.isFlipped = false
        self.imageName = "CardBack"
        self.matched = false
        self.row = 0
        self.column = 0
    }
}
