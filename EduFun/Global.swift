//
//  Global.swift
//  EduFun
//
//  Created by Douglas Voss on 6/25/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

public func getFontSizeToFitWidthOfLabel(label: UILabel) -> CGFloat
{
    var initialSize : CGSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
    
    if (initialSize.width > label.frame.size.width)
    {
        while ( initialSize.width > label.frame.size.width)
        {
            label.font = label.font.fontWithSize(label.font.pointSize - 1)
            initialSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
        }
    } else {
        while ( initialSize.width < label.frame.size.width)
        {
            label.font = label.font.fontWithSize(label.font.pointSize + 1)
            initialSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
        }
    }
    return label.font.pointSize;
}
