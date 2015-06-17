//
//  PaletteFilterViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/16/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class PaletteFilterViewController: UIViewController, UIScrollViewDelegate {

    var scrollView : UIScrollView!
    var coloringPageImg : UIImage!
    var coloringPageImgView : UIImageView!
    var filter : PaletteFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.coloringPageImg = UIImage(named: "mtnHouseWithSun")
        self.coloringPageImg = UIImage(named: "TestColorShapeBig")
        self.filter = PaletteFilter(image: self.coloringPageImg)
        self.filter.toggle = true
        self.filter.doFilter()
        self.coloringPageImgView = UIImageView(image: self.filter.outputUIImage)
        
        self.scrollView = UIScrollView(frame: self.view.frame)
        self.scrollView.contentSize = self.coloringPageImgView.frame.size
        self.scrollView.addSubview(self.coloringPageImgView)
        self.scrollView.minimumZoomScale = 0.1
        self.scrollView.zoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
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
        var color : UIColor = self.coloringPageImg.colorAtPixel(touchPoint)
        var red   : CGFloat = 0
        var green : CGFloat = 0
        var blue  : CGFloat = 0
        var alpha : CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha:&alpha)
        //NSLog("updateFilter began")
        println("point x:\(touchPoint.x) y:\(touchPoint.y) color r:\(red) g:\(green) b:\(blue) a:\(alpha)")
        var toColor = UIColor.greenColor()
        self.filter.updatePaletteFromColor(color, toColor: toColor);
        //self.filter.toggle = !self.filter.toggle
        self.filter.doFilter()
        self.coloringPageImgView.image = self.filter.outputUIImage;
    }
}
