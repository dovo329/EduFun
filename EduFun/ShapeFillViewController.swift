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
    var blackOnlyImgView : UIImageView!
    var redOnlyImgView : UIImageView!
    var blueOnlyImgView : UIImageView!
    var whiteOnlyImgView : UIImageView!
    
    var coloringPageView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blackOnlyImgView = UIImageView(image: UIImage(named: "blackOnly"))
        redOnlyImgView = UIImageView(image: UIImage(named: "redOnly"))
        blueOnlyImgView = UIImageView(image: UIImage(named: "blueOnly"))
        whiteOnlyImgView = UIImageView(image: UIImage(named: "whiteOnly"))
        
        coloringPageView = UIView(frame: view.frame)
        coloringPageView.addSubview(redOnlyImgView)
        coloringPageView.addSubview(blackOnlyImgView)
        coloringPageView.addSubview(blueOnlyImgView)
        coloringPageView.addSubview(whiteOnlyImgView)

        scrollView = UIScrollView(frame: view.frame)
        scrollView.contentSize = coloringPageView.frame.size
        scrollView.addSubview(coloringPageView)
        scrollView.minimumZoomScale = 0.1
        scrollView.zoomScale = 1.0
        scrollView.maximumZoomScale = 20.0
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        var gestureRecognizer = UITapGestureRecognizer.init(target:self, action:"updateFilter:")
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(gestureRecognizer)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return coloringPageView
    }
    
    func updateFilter(sender:UITapGestureRecognizer)
    {
        var touchPoint : CGPoint = sender.locationOfTouch(0, inView: coloringPageView)
        var image1 : UIImage = redOnlyImgView.image!
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
        
        var flippedImage : UIImage!
        if (toggle)
        {
            flippedImage = UIImage(CGImage: img.CGImage, scale: 1.0, orientation: UIImageOrientation.DownMirrored)!
        } else {
            flippedImage = UIImage(CGImage: img.CGImage, scale: 1.0, orientation: UIImageOrientation.Up)!
        }
        redOnlyImgView.image = flippedImage
    }
}
