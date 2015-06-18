//
//  ColorChangeViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ColorChangeViewController: UIViewController, OBShapedViewDelegate, UIScrollViewDelegate {

    var blackView : OBShapedView!
    var whiteView : OBShapedView!
    var blueView  : OBShapedView!
    var redView  : OBShapedView!
    var contentView : UIView!
    var toggle : Bool = false
    var scrollView : UIScrollView!
    
    var currentColor : UIColor = UIColor.purpleColor()
    let colorList : [UIColor] =
    [
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.blueColor(),
        UIColor.purpleColor()
    ]
    var colorListIndex : Int = 0
    
    func changeTintColorOfImageView(imgView: UIImageView!) {
        /*if (toggle)
        {
            NSLog("delegate method called toggle1")
            imgView.tintColor = UIColor.yellowColor()
        } else {
            NSLog("delegate method called toggle2")
            imgView.tintColor = UIColor.greenColor()
        }
        toggle = !toggle*/
        imgView.tintColor = colorList[colorListIndex]
        colorListIndex++
        if (colorListIndex >= colorList.count)
        {
            colorListIndex = 0
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        blackView = OBShapedView(frame: view.frame, image:UIImage(named:"blackOnlySmall"))
        blackView.delegate = self
        blackView.userInteractionEnabled = false // don't let them change colors on the black outlines
        
        redView = OBShapedView(frame: view.frame, image:UIImage(named:"redOnlySmall"))
        redView.delegate = self
        
        blueView = OBShapedView(frame: view.frame, image:UIImage(named:"blueOnlySmall"))
        blueView.delegate = self
        
        whiteView = OBShapedView(frame: view.frame, image:UIImage(named:"whiteOnlySmall"))
        whiteView.delegate = self

        /*contentView = UIView()
        contentView.addSubview(blackView)
        contentView.addSubview(redView)
        contentView.addSubview(blueView)
        contentView.addSubview(whiteView)
        contentView.userInteractionEnabled = false
        contentView.backgroundColor = UIColor.clearColor()
        
        scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.contentSize = contentView.frame.size
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        scrollView.maximumZoomScale = 20.0
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)*/
        
        view.addSubview(blackView)
        view.addSubview(redView)
        view.addSubview(blueView)
        view.addSubview(whiteView)
    }
}
