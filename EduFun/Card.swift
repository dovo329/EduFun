//
//  Card.swift
//  EduFun
//
//  Created by Douglas Voss on 6/9/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

let kInterCardMargin : CGFloat = 15.0

class Card : UIButton {
    let cardBackImg : UIImage = UIImage(named: "CardBack")!
    
    var img : UIImage
    var isFlipped : Bool
    {
        didSet {
            if (self.isFlipped) {
                self.setImage(self.img, forState: .Normal)
            } else {
                self.setImage(cardBackImg, forState: .Normal)
            }
        }
    }

    var row : CGFloat = 0.0
    var column : CGFloat = 0.0
    var width : CGFloat = 0.0
    var height : CGFloat = 0.0
    
    init (imgName:String, isFlippedBool:Bool, row:CGFloat, column:CGFloat, width:CGFloat, height:CGFloat) {
        
        self.img = UIImage(named:imgName)!
        self.row = row
        self.column = column
        self.width = width
        self.height = height
        self.isFlipped = isFlippedBool
        
        var buttonFrame : CGRect = CGRectMake(column*(self.width+kInterCardMargin), row*(self.height+kInterCardMargin), self.width, self.height)
        super.init(frame:buttonFrame)
        
        //self.frame = CGRectMake(column*(self.width+kInterCardMargin), row*(self.height+kInterCardMargin), self.width, self.height)
        self.imageView?.contentMode = .ScaleToFill
        
        if (self.isFlipped) {
            self.setImage(self.img, forState: .Normal)
        } else {
            self.setImage(cardBackImg, forState: .Normal)
        }
        //self.addTarget(self, action:"buttonMethod:", forControlEvents: .TouchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
