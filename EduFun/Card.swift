//
//  Card.swift
//  EduFun
//
//  Created by Douglas Voss on 6/9/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

let kInterCardMargin : CGFloat = 15.0

class Card : NSObject {
    let cardBackImg : UIImage = UIImage(named: "CardBack")!
    
    var img : UIImage
    var isFlipped : Bool
    {
        didSet {
            if (self.isFlipped) {
                self.button.setImage(self.img, forState: .Normal)
            } else {
                self.button.setImage(cardBackImg, forState: .Normal)
            }
        }
    }

    var button : UIButton
    var row : CGFloat = 0.0
    var column : CGFloat = 0.0
    var width : CGFloat = 0.0
    var height : CGFloat = 0.0
    
    init (imgName:String, isFlippedBool:Bool, row:CGFloat, column:CGFloat, width:CGFloat, height:CGFloat) {
        
        self.img = UIImage(named:imgName)!
        self.button = (UIButton.buttonWithType(.Custom) as? UIButton)!
        self.row = row
        self.column = column
        self.width = width
        self.height = height
        self.button.frame = CGRectMake(column*(self.width+kInterCardMargin), row*(self.height+kInterCardMargin), self.width, self.height)
        self.button.imageView?.contentMode = .ScaleToFill
        self.isFlipped = isFlippedBool
        if (self.isFlipped) {
            self.button.setImage(self.img, forState: .Normal)
        } else {
            self.button.setImage(cardBackImg, forState: .Normal)
        }
        super.init()
        //self.button.addTarget(self, action:"buttonMethod:", forControlEvents: .TouchUpInside)
    }
    
    /*func buttonMethod(sender: UIButton!) {
        println("button at row:\(row) column:\(column) was pressed")
    }*/
    
    /*override func description() -> String {
        var descString = ""
        descString += "isFlipped==\(self.isFlipped)\r"
        descString += "width==\(self.width)\r"
        descString += "height==\(self.height)\r"
        return descString
    }*/
}
