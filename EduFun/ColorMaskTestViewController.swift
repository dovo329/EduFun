//
//  ColorMaskTestViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/12/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ColorMaskTestViewController: UIViewController {

    var bgImgView : UIImageView = UIImageView(image: UIImage(named: "TestColorShape"))
    var triangleImgView : UIImageView = UIImageView(image: UIImage(named: "Triangle")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
    var touchesMovedCnt : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var coloringPageView : ColoringPageView = ColoringPageView()
        coloringPageView.frame = self.view.frame
        self.view.addSubview(coloringPageView)
        
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
