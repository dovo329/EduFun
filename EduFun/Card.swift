//
//  Card.swift
//  EduFun
//
//  Created by Douglas Voss on 6/9/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

let kInterCardMargin : CGFloat = 15.0

class Card {
    var cardView : UIView
    var cardBackImgView : UIImageView = UIImageView(image: UIImage(named: "CardBack")!)
    
    var cardFrontImgView : UIImageView
    var isFlipped : Bool
    {
        didSet {
            if (self.isFlipped) {
                UIView.transitionFromView(self.cardFrontImgView, toView:self.cardBackImgView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            } else {
                UIView.transitionFromView(self.cardBackImgView, toView:self.cardFrontImgView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            }
        }
    }

    var row : CGFloat = 0.0
    var column : CGFloat = 0.0
    var width : CGFloat = 0.0
    var height : CGFloat = 0.0
    
    init (imgName:String, isFlippedBool:Bool, row:CGFloat, column:CGFloat, width:CGFloat, height:CGFloat) {
        
        self.cardFrontImgView = UIImageView(image: UIImage(named: imgName)!)
        self.row = row
        self.column = column
        self.width = width
        self.height = height
        self.isFlipped = isFlippedBool
        
        self.cardBackImgView.contentMode = .ScaleToFill
        self.cardFrontImgView.contentMode = .ScaleToFill

        var imgFrame : CGRect = CGRectMake(0.0, 0.0, self.width, self.height)
        
        self.cardFrontImgView.frame = imgFrame
        self.cardBackImgView.frame = imgFrame
        
        var cardFrame : CGRect = CGRectMake(column*(self.width+kInterCardMargin), row*(self.height+kInterCardMargin), self.width, self.height)
        
        self.cardView = UIView(frame:cardFrame)
        self.cardView.addSubview(self.cardBackImgView)

        
        //self.frame = CGRectMake(column*(self.width+kInterCardMargin), row*(self.height+kInterCardMargin), self.width, self.height)
        
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
