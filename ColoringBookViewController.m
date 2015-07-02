//
//  DougViewController.m
//  Demo-iOS
//
//  Created by Douglas Voss on 6/18/15.
//  Copyright (c) 2015 na. All rights reserved.
//

#import "ColoringBookViewController.h"
#import <SVGKit/SVGKit.h>
#import "PaletteViewController.h"
#import "EduFun-Swift.h"

@interface ColoringBookViewController () <UIScrollViewDelegate, PaletteViewControllerDelegate>

@property (nonatomic, strong) SVGKLayeredImageView *svgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *selColor;
@property (nonatomic, assign) CGSize origSize;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, assign) UIInterfaceOrientation previousOrientation;

@end

@implementation ColoringBookViewController

- (void)dealloc
{
    //SVGKLayer *layer = (SVGKLayer *)self.svgImageView.layer;
    //[layer removeObserver:self forKeyPath:@"showBorder"];
}

/*- (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 }*/

/*- (void)viewDidAppear:(BOOL)animated
 {
 [super viewDidAppear:animated];
 NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
 [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
 NSLog(@"viewDidAppear");
 
 CGSize size = self.svgImageView.frame.size;
 CGFloat scaleX = self.view.frame.size.width / size.width;
 CGFloat scaleY = self.view.frame.size.height / size.height;
 CGFloat scale = scaleX < scaleY ? scaleX : scaleY;
 
 self.scrollView.minimumZoomScale = scale;
 self.scrollView.maximumZoomScale = scale*20.0;
 
 self.scrollView.zoomScale = scale;
 }*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgroundGradient];
    
    //self.previousOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.previousOrientation = UIInterfaceOrientationPortrait;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //NSLog(@"viewDidLoad");
    
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = false;
    self.selColor = [UIColor blueColor];
    
    //SVGKFastImageView *svgView = [[SVGKFastImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"Monkey.svg"]];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = false;
    self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"mtnHouse.svg"]];
    //self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"mtnHouseInk.svg"]];
    
    //self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"MonkeySketch.svg"]];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = self.svgImageView.frame.size;
    self.scrollView.delegate = self;
    
    self.origSize = self.svgImageView.frame.size;
    CGFloat scaleX = self.view.frame.size.width / self.origSize.width;
    CGFloat scaleY = self.view.frame.size.height / self.origSize.height;
    CGFloat scale = scaleX < scaleY ? scaleX : scaleY;
    
    self.scrollView.minimumZoomScale = scale;
    self.scrollView.maximumZoomScale = scale*20.0;
    
    self.scrollView.zoomScale = scale;
    //self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5,
    //                                       self.scrollView.contentSize.height * 0.5);
    
    [self.scrollView addSubview:self.svgImageView];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview: self.scrollView];
    
    /*NSDictionary *viewsDictionary = @{@"sv": self.scrollView};
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[sv]|"
      options: NSLayoutFormatAlignAllBaseline
      metrics: nil
      views: viewsDictionary
      ]
     ];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[sv]|"
      options: NSLayoutFormatAlignAllBaseline
      metrics: nil
      views: viewsDictionary
      ]
     ];*/
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.scrollView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                  constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.scrollView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0
                                  constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.scrollView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.scrollView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0]
     ];
    
    CGFloat offsetX = MAX((self.view.frame.size.width - self.scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((self.view.frame.size.height - self.scrollView.contentSize.height) * 0.5, 0.0);
    self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                           self.scrollView.contentSize.height * 0.5 + offsetY);
    NSLog(@"bsw: %f; bsh: %f; offsetX:%f Y:%f, csw: %f csh: %f", self.scrollView.bounds.size.width, self.scrollView.bounds.size.height, offsetX, offsetY, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(exitMethod)];
    UIImage *paintersPaletteImg = [UIImage imageNamed:@"PaintersPalette"];
    paintersPaletteImg = [paintersPaletteImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *paletteSelButton = [[UIBarButtonItem alloc] initWithImage:paintersPaletteImg style:UIBarButtonItemStylePlain target:self action:@selector(paletteSelMethod)];
    self.toolBar = [UIToolbar new];
    self.toolBar.items = @[exitButton, paletteSelButton];
    self.toolBar.backgroundColor = [UIColor orangeColor];
    
    [self.toolBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.toolBar];

    NSDictionary *viewsDictionary2 = @{@"tb": self.toolBar};
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-(>=0)-[tb(==30)]|"
      options: NSLayoutFormatAlignAllBaseline
      metrics: nil
      views: viewsDictionary2
      ]
     ];
    
    [self.view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[tb]|"
      options: NSLayoutFormatAlignAllBaseline
      metrics: nil
      views: viewsDictionary2
      ]
     ];
}

