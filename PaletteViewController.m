//
//  PaletteViewController.m
//  Demo-iOS
//
//  Created by Douglas Voss on 6/19/15.
//  Copyright (c) 2015 na. All rights reserved.
//

#import "PaletteViewController.h"

#define kMinMargin 15.0
#define kReuseId @"palette.view.controller.collection.view.cell.reuse.id"
#define kNumColumns 4

@interface PaletteViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *colorArr;

@end

@implementation PaletteViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (self.indexPath != nil)
    {
        [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor greenColor];
    //[UIColor colorWithRed:100.0 green:131.0 blue:144.0 alpha:1.0];
    
    self.colorArr =
    @[
      [UIColor colorWithRed:64/255.0	green:0/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:0/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:192/255.0	green:0/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:255/255.0	green:0/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:64/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:128/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:192/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:255/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:0/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:0/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:0/255.0	blue:192/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:0/255.0	blue:255/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:64/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:128/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:192/255.0	green:192/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:255/255.0	green:255/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:0/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:0/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:192/255.0	green:0/255.0	blue:192/255.0 alpha:1.0],
      [UIColor colorWithRed:255/255.0	green:0/255.0	blue:255/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:64/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:128/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:192/255.0	blue:192/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:255/255.0	blue:255/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:32/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:64/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:192/255.0	green:96/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:255/255.0	green:128/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:0/255.0	blue:32/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:0/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:192/255.0	green:0/255.0	blue:96/255.0 alpha:1.0],
      [UIColor colorWithRed:255/255.0	green:0/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:32/255.0	green:64/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:128/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:96/255.0	green:192/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:255/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:64/255.0	blue:32/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:128/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:192/255.0	blue:96/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:255/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:32/255.0	green:0/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:0/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:96/255.0	green:0/255.0	blue:192/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:0/255.0	blue:255/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:32/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:64/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:96/255.0	blue:192/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:128/255.0	blue:255/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:32/255.0	blue:32/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:64/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:192/255.0	green:96/255.0	blue:96/255.0 alpha:1.0],
      [UIColor colorWithRed:255/255.0	green:128/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:32/255.0	green:64/255.0	blue:32/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:128/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:96/255.0	green:192/255.0	blue:96/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:255/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:32/255.0	green:32/255.0	blue:64/255.0 alpha:1.0],
      [UIColor colorWithRed:64/255.0	green:64/255.0	blue:128/255.0 alpha:1.0],
      [UIColor colorWithRed:96/255.0	green:96/255.0	blue:192/255.0 alpha:1.0],
      [UIColor colorWithRed:128/255.0	green:128/255.0	blue:255/255.0 alpha:1.0],
      [UIColor colorWithRed:0/255.0	green:0/255.0	blue:0/255.0 alpha:1.0],
      [UIColor colorWithRed:37/255.0	green:37/255.0	blue:37/255.0 alpha:1.0],
      [UIColor colorWithRed:73/255.0	green:73/255.0	blue:73/255.0 alpha:1.0],
      [UIColor colorWithRed:110/255.0	green:110/255.0	blue:110/255.0 alpha:1.0],
      [UIColor colorWithRed:146/255.0	green:146/255.0	blue:146/255.0 alpha:1.0],
      [UIColor colorWithRed:183/255.0	green:183/255.0	blue:183/255.0 alpha:1.0],
      [UIColor colorWithRed:219/255.0	green:219/255.0	blue:219/255.0 alpha:1.0],
      [UIColor colorWithRed:255/255.0	green:255/255.0	blue:255/255.0 alpha:1.0]
      ];
    
    /*    self.colorArr =
     @[
     [UIColor blackColor],
     [UIColor darkGrayColor],
     [UIColor lightGrayColor],
     [UIColor whiteColor],
     [UIColor grayColor],
     [UIColor redColor],
     [UIColor greenColor],
     [UIColor blueColor],
     [UIColor cyanColor],
     [UIColor yellowColor],
     [UIColor magentaColor],
     [UIColor orangeColor],
     [UIColor purpleColor],
     [UIColor brownColor]
     ];*/
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(kMinMargin, kMinMargin, kMinMargin, kMinMargin);
    
    CGFloat width = (self.view.frame.size.width-(kMinMargin*(kNumColumns+1)))/kNumColumns;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = kMinMargin;
    layout.minimumLineSpacing = kMinMargin;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kReuseId];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.3 green:0.4 blue:0.5 alpha:1.0];
    //self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = true;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.collectionView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                  constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.collectionView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0
                                  constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.collectionView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0]
     ];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.collectionView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0]
     ];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ceil(((float)[self.colorArr count])/((float)kNumColumns));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kNumColumns;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int colorArrInd = ((indexPath.section*kNumColumns) + indexPath.row) % [self.colorArr count];
    [self.delegate updatePaintColor:self.colorArr[colorArrInd] andSaveIndex:indexPath];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    int colorArrInd = ((indexPath.section*kNumColumns) + indexPath.row) % [self.colorArr count];
    cell.backgroundColor = self.colorArr[colorArrInd];
    cell.layer.cornerRadius = 10.0;
    cell.layer.masksToBounds = true;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"PaletteViewController dealloc");
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
}

@end
