//
//  ShapeFillViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/17/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ShapeFillViewController: UIViewController, UIScrollViewDelegate {

    var scrollView : UIScrollView!
    
    var toggle : Bool = false
    var blackOnlyImg : UIImage!
    var redOnlyImg : UIImage!
    var blueOnlyImg : UIImage!
    var whiteOnlyImg : UIImage!
    
    var coloringPageImgView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blackOnlyImg = UIImage(named: "blackOnly")
        self.redOnlyImg = UIImage(named: "redOnly")
        self.blueOnlyImg = UIImage(named: "blueOnly")
        self.whiteOnlyImg = UIImage(named: "whiteOnly")

        self.coloringPageImgView = UIImageView(image: self.redOnlyImg)
        self.scrollView = UIScrollView(frame: self.view.frame)
        self.scrollView.contentSize = self.coloringPageImgView.frame.size
        self.scrollView.addSubview(self.coloringPageImgView)
        self.scrollView.minimumZoomScale = 0.1
        self.scrollView.zoomScale = 1.0
        self.scrollView.maximumZoomScale = 20.0
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        var gestureRecognizer = UITapGestureRecognizer.init(target:self, action:"updateFilter:")
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(gestureRecognizer)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.coloringPageImgView
    }
    
    func updateFilter(sender:UITapGestureRecognizer)
    {
        var touchPoint : CGPoint = sender.locationOfTouch(0, inView: self.coloringPageImgView)
        var image1 : UIImage = self.redOnlyImg!
        var color : UIColor = image1.colorAtPixel(touchPoint)
        var red   : CGFloat = 0
        var green : CGFloat = 0
        var blue  : CGFloat = 0
        var alpha : CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha:&alpha)
        println("point x:\(touchPoint.x) y:\(touchPoint.y) color r:\(red) g:\(green) b:\(blue) a:\(alpha)")
        
        var rect : CGRect = CGRectMake(0, 0, image1.size.width, image1.size.height);
        UIGraphicsBeginImageContext(rect.size);
        var context : CGContextRef = UIGraphicsGetCurrentContext()!;
        CGContextClipToMask(context, rect, image1.CGImage);
        if (toggle) {
            CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor);
        } else {
            CGContextSetFillColorWithColor(context, UIColor.greenColor().CGColor);
        }
        toggle = !toggle
        
        CGContextFillRect(context, rect);
        var img : UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        var flippedImage : UIImage = UIImage(CGImage: img.CGImage, scale: 1.0, orientation: UIImageOrientation.DownMirrored)!
        self.coloringPageImgView.image = flippedImage
    }
}
