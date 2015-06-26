//
//  Global.swift
//  EduFun
//
//  Created by Douglas Voss on 6/25/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

public func getFontSizeToFitFrameOfLabel(label: UILabel) -> CGFloat
{
    var initialSize : CGSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
    
    if initialSize.width > label.frame.size.width ||
       initialSize.height > label.frame.size.height
    {
        while initialSize.width > label.frame.size.width ||
              initialSize.height > label.frame.size.height
        {
            label.font = label.font.fontWithSize(label.font.pointSize - 1)
            initialSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
            println("label.size w=\(label.frame.size.width) h=\(label.frame.size.height)")
            println("initial.size w=\(initialSize.width) h=\(initialSize.height)")
            println("font.pointSize=\(label.font.pointSize)")
            println("")
        }
    } else {
        while initialSize.width < label.frame.size.width &&
              initialSize.height < label.frame.size.height
        {
            label.font = label.font.fontWithSize(label.font.pointSize + 1)
            initialSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
            println("label.size w=\(label.frame.size.width) h=\(label.frame.size.height)")
            println("initial.size w=\(initialSize.width) h=\(initialSize.height)")
            println("font.pointSize=\(label.font.pointSize)")
            println("")
        }
        label.font = label.font.fontWithSize(label.font.pointSize - 1)
    }
    return label.font.pointSize;
}

public func cgColorForRed(red: CGFloat, #green: CGFloat, #blue: CGFloat) -> AnyObject {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).CGColor as AnyObject
}