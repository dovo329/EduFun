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
    var beginTrackPoint : CGPoint = CGPoint(x: 0, y: 0)

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

        
        let scale = frame.width/160.0
        
        label = THLabel()
        label.frame.origin = CGPoint(x: 0,y: 0)
        label.frame.size = frame.size
        label.text = text
        label.font = UIFont(name: "Super Mario 256", size: 100.0)
        label.font = label.font.withSize(getFontSizeToFitFrameOfLabel(label: label)-(5.0*scale))
        label.frame.origin.y += label.font.pointSize*1/8.0
        label.textAlignment = NSTextAlignment.center
        label.textColor = normalTextColor
        label.strokeSize = 1.5*scale
        label.strokeColor = UIColor.black
        label.shadowOffset = CGSize(width: label.strokeSize, height: label.strokeSize)
        label.shadowColor = UIColor.black
        label.shadowBlur = 1.0*scale
        //label.backgroundColor = UIColor.purpleColor()
        self.addSubview(label)
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0*scale
        self.layer.cornerRadius = 10.0*scale
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0*scale
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 3.0*scale, height: 3.0*scale)
        self.layer.masksToBounds = true
        self.layer.backgroundColor = normalBackColor.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginTracking(_ touch: UITouch, with  event: UIEvent?) -> Bool {
        self.beginTrackPoint = touch.location(in: self)
        //println("beginTracking @ \(self.beginTrackPoint)")
        self.layer.backgroundColor = pressedBackColor.cgColor
        self.label.textColor = pressedTextColor
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let endTrackPoint : CGPoint = touch!.location(in: self)
        //println("endTracking @ \(endTrackPoint)")
        if  endTrackPoint.x >= 0 && endTrackPoint.y >= 0 &&
            endTrackPoint.x < self.frame.size.width && endTrackPoint.y < self.frame.size.height
        {
            //NSLog("touch up inside")
        } else
        {
            //NSLog("not touch up inside")
        }
        self.layer.backgroundColor = normalBackColor.cgColor
        self.label.textColor = normalTextColor
    }
}
