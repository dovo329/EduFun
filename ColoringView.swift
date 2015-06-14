//
//  ColoringView.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit


class ColoringView: UIView {
    var img : UIImage
    var imgView : UIImageView
    var color : UIColor
    
    override init(frame: CGRect) {
        img = UIImage(named: "redOnlySmall")!
        imgView = UIImageView(image: img)
        imgView.frame = frame
        imgView.image = imgView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        color = UIColor.yellowColor()
        imgView.tintColor = color
        
        super.init(frame: frame)
        
        self.addSubview(imgView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    //- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var color : UIColor = imgView.image!.colorAtPixel(point)
        var components : UnsafePointer<CGFloat> = CGColorGetComponents(color.CGColor)
        var red = components[0]
        var green = components[1]
        var blue = components[2]
        var alpha = components[3]
        
        NSLog(String(format:"pointInside called colorAtPixel r:%f g:%f b:%f a:%f", red, green, blue, alpha))
        return true
    }
}
