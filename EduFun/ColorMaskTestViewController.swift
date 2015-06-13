//
//  ColorMaskTestViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/12/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ColorMaskTestViewController: UIViewController {

    var toggle : Bool = true
    var touchesMovedCnt : Int = 0
    var coloringPageView : ColoringPageView = ColoringPageView()
    var colorSelBar : UIScrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coloringPageView.frame = self.view.frame
        self.view.addSubview(coloringPageView)
        
        self.colorSelBar.backgroundColor = UIColor.purpleColor()
        self.view.addSubview(colorSelBar)
        
        self.coloringPageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.colorSelBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let viewsDictionary = ["pg": self.coloringPageView, "bar": self.colorSelBar]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[pg][bar(==100)]|",
            options: nil,
            metrics: nil,
            views: viewsDictionary))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pg]|",
            options: nil,
            metrics: nil,
            views: viewsDictionary))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bar]|",
            options: nil,
            metrics: nil,
                    views: viewsDictionary))
        
        //self.view.backgroundColor = UIColor.blueColor()
        
        //self.view.addSubview(bgImgView)
        
        /*self.bgImgView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let viewsDictionary = ["bg": self.bgImgView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bg]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bg]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
        
        self.view.addSubview(triangleImgView)*/
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.touchesMovedCnt=0
        var touch : UITouch = touches.first as! UITouch
        var pointTouched : CGPoint = touch.locationInView(self.view)
        println("touches began pointTouched x:\(pointTouched.x) y:\(pointTouched.y)")
        
        if (pointTouched.x > 160.0) {
            //self.triangleImgView.tintColor = UIColor.redColor()
        } else {
            //self.triangleImgView.tintColor = UIColor.blueColor()
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.touchesMovedCnt++
        var touch : UITouch = touches.first as! UITouch
        var pointTouched : CGPoint = touch.locationInView(self.view)
        println("touches moved cnt \(self.touchesMovedCnt) began pointTouched x:\(pointTouched.x) y:\(pointTouched.y)")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.touchesMovedCnt=0
        var touch : UITouch = touches.first as! UITouch
        var pointTouched : CGPoint = touch.locationInView(self.view)
        println("touches ended pointTouched x:\(pointTouched.x) y:\(pointTouched.y)")
        
        if (self.toggle)
        {
            self.coloringPageView.colorLUT =
            [
                0xff808080, // 0 red to gray
                0xff0080ff  // 1 blue to ?
            ]
        } else {
            self.coloringPageView.colorLUT =
            [
                0xff00ffff, // 0 red to yellow
                0xffffff00  // 1 blue to whatever cyan
            ]
        }
        self.coloringPageView.setNeedsDisplay()
        self.toggle = !self.toggle
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        var touch : UITouch = touches.first as! UITouch
        var pointTouched : CGPoint = touch.locationInView(self.view)
        println("touches cancelled pointTouched x:\(pointTouched.x) y:\(pointTouched.y)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
