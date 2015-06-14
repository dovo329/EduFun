//
//  ColorCubeView.m
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

#import "ColorCubeView.h"

@implementation ColorCubeView


- (void)drawRect:(CGRect)rect {
    // Allocate memory
    const unsigned int size = 64;
    const unsigned int cubeDataSize = size * size * size * sizeof (float) * 4;
    float *cubeData = (float *)malloc (cubeDataSize);
    float rgb[3], *c = cubeData;
    
    // Populate cube with a simple gradient going from 0 to 1
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // Blue value
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // Green value
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1); // Red value
                // Convert RGB to HSV
                // You can find publicly available rgbToHSV functions on the Internet
                // Use the hue value to determine which to make transparent
                // The minimum and maximum hue angle depends on
                // the color you want to remove
                // Calculate premultiplied alpha values for the cube
                c[0] = rgb[1];
                c[1] = rgb[0];
                c[2] = rgb[2];
                c[3] = 1.0;
                c += 4; // advance our pointer into memory for the next color value
            }
        }
    }
    // Create memory with the cube data
    NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                        length:cubeDataSize
                                  freeWhenDone:YES];
    CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
    [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
    // Set data for cube
    [colorCube setValue:data forKey:@"inputCubeData"];

    CIImage *inputCIImg = [[CIImage alloc] initWithCGImage:self.inputCGImg];
    [colorCube setValue:inputCIImg forKey:kCIInputImageKey];
    CIImage *result = [colorCube valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef img = [context createCGImage:result fromRect:[result extent]];
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, rect.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, img);
}


@end
