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
        self.coloringPageImg = UIImage(named: "mtnHouseWithSun")
        self.filter = PaletteFilter(image: self.coloringPageImg)
        self.filter.toggle = false
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
    
    /*override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //NSLog("touchesBegan")
        self.filter.toggle = !self.filter.toggle
        self.filter.doFilter()
        self.coloringPageImgView.image = self.filter.outputUIImage
    }*/
    func updateFilter(sender:UITapGestureRecognizer)
    {
        NSLog("updateFilter began")
        self.filter.toggle = !self.filter.toggle
        self.filter.doFilter()
        self.coloringPageImgView.image = self.filter.outputUIImage;
    }
}
