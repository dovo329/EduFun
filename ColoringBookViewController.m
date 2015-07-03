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
#import <MessageUI/MessageUI.h>

#define kMaxZoom 16.0
#define kSvgPageIndexKey @"svg.page.index.key"

@interface ColoringBookViewController () <UIScrollViewDelegate, PaletteViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) SVGKLayeredImageView *svgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *selColor;
@property (nonatomic, strong) NSIndexPath *selColorIndexPath;
@property (nonatomic, assign) CGSize origSize;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, assign) UIInterfaceOrientation previousOrientation;
@property (nonatomic, strong) UIBarButtonItem *cameraButton;
@property (nonatomic, strong) NSArray *svgPageNameArr;
@property (nonatomic, assign) int svgPageIndex;

@end

@implementation ColoringBookViewController

- (void)dealloc
{
    NSLog(@"ColoringBookViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // since titlescreen viewcontroller is landscape, and since apparently the view.frame never updates to be the new orientation (why?), need to swap width and height of frame
    //CGFloat width = self.view.frame.size.width;
    //CGFloat height = self.view.frame.size.height;
    //self.view.frame = CGRectMake(0,0,height, width);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.svgPageIndex = [defaults integerForKey:kSvgPageIndexKey];
    
    self.svgPageNameArr = @[@"mtnHouse.svg", @"Unicorn.svg"];
    
    [self setupBackgroundGradient];
    
    self.previousOrientation = UIInterfaceOrientationLandscapeRight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.navigationController.navigationBarHidden = false;
    self.selColor = [UIColor blueColor];
    
    //SVGKFastImageView *svgView = [[SVGKFastImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"Monkey.svg"]];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = false;
    //self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"mtnHouse.svg"]];
    //self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:@"Unicorn.svg"]];
    self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:self.svgPageNameArr[self.svgPageIndex]]];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = self.svgImageView.frame.size;
    self.scrollView.delegate = self;
    
    self.origSize = self.svgImageView.frame.size;
    CGFloat scaleX = self.view.frame.size.width / self.origSize.width;
    CGFloat scaleY = self.view.frame.size.height / self.origSize.height;
    CGFloat scale = scaleX < scaleY ? scaleX : scaleY;
    
    self.scrollView.minimumZoomScale = scale;
    self.scrollView.maximumZoomScale = scale*kMaxZoom;
    
    self.scrollView.zoomScale = scale;
    
    [self.scrollView addSubview:self.svgImageView];
    
    [self.view addSubview: self.scrollView];
    
    CGFloat offsetX = MAX((self.view.frame.size.width - self.scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((self.view.frame.size.height - self.scrollView.contentSize.height) * 0.5, 0.0);
    self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                           self.scrollView.contentSize.height * 0.5 + offsetY);
    //NSLog(@"bsw: %f; bsh: %f; offsetX:%f Y:%f, csw: %f csh: %f", self.scrollView.bounds.size.width, self.scrollView.bounds.size.height, offsetX, offsetY, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(exitMethod)];

    UIImage *previousArrowImg = [UIImage imageNamed:@"Previous"];
    previousArrowImg = [previousArrowImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *previousArrowButton = [[UIBarButtonItem alloc] initWithImage:previousArrowImg style:UIBarButtonItemStylePlain target:self action:@selector(previousArrowMethod)];
    
    UIImage *nextArrowImg = [UIImage imageNamed:@"Next"];
    nextArrowImg = [nextArrowImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *nextArrowButton = [[UIBarButtonItem alloc] initWithImage:nextArrowImg style:UIBarButtonItemStylePlain target:self action:@selector(nextArrowMethod)];
    
    UIImage *zoomImg = [UIImage imageNamed:@"Zoom"];
    zoomImg = [zoomImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *zoomButton = [[UIBarButtonItem alloc] initWithImage:zoomImg style:UIBarButtonItemStylePlain target:self action:@selector(zoomMethod)];
    
    UIImage *paintersPaletteImg = [UIImage imageNamed:@"PaintersPalette"];
    paintersPaletteImg = [paintersPaletteImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *paletteSelButton = [[UIBarButtonItem alloc] initWithImage:paintersPaletteImg style:UIBarButtonItemStylePlain target:self action:@selector(paletteSelMethod)];
    
    UIImage *cameraImg = [UIImage imageNamed:@"Camera"];
    cameraImg = [cameraImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.cameraButton = [[UIBarButtonItem alloc] initWithImage:cameraImg style:UIBarButtonItemStylePlain target:self action:@selector(cameraMethod)];
    
    /*UIImage *emailImg = [UIImage imageNamed:@"Mail"];
    emailImg = [emailImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithImage:emailImg style:UIBarButtonItemStylePlain target:self action:@selector(emailMethod)];*/

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolBar = [UIToolbar new];
    self.toolBar.items = @[exitButton, flexibleItem, previousArrowButton, flexibleItem, nextArrowButton, flexibleItem, zoomButton, flexibleItem, paletteSelButton, flexibleItem, self.cameraButton];
    self.toolBar.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:self.toolBar];
    
    [self autoLayoutConstraints];
}

- (void)autoLayoutConstraints
{
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.toolBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.scrollView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0
                                   constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.scrollView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0
                                   constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.scrollView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0
                                   constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.scrollView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.toolBar
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0
                                   constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.toolBar
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0
                                   constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.toolBar
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0
                                   constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.toolBar
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0
                                   constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.toolBar
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0
                                   constant:30.0]
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

- (void)viewWillDisappear:(BOOL)animated
{
    // save what svg coloring page we are on when leaving this view controller
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.svgPageIndex forKey:kSvgPageIndexKey];
    [defaults synchronize];
}

- (void)exitMethod
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app animateToViewController:8 srcVCEnum:2];
}

- (void)previousArrowMethod
{
    self.svgPageIndex--;
    if (self.svgPageIndex < 0) {
        self.svgPageIndex = [self.svgPageNameArr count]-1;
    }
    self.svgImageView.image = [SVGKImage imageNamed:self.svgPageNameArr[self.svgPageIndex]];
    self.scrollView.contentSize = self.svgImageView.frame.size;
    NSLog(@"Previous Arrow Method %@ [%d]", self.svgPageNameArr[self.svgPageIndex], self.svgPageIndex);
    
    /*self.svgImageView = [[SVGKLayeredImageView alloc] initWithSVGKImage: [SVGKImage imageNamed:self.svgPageNameArr[self.svgPageIndex]]];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = self.svgImageView.frame.size;
    self.scrollView.delegate = self;
    
    self.origSize = self.svgImageView.frame.size;
    CGFloat scaleX = self.view.frame.size.width / self.origSize.width;
    CGFloat scaleY = self.view.frame.size.height / self.origSize.height;
    CGFloat scale = scaleX < scaleY ? scaleX : scaleY;
    
    self.scrollView.minimumZoomScale = scale;
    self.scrollView.maximumZoomScale = scale*kMaxZoom;
    
    self.scrollView.zoomScale = scale;
    
    [self.scrollView addSubview:self.svgImageView];
    
    [self.view addSubview: self.scrollView];
    
    CGFloat offsetX = MAX((self.view.frame.size.width - self.scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((self.view.frame.size.height - self.scrollView.contentSize.height) * 0.5, 0.0);
    self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                           self.scrollView.contentSize.height * 0.5 + offsetY);*/
}

- (void)nextArrowMethod
{
    self.svgPageIndex++;
    if (self.svgPageIndex >= [self.svgPageNameArr count]) {
        self.svgPageIndex = 0;
    }
    self.svgImageView.image = [SVGKImage imageNamed:self.svgPageNameArr[self.svgPageIndex]];
    self.scrollView.contentSize = self.svgImageView.frame.size;
    NSLog(@"Next Arrow Method %@ [%d]", self.svgPageNameArr[self.svgPageIndex], self.svgPageIndex);
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error saving picture" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *option = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:option];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Picture saved to Photos Album" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *option = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:option];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    self.cameraButton.enabled = YES;
}

