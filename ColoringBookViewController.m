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


@interface ColoringBookViewController () <UIScrollViewDelegate, PaletteViewControllerDelegate>

@property (nonatomic, strong) SVGKLayeredImageView *svgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *selColor;

@end

@implementation ColoringBookViewController

- (void)dealloc
{
    //SVGKLayer *layer = (SVGKLayer *)self.svgImageView.layer;
    //[layer removeObserver:self forKeyPath:@"showBorder"];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = false;
    self.selColor = [UIColor blueColor];

    //SVGKFastImageView *svgView = [[SVGKFastImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"Monkey.svg"]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"mtnHouse.svg"]];
    //self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"mtnHouseInk.svg"]];
    
    //self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"MonkeySketch.svg"]];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = self.svgImageView.frame.size;
    self.scrollView.delegate = self;
    
    CGSize size = self.svgImageView.frame.size;
    CGFloat scaleX = self.view.frame.size.width / size.width;
    CGFloat scaleY = self.view.frame.size.height / size.height;
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
    self.navigationItem.rightBarButtonItem = paletteSelButton;
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
    [self.navigationController pushViewController:pvc animated:NO];
}

- (void)updatePaintColor:(UIColor *)color
{
    self.selColor = color;
}

- (BOOL)shouldAutorotate {
    return true;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

@end
