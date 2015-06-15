//
//  ColorCubeViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ColorCubeViewController: UIViewController {

    let UIImg = UIImage(named:"TestColorShape4Sscaled")!
    var testView : ColorCubeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testView = ColorCubeView()
        
        //testView.inputCGImg = UIImg.CGImage
        self.testView.toggle = false
        self.testView.frame = self.view.frame
        self.view.addSubview(self.testView)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        var touch = touches.first as! UITouch
        var point = touch.locationInView(self.view)
        
        //NSLog("toggle")
        self.testView.toggle = !(self.testView.toggle)
        // convert point to pixel
        point.x *= 2.0
        point.y *= 2.0
        var color : UIColor = self.UIImg.colorAtPixel(point)
        
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        color.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        let iRed = Int(fRed * 255.0)
        let iGreen = Int(fGreen * 255.0)
        let iBlue = Int(fBlue * 255.0)
        let iAlpha = Int(fAlpha * 255.0)
            
        println("color at touches x:\(point.x) y:\(point.y) is r:\(iRed) g:\(iGreen) b:\(iBlue) a:\(iAlpha)")
        //self.testView.updateFilter()
        self.testView.setNeedsDisplay()
        
        //println("touchesBegan")
    }
}
