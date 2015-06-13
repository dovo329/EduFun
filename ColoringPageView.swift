//
//  MaskedImage.swift
//  EduFun
//
//  Created by Douglas Voss on 6/12/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ColoringPageView: UIView {
    
    let img = UIImage(named: "TestColorShape")!

    let maskColor1 : [CGFloat] = [255.0, 255.0, 0.0, 0.0, 0.0, 0.0]
    let maskColor2 : [CGFloat] = [0.0, 0.0, 0.0, 0.0, 255.0, 255.0]
    
    override func drawRect(rect: CGRect) {
        println("drawRect called")
        var CGImg : CGImageRef = img.CGImage
        
        var width = CGImageGetWidth(CGImg);
        var height = CGImageGetHeight(CGImg);
        let bytesPerPixel = 4;
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        var pixels : UnsafeMutablePointer<Void> = calloc(height * width, sizeof(UInt32))
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
        
        var bmpContext = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)
        
        CGContextDrawImage(bmpContext, CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height)), CGImg)
        //CGContextDrawImage(bmpContext, rect, CGImg)
        
        var ptr = UnsafeMutablePointer<UInt32>(pixels)
        for var j=0; j < height; j++
        {
            for var i=0; i < width; i++
            {
                var color : UInt32 = ptr.memory
                var red = color & 0x000000ff
                var green = (color & 0x0000ff00)>>8
                var blue = (color & 0x00ff0000)>>16
                
                if (red == 0xff) && (blue==0x00) && (green==0x00)
                {
                    // change red to green
                    color = 0x0000ff00
                } else if (red == 0x00) && (blue==0xff) && (green==0x00)
                {
                    // change blue to yellow
                    color = 0x00ff00ff
                }
                //print(String(format: "%x ", color))
                //print(String(format: "%x ", ptr))
                ptr.memory = color
                ptr++
            }
            //println("")
            //println(String(format:"j=%d", j))
        }
        
        var updatedCGImg = CGBitmapContextCreateImage(bmpContext)
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, self.frame.size.height)
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0)
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, updatedCGImg);
    }
    
/*
    
    
    #define Mask8(x) ( (x) & 0xFF )
    #define RED(x) ( Mask8(x) )
    #define GREEN(x) ( Mask8(x >> 8 ) )
    #define BLUE(x) ( Mask8(x >> 16) )
    
    NSLog(@"Brightness of image:");
    UInt32 * currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
    for (NSUInteger i = 0; i < width; i++) {
    UInt32 color = *currentPixel;
    //printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
    //printf("%d ",R(color));
    if (RED(color) == 255 && BLUE(color) == 0 && GREEN(color) == 0)
    {
    // change red to green
    color = 0x0000ff00;
    }
    
    if (RED(color) == 0 && BLUE(color) == 255 && GREEN(color) == 0)
    {
    // change blue to pink
    color = 0x00ff00ff;
    }
    *currentPixel = color;
    currentPixel++;
    }
    printf("\n");
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    //CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, inputCGImage);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, newCGImage);
    }*/
}
