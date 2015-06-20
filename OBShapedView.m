/*
 Copyright (c) 2009 Ole Begemann
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

/*
 OBShapedButton.m
 
 Created by Ole Begemann
 October, 2009
 */

#import "OBShapedView.h"
#import "UIImage+ColorAtPixel.h"

@interface OBShapedView ()

@property (nonatomic, assign) CGPoint previousTouchPoint;
@property (nonatomic, assign) BOOL previousTouchHitTestResponse;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

- (void)resetHitTestCache;

@end


@implementation OBShapedView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)img
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [UIImageView new];
        self.imgView.frame = frame;
                
        self.imgView.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.imgView setTintColor:[UIColor redColor]];
        
        [self addSubview:self.imgView];
        [self resetHitTestCache];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)];
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

-(void)tapHandle
{
    //NSLog(@"tap handled in obshapedview");
    [self.delegate changeTintColorOfImageView:self.imgView];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:[UIImage imageNamed:@"redOnlySmall"]];
}

#pragma mark - Hit testing

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image
{
    // Correct point to take into account that the image does not have to be the same size
    // as the button. See https://github.com/ole/OBShapedButton/issues/1
    CGSize iSize = image.size;
    CGSize bSize = self.bounds.size;
    point.x *= (bSize.width != 0) ? (iSize.width / bSize.width) : 1;
    point.y *= (bSize.height != 0) ? (iSize.height / bSize.height) : 1;

    UIColor *pixelColor = [image colorAtPixel:point];
    CGFloat alpha = 0.0;
    
    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        // available from iOS 5.0
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    }
    else
    {
        // for iOS < 5.0
        // In iOS 6.1 this code is not working in release mode, it works only in debug
        // CGColorGetAlpha always return 0.
        CGColorRef cgPixelColor = [pixelColor CGColor];
        alpha = CGColorGetAlpha(cgPixelColor);
    }
    return alpha >= kAlphaVisibleThreshold;
}

// UIView uses this method in hitTest:withEvent: to determine which subview should receive a touch event.
// If pointInside:withEvent: returns YES, then the subview’s hierarchy is traversed; otherwise, its branch
// of the view hierarchy is ignored.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
    // Return NO if even super returns NO (i.e., if point lies outside our bounds)
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }

    // Don't check again if we just queried the same point
    // (because pointInside:withEvent: gets often called multiple times)
    if (CGPointEqualToPoint(point, self.previousTouchPoint)) {
        return self.previousTouchHitTestResponse;
    } else {
        self.previousTouchPoint = point;
    }

    BOOL response = NO;
    
    response = [self isAlphaVisibleAtPoint:point forImage:self.imgView.image];
    //NSLog(@"image response = %@", response ? @"yes" : @"no");
    //NSLog(@"did get touched");
    
    self.previousTouchHitTestResponse = response;
    return response;
}

- (void)resetHitTestCache
{
    self.previousTouchPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    self.previousTouchHitTestResponse = NO;
}

@end
