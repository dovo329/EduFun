//
//  THButton.swift
//  EduFun
//
//  Created by Douglas Voss on 6/25/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class THButton: UIControl {

    var label : THLabel!
    var normalTextColor : UIColor!
    var pressedTextColor : UIColor!
    var normalBackColor : UIColor!
    var pressedBackColor : UIColor!
    var beginTrackPoint : CGPoint = CGPointMake(0,0)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, text: String) {
        self.init(frame: frame)
        self.frame = frame
        normalTextColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0, alpha: 1.0)
        normalBackColor = UIColor(red: 0, green: 255.0/255.0, blue: 0.0, alpha: 1.0)
        
        pressedTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 0.0, alpha: 1.0)
        pressedBackColor = UIColor(red: 0, green: 128.0/255.0, blue: 0.0, alpha: 1.0)

        
        var scale = frame.width/160.0
        
        label = THLabel()
        label.frame.origin = CGPoint(x: 0,y: 0)
        label.frame.size = frame.size
        label.text = text
        label.font = UIFont(name: "Super Mario 256", size: 100.0)
        label.font = label.font.fontWithSize(getFontSizeToFitFrameOfLabel(label)-(5.0*scale))
        label.frame.origin.y += label.font.pointSize*1/8.0
        label.textAlignment = NSTextAlignment.Center
        label.textColor = normalTextColor
        label.strokeSize = 1.5*scale
        label.strokeColor = UIColor.blackColor()
        label.shadowOffset = CGSizeMake(label.strokeSize, label.strokeSize)
        label.shadowColor = UIColor.blackColor()
        label.shadowBlur = 1.0*scale
        //label.backgroundColor = UIColor.purpleColor()
        self.addSubview(label)
        
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 2.0*scale
        self.layer.cornerRadius = 10.0*scale
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 3.0*scale
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSizeMake(3.0*scale, 3.0*scale)
        self.layer.masksToBounds = true
        self.layer.backgroundColor = normalBackColor.CGColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        self.beginTrackPoint = touch.locationInView(self)
        //println("beginTracking @ \(self.beginTrackPoint)")
        self.layer.backgroundColor = pressedBackColor.CGColor
        self.label.textColor = pressedTextColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        var endTrackPoint : CGPoint = touch.locationInView(self)
        //println("endTracking @ \(endTrackPoint)")
        if  endTrackPoint.x >= 0 && endTrackPoint.y >= 0 &&
            endTrackPoint.x < self.frame.size.width && endTrackPoint.y < self.frame.size.height
        {
            //NSLog("touch up inside")
        } else
        {
            //NSLog("not touch up inside")
        }
        self.layer.backgroundColor = normalBackColor.CGColor
        self.label.textColor = normalTextColor
    }
}
