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
        view.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view.
        //coloringPageImg = UIImage(named: "ColoringBookPictureScanBW")
        //coloringPageImg = UIImage(named: "BWonly")
        coloringPageImg = UIImage(named: "CatOutlineBWRGB")
        //coloringPageImg = UIImage(named: "mtnHouseWithSun")
        //coloringPageImg = UIImage(named: "TestColorShapeBig")
        //coloringPageImg = UIImage(named: "TestColorShape4Sscaled")
        //coloringPageImg = UIImage(named: "testSmallImg")
        
        /*var dataProvider : CGDataProviderRef = CGDataProviderCreateWithFilename("TestColorShape4Sscaled.png")
        var cgImg : CGImageRef = CGImageCreateWithPNGDataProvider(dataProvider, nil, false, kCGRenderingIntentDefault)
        
        coloringPageImg = UIImage(CGImage: cgImg)*/
        
        //coloringPageImg = UIImage(named: "testSmallImg")
        filter = PaletteFilter(image: coloringPageImg)
        filter.toggle = true
        //filter.layer.magnificationFilter = kCAFilterNearest
        filter.doFilter()
        //coloringPageImgView = UIImageView(image: filter.outputUIImage)
        coloringPageImgView = UIImageView(image: filter.outputUIImage)
        coloringPageImgView.layer.magnificationFilter = kCAFilterNearest
        //view.backgroundColor = UIColor.orangeColor()
        //view.addSubview(coloringPageImgView)
        
        scrollView = UIScrollView(frame: view.frame)
        scrollView.contentSize = coloringPageImgView.frame.size
        scrollView.addSubview(coloringPageImgView)
        scrollView.minimumZoomScale = 0.1
        scrollView.zoomScale = 1.0
        scrollView.maximumZoomScale = 20.0
        scrollView.delegate = self
        view.addSubview(scrollView)
        //filter.frame = view.frame
        //view.addSubview(filter)
        
        var gestureRecognizer = UITapGestureRecognizer.init(target:self, action:"updateFilter:")
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(gestureRecognizer)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return coloringPageImgView
    }
    
    func updateFilter(sender:UITapGestureRecognizer)
    {
        var touchPoint : CGPoint = sender.locationOfTouch(0, inView: coloringPageImgView)
        var color : UIColor = coloringPageImg.colorAtPixel(touchPoint)
        var red   : CGFloat = 0
        var green : CGFloat = 0
        var blue  : CGFloat = 0
        var alpha : CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha:&alpha)
        //NSLog("updateFilter began")
        println("point x:\(touchPoint.x) y:\(touchPoint.y) color r:\(red) g:\(green) b:\(blue) a:\(alpha)")
        var toColor = UIColor.purpleColor()
        filter.updatePaletteFromColor(color, toColor: toColor);
        //filter.toggle = !filter.toggle
        filter.doFilter()
        coloringPageImgView.image = filter.outputUIImage
        
        //coloringPageImgView.removeFromSuperview()
        //coloringPageImgView = UIImageView(image: filter.outputUIImage)
        //scrollView.addSubview(coloringPageImgView)
    }
}
