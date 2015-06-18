//
//  ColorChangeViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class CatShapesViewController: UIViewController, OBShapedViewDelegate {
    
    var catShape1View  : OBShapedView!
    var catShape2View  : OBShapedView!
    var catShape3View  : OBShapedView!
    var catShape4View  : OBShapedView!
    var catShape5View  : OBShapedView!
    var catShape6View  : OBShapedView!
    var catShape7View  : OBShapedView!
    var catShape8View  : OBShapedView!
    var catShape9View  : OBShapedView!
    var catShape10View : OBShapedView!
    var catShape11View : OBShapedView!
    var catShape12View : OBShapedView!
    var catShape13View : OBShapedView!
    
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
        
        catShape1View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape1"))
        catShape1View.delegate = self
        view.addSubview(catShape1View)
        
        catShape2View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape2"))
        catShape2View.delegate = self
        view.addSubview(catShape2View)
        
        catShape3View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape3"))
        catShape3View.delegate = self
        view.addSubview(catShape3View)
        
        catShape4View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape4"))
        catShape4View.delegate = self
        view.addSubview(catShape4View)
        
        catShape5View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape5"))
        catShape5View.delegate = self
        view.addSubview(catShape5View)
        
        catShape6View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape6"))
        catShape6View.delegate = self
        view.addSubview(catShape6View)
        
        catShape7View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape7"))
        catShape7View.delegate = self
        view.addSubview(catShape7View)
        
        catShape8View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape8"))
        catShape8View.delegate = self
        view.addSubview(catShape8View)
        
        catShape9View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape9"))
        catShape9View.delegate = self
        view.addSubview(catShape9View)
        
        catShape10View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape10"))
        catShape10View.delegate = self
        view.addSubview(catShape10View)
        
        catShape11View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape11"))
        catShape11View.delegate = self
        view.addSubview(catShape11View)
        
        catShape12View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape12"))
        catShape12View.delegate = self
        view.addSubview(catShape12View)
        
        catShape13View = OBShapedView(frame: view.frame, image:UIImage(named:"catShape13"))
        catShape13View.delegate = self
        view.addSubview(catShape13View)
    }
}
