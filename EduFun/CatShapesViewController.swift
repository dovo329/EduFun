//
//  ColorChangeViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class CatShapesViewController: UIViewController, OBShapedViewDelegate {
    
    var shapeViewArr  : [OBShapedView] = [OBShapedView]()
    
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
        
        for var i=0; i<13; i++
        {
            var imgStr : String = String(format:"catShape%d",i+1)
            println("\(imgStr)")
            shapeViewArr.append(OBShapedView(frame: view.frame, image:UIImage(named:imgStr)))
            shapeViewArr[i].delegate = self
            view.addSubview(shapeViewArr[i])
        }
    }
}
