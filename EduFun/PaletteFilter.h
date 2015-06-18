//
//  PaletteFilter.h
//  appleSpriteKitTut2
//
//  Created by Douglas Voss on 6/16/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

#define kSizeOfColor 4
#define kColorCubeSideSize 64
#define kColorCubeSize kColorCubeSideSize * kColorCubeSideSize * kColorCubeSideSize * sizeof (float) * 4

@interface PaletteFilter : UIView

@property (strong, nonatomic) UIImage *inputUIImage;
@property (strong, nonatomic) CIImage *inputCIImage;
@property (assign, nonatomic) BOOL toggle;
@property (assign, nonatomic) float *cubeData;
@property (assign, nonatomic) float *cubeData2;
@property (strong, nonatomic) NSData *cubeNSData;
@property (strong, nonatomic) NSData *cubeNSData2;
@property (strong, nonatomic) CIContext *ciContext;
@property (strong, nonatomic) CIFilter *filter;
@property (strong, nonatomic) CIImage *outputCIImage;
@property (strong, nonatomic) UIImage *outputUIImage;

- (instancetype)initWithImage:(UIImage *)inputUIImage;
- (void)updatePaletteFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
- (void)doFilter;

@end