- (CGColorRef)cgColorForRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return (CGColorRef)[[UIColor colorWithRed:red green:green blue:blue alpha:1.0] CGColor];
}

- (void)setupBackgroundGradient
{
    
    UIColor *colorOne   = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *colorTwo   = [UIColor colorWithRed:255.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    UIColor *colorThree = [UIColor colorWithRed:255.0/255.0 green:216.0/255.0 blue:173.0/255.0 alpha:1.0];
    UIColor *colorFour  = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:152.0/255.0 alpha:1.0];
    UIColor *colorFive  = [UIColor colorWithRed:152.0/255.0 green:255.0/255.0 blue:152.0/255.0 alpha:1.0];
    UIColor *colorSix   = [UIColor colorWithRed:162.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)[colorOne CGColor], (id)[colorTwo CGColor], (id)[colorThree CGColor], (id)[colorFour CGColor], (id)[colorFive CGColor], (id)[colorSix CGColor], nil];

    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = colors;
    self.gradientLayer.frame = self.view.bounds;
    self.gradientLayer.shouldRasterize = true;
    [self.view.layer addSublayer:self.gradientLayer];
}

- (void)viewDidLayoutSubviews
{
    self.gradientLayer.frame = self.view.bounds;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.svgImageView;
}

- (void)tapMethod:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.scrollView];
    //NSLog(@"tap happen @x:%f y:%f", point.x, point.y);
    CALayer* layerForHitTesting;
    layerForHitTesting = self.svgImageView.layer;
    CALayer* hitLayer = [layerForHitTesting hitTest:point];
    
    if( [hitLayer isKindOfClass:[CAShapeLayer class]]){
        CAShapeLayer* shapeLayer = (CAShapeLayer*)hitLayer;
        shapeLayer.fillColor = self.selColor.CGColor;
    }
}

- (void)exitMethod
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app animateToViewController:8];
}

- (void)paletteSelMethod
{
    PaletteViewController *pvc = [PaletteViewController new];
    pvc.delegate = self;
    
    //pvc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //pvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    pvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)updatePaintColor:(UIColor *)color
{
    self.selColor = color;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
}

- (NSString *)orientationToString:(UIInterfaceOrientation)orient
{
    if (orient == UIInterfaceOrientationPortrait) {
        return @"Portrait";
    } else if (orient == UIInterfaceOrientationLandscapeLeft ||
               orient == UIInterfaceOrientationLandscapeRight)
    {
        return @"Landscape";
    } else {
        return @"Other";
    }
}

- (void) orientationChanged:(NSNotification *)notification
{
    UIInterfaceOrientation newOrient = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    
    NSString *prevOrientStr = [self orientationToString:self.previousOrientation];
    NSString *newOrientStr  = [self orientationToString:newOrient];
    //NSLog(@"orientationChanged from %@ to %@",prevOrientStr ,newOrientStr);
    if ((![newOrientStr isEqualToString:prevOrientStr]) &&
        (![newOrientStr isEqualToString:@"Other"]) &&
        self.svgImageView != nil)
    {
        // only update previous orientation if it is new and not "Other"
        self.previousOrientation = newOrient;
        
        CGFloat scaleX, scaleY, scale;
        // orientation changed but apparently frame.size hasn't swapped width and height yet so swap it ourselves
        scaleX = self.view.frame.size.height / self.origSize.width;
        scaleY = self.view.frame.size.width / self.origSize.height;
        scale = scaleX < scaleY ? scaleX : scaleY;
        
        self.scrollView.minimumZoomScale = scale;
        self.scrollView.maximumZoomScale = scale*20.0;
        
        self.scrollView.zoomScale = scale;
        //NSLog(@"wid=%f height=%f min=%f max=%f cur=%f", self.view.frame.size.width, self.view.frame.size.height, self.scrollView.minimumZoomScale, self.scrollView.maximumZoomScale, self.scrollView.zoomScale);
        CGFloat offsetX = MAX((self.scrollView.bounds.size.width - self.scrollView.contentSize.height) * 0.5, 0.0);
        CGFloat offsetY = MAX((self.scrollView.bounds.size.height - self.scrollView.contentSize.width) * 0.5, 0.0);
    
        self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetY,
                                               self.scrollView.contentSize.height * 0.5 + offsetX);
        //self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5,
        //                                       self.scrollView.contentSize.height * 0.5);
        //NSLog(@"offsetX:%f Y:%f, csw: %f csh: %f", offsetX, offsetY, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    }
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = MAX((self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5, 0.0);
    
    self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                           self.scrollView.contentSize.height * 0.5 + offsetY);
    //NSLog(@"offsetX:%f Y:%f, csw: %f csh: %f", offsetX, offsetY, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

@end
