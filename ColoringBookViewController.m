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

- (void) orientationChanged:(NSNotification *)notification
{
    NSLog(@"orientationChanged");
    if (self.svgImageView) {

        CGFloat scaleX, scaleY, scale;
        scaleX = self.view.frame.size.width / self.origSize.width;
        scaleY = self.view.frame.size.height / self.origSize.height;
        scale = scaleX < scaleY ? scaleX : scaleY;
        
        self.scrollView.minimumZoomScale = scale;
        self.scrollView.maximumZoomScale = scale*20.0;
        
        self.scrollView.zoomScale = scale;
        NSLog(@"min=%f max=%f cur=%f", self.scrollView.minimumZoomScale, self.scrollView.maximumZoomScale, self.scrollView.zoomScale);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackgroundGradient];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    NSLog(@"viewDidLoad");
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    // Do any additional setup after loading the view.
    
    //NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
     [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
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
    [self.scrollView addSubview:self.svgImageView];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview: self.scrollView];
    
    NSDictionary *viewsDictionary = @{@"sv": self.scrollView};
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
     ];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [self.view addGestureRecognizer:tapGesture];
    
    //UIBarButtonItem *paletteSelButton = [[UIBarButtonItem alloc] initWithTitle:@"Colors" style:UIBarButtonItemStylePlain target:self action:@selector(paletteSelMethod)];
    UIImage *paintersPaletteImg = [UIImage imageNamed:@"PaintersPalette"];
    paintersPaletteImg = [paintersPaletteImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *paletteSelButton = [[UIBarButtonItem alloc] initWithImage:paintersPaletteImg style:UIBarButtonItemStylePlain target:self action:@selector(paletteSelMethod)];
    self.toolBar = [UIToolbar new];
    self.toolBar.items = @[paletteSelButton];
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

- (void)paletteSelMethod
{
    PaletteViewController *pvc = [PaletteViewController new];
    pvc.delegate = self;
    //[self.navigationController pushViewController:pvc animated:NO];
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
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
