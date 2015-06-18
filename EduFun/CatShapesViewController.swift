//
//  ColorChangeViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class CatShapesViewController: UIViewController, OBShapedViewDelegate, UIScrollViewDelegate {
    
    let kNumShapes : Int = 13
    var shapeViewArr  : [OBShapedView] = [OBShapedView]()
    var tapGesture : UITapGestureRecognizer!
    var contentView : UIView!
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
        imgView.tintColor = colorList[colorListIndex]
        colorListIndex++
        if (colorListIndex >= colorList.count)
        {
            colorListIndex = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.frame)
        contentView = UIView(frame: view.frame)
        
        for var i=0; i<kNumShapes; i++
        {
            var imgStr : String = String(format:"catShape%d",i+1)
            println("\(imgStr)")
            shapeViewArr.append(OBShapedView(frame: view.frame, image:UIImage(named:imgStr)))
            shapeViewArr[i].delegate = self
            //view.addSubview(shapeViewArr[i])
            contentView.addSubview(shapeViewArr[i])
        }
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        //tapGesture = UITapGestureRecognizer(target: self, action: "tapHandle")
        //tapGesture.cancelsTouchesInView = false
        //scrollView.addGestureRecognizer(tapGesture)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height)
        scrollView.delegate = self
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    /*func tapHandle()
    {
        println("Tappy tap tap")
    }*/
}
