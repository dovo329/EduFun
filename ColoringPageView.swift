//
//  MaskedImage.swift
//  EduFun
//
//  Created by Douglas Voss on 6/12/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

enum ColorIndex: UInt32 {
        case colInd0 = 0xffff0000
        case colInd1 = 0xff0000ff
}

class ColoringPageView: UIView {
    
    let img = UIImage(named: "TestColorShape")!

    //var colorDict : [UInt32 : UInt32] = [UInt32 : UInt32]()
    var colorLUT : [UInt32]
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init coder not implemented")
    }
    
    override init(frame: CGRect) {
        
        //colorDict[0xff000000] = 0xff0000ff // change black to red
        //colorDict[0xffff0000] = 0xff00ff00 // change red to green
        //colorDict[0xff0000ff] = 0xffff00ff // change blue to pink (max red and blue)
        //colorDict[0xffffffff] = 0xff00ffff // change white to yellow (max green and red)
        
        colorLUT =
        [
            0xff00ffff, // 0 red to yellow
            0xffffff00  // 1 blue to whatever cyan
        ]
        super.init(frame:frame)
    }
    
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
                
                if (color == ColorIndex.colInd0.rawValue)
                {
                    color = colorLUT[0]
                    ptr.memory = color
                }
                
                if (color == ColorIndex.colInd1.rawValue)
                {
                    color = colorLUT[1]
                    ptr.memory = color
                }
                /*if colorDict[color] != nil // color exists in lookup
                {
                    //println(String(format:"colorDict[%x]==%x", color, colorDict[color]!))
                    color = colorDict[color]! // remap color
                } else {
                    println(String(format:"colorDict[%x]==nil", color))
                    fatalError("What happen?")
                }*/
                //print(String(format: "%x ", color))
                //print(String(format: "%x ", ptr))
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
