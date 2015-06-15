//
//  ColorCubeView.h
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCubeView : UIView

@property (strong, nonatomic) NSData *cubeNSData;

@property (assign, nonatomic) CGImageRef inputCGImg;
@property (assign, nonatomic) BOOL toggle;
@property (assign, nonatomic) BOOL firstTime;
@property (assign, nonatomic) float *cubeData; // color cube

@property (strong, nonatomic) CIContext *ciContext;
@property (strong, nonatomic) CIFilter *filter;
@property (strong, nonatomic) CIImage *inputCIImage;

-(void)updateFilter;

@end
