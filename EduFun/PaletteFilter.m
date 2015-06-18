//
//  PaletteFilter.m
//  appleSpriteKitTut2
//
//  Created by Douglas Voss on 6/16/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

#import "PaletteFilter.h"

@implementation PaletteFilter

- (instancetype)initWithImage:(UIImage *)inputUIImage
{
    self = [super init];
    if (self) {
        self.toggle = false;
        // Allocate memory
        self.ciContext = [CIContext contextWithOptions:nil];
        
        self.inputUIImage = inputUIImage;
        self.inputCIImage = [[CIImage alloc] initWithCGImage:self.inputUIImage.CGImage];
        
        // Set data for cube
        self.cubeData = (float *)malloc (kColorCubeSize);
        
        float rgb[3], *c = self.cubeData;
        // Populate cube with a simple gradient going from 0 to 1
        for (int z = 0; z < kColorCubeSideSize; z++){
            rgb[2] = ((double)z)/(kColorCubeSideSize-1); // Blue value
            for (int y = 0; y < kColorCubeSideSize; y++){
                rgb[1] = ((double)y)/(kColorCubeSideSize-1); // Green value
                for (int x = 0; x < kColorCubeSideSize; x ++){
                    rgb[0] = ((double)x)/(kColorCubeSideSize-1); // Red value
                    // Calculate premultiplied alpha values for the cube
                    c[0] = rgb[0]; // red
                    c[1] = rgb[1]; // green
                    c[2] = rgb[2]; // blue
                    c[3] = 1.0; // alpha
                    c += 4; // advance our pointer into memory for the next color value
                }
            }
        }
        // Create memory with the cube data
        self.cubeNSData = [NSData dataWithBytesNoCopy:self.cubeData
                                               length:kColorCubeSize
                                         freeWhenDone:NO];
        
        self.toggle = !self.toggle;
        self.cubeData2 = (float *)malloc (kColorCubeSize);
        c = self.cubeData;
        float *c2 = self.cubeData2;
        // Populate cube with a simple gradient going from 0 to 1
        for (int z = 0; z < kColorCubeSideSize; z++){
            rgb[2] = ((double)z)/(kColorCubeSideSize-1); // Blue value
            for (int y = 0; y < kColorCubeSideSize; y++){
                rgb[1] = ((double)y)/(kColorCubeSideSize-1); // Green value
                for (int x = 0; x < kColorCubeSideSize; x ++){
                    rgb[0] = ((double)x)/(kColorCubeSideSize-1); // Red value
                    // Calculate premultiplied alpha values for the cube
                    //c2[0] = rgb[2];
                    //c2[1] = rgb[0];
                    //c2[2] = rgb[1];
                    //if (rgb[0]==1.0 && rgb[1]==0.0 && rgb[2]==0.0) {
                    //if (rgb[1]==0.0 && rgb[2]==0.0) {
                    
                    //if (x >= ((kColorCubeSideSize-1)-16) && rgb[1]==0.0 && rgb[2]==0.0) { // this one works but why?  why does it think I have a range of red when I don't?
                    // because it's interpolating somewhere and changing the red amount to less than max
                    if (y == 0 && z == 0 && x >= (kColorCubeSideSize-1))
                    {
                        c2[0] = 0.0;
                        c2[1] = rgb[0];
                        c2[2] = 0.0;
                    } else {
                        c2[0] = c[0];
                        c2[1] = c[1];
                        c2[2] = c[2];
                    }
                    c2[3] = 1.0;
                    c2 += kSizeOfColor; // advance our pointer into memory for the next color value
                    c += kSizeOfColor;
                }
            }
        }
        // Create memory with the cube data
        self.cubeNSData2 = [NSData dataWithBytesNoCopy:self.cubeData2
                                                length:kColorCubeSize
                                          freeWhenDone:NO];
        
        self.filter = [CIFilter filterWithName:@"CIColorCube"];
        [self.filter setValue:@(kColorCubeSideSize) forKey:@"inputCubeDimension"];
        // Set data for cube
        [self.filter setValue:self.cubeNSData forKey:@"inputCubeData"];
        [self.filter setValue:self.inputCIImage forKey:kCIInputImageKey];
    }
    return self;
}

- (void)updatePaletteFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    float *ptr = self.cubeData;
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [fromColor getRed:&red green:&green blue:&blue alpha:&alpha];
    // convert from 0-255.0 to 0-63.0
    int intRed = (int)floor(red*63.0);
    int intGreen = (int)floor(green*63.0);
    int intBlue = (int)floor(blue*63.0);
    
    ptr += kSizeOfColor*(kColorCubeSideSize*kColorCubeSideSize)*intBlue;
    ptr += kSizeOfColor*(kColorCubeSideSize)*intGreen;
    ptr += kSizeOfColor*intRed;
    
    CGFloat toRed = 0.0;
    CGFloat toGreen = 0.0;
    CGFloat toBlue = 0.0;
    CGFloat toAlpha = 0.0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    // convert from 0-255.0 to 0-63.0
    
    // update color cube for this index only
    ptr[0] = (toRed*63.0); // red
    ptr[1] = (toGreen*63.0); // green
    ptr[2] = (toBlue*63.0); // blue
    ptr[3] = 1.0; // alpha
}

- (void)doFilter {
    if (self.toggle)
    {
        [self.filter setValue:self.cubeNSData forKey:@"inputCubeData"];
    } else {
        [self.filter setValue:self.cubeNSData2 forKey:@"inputCubeData"];
    }
    
    /*+(UIImage*)sepian:(UIImage*)img withInensity:(float)intensity{
        
        CIImage *cimage = [[CIImage alloc] initWithImage:img];
        
        CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
        [sepiaFilter setDefaults];
        [sepiaFilter setValue:cimage forKey:@"inputImage"];
        [sepiaFilter setValue:[NSNumber numberWithFloat:intensity]
                       forKey:@"inputIntensity"];
        
        CIImage *outputImage = [sepiaFilter outputImage];
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:
                              outputImage fromRect:[outputImage extent]];
        UIImage *resultUIImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultUIImage;*/
    
    self.outputCIImage = [self.filter valueForKey:kCIOutputImageKey];
    //self.outputUIImage = [self createNonInterpolatedUIImageFromCIImage:self.outputCIImage withScale:1.0];
    self.outputUIImage = [[UIImage alloc] initWithCIImage:self.outputCIImage];
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width, image.extent.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    [self.filter setValue:self.cubeNSData2 forKey:@"inputCubeData"];
    self.outputCIImage = [self.filter valueForKey:kCIOutputImageKey];
    //self.outputUIImage = [[UIImage alloc] initWithCIImage:self.outputCIImage];
    
    self.outputUIImage = [self createNonInterpolatedUIImageFromCIImage:self.outputCIImage withScale:1.0];
    
    //CGContextDrawImage(context, rect, cgImg);
    //CGContextDrawImage(context, rect, self.outputUIImage.CGImage);
    CGRect cgImgRect = CGRectMake(0, 0, CGImageGetWidth(self.inputUIImage.CGImage), CGImageGetHeight(self.inputUIImage.CGImage));
    CGContextDrawImage(context, cgImgRect, self.outputUIImage.CGImage);
    //CGContextDrawImage(context, cgImgRect, self.inputUIImage.CGImage);
    CGContextRelease(context);
}

@end