- (void)cameraMethod
{
    //self.view.window.userInteractionEnabled = NO;
    self.cameraButton.enabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum([self.svgImageView.image UIImage], self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
    });
}

/*- (void)emailMethod
{
    // Email Subject
    NSString *emailTitle = @"Coloring Book Page Email";
    // Email Content
    NSString *messageBody = @"Check out what I colored!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    NSString *mimeType = @"image/jpeg";
    
    //UIView *screenShotView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    //UIGraphicsBeginImageContext(self.view.bounds.size);
    //[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    
    //NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSData *imageData = UIImageJPEGRepresentation([self.svgImageView.image UIImage], 1.0);
    
    // Add attachment
    [mc addAttachmentData:imageData mimeType:mimeType fileName:@"screenShot.jpg"];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}*/

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)paletteSelMethod
{
    PaletteViewController *pvc = [PaletteViewController new];
    pvc.delegate = self;
    pvc.indexPath = self.selColorIndexPath;
    //pvc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //pvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    pvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)updatePaintColor:(UIColor *)color andSaveIndex:(NSIndexPath *)path
{
    self.selColor = color;
    self.selColorIndexPath = path;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskLandscape;
}

- (NSString *)orientationToString:(UIInterfaceOrientation)orient
{
    //if (orient == UIInterfaceOrientationPortrait) {
    //    return @"Portrait";
    //} else
    if (orient == UIInterfaceOrientationLandscapeLeft ||
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
        //scaleX = self.view.frame.size.height / self.origSize.width;
        //scaleY = self.view.frame.size.width / self.origSize.height;
        scaleX = self.view.frame.size.width / self.origSize.width;
        scaleY = self.view.frame.size.height / self.origSize.height;
        scale = scaleX < scaleY ? scaleX : scaleY;
        
        self.scrollView.minimumZoomScale = scale;
        self.scrollView.maximumZoomScale = scale*kMaxZoom;
        
        self.scrollView.zoomScale = scale;
        //NSLog(@"wid=%f height=%f min=%f max=%f cur=%f", self.view.frame.size.width, self.view.frame.size.height, self.scrollView.minimumZoomScale, self.scrollView.maximumZoomScale, self.scrollView.zoomScale);
        //CGFloat offsetX = MAX((self.scrollView.bounds.size.width - self.scrollView.contentSize.height) * 0.5, 0.0);
        //CGFloat offsetY = MAX((self.scrollView.bounds.size.height - self.scrollView.contentSize.width) * 0.5, 0.0);
        
        CGFloat offsetX = MAX((self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5, 0.0);
        CGFloat offsetY = MAX((self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5, 0.0);
        
        self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                               self.scrollView.contentSize.height * 0.5 + offsetY);
        //self.svgImageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetY,
        //                                       self.scrollView.contentSize.height * 0.5 + offsetX);
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

- (void)zoomMethod
{
    CGFloat newScale = self.scrollView.zoomScale * 3.0;
    
    if (newScale > self.scrollView.maximumZoomScale)
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else
    {
        [self.scrollView setZoomScale:newScale animated:YES];
    }
}

@end
