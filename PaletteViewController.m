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
#define kNumColumns 8

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

#define UICOLOR(R, G, B) [UIColor colorWithRed:R/255.0	green:G/255.0	blue:B/255.0 alpha:1.0]

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor greenColor];
    //[UIColor colorWithRed:100.0 green:131.0 blue:144.0 alpha:1.0];
    
    // taken from https://en.wikipedia.org/wiki/List_of_Crayola_crayon_colors
    self.colorArr =
    @[
      UICOLOR(238,	32,	77),
      UICOLOR(195,	33,	72),
      UICOLOR(253,	14,	53),
      UICOLOR(198,      45,     66),
	UICOLOR(204,	71,	75),
	UICOLOR(204,	51,	54),
	UICOLOR(225,	44,	44),
	UICOLOR(217,	33,	33),
	UICOLOR(185,	78,	72),
	UICOLOR(255,	63,	52),
	UICOLOR(254,	76,	64),
	UICOLOR(254,	111,	94),
	UICOLOR(179,	59,	36),
	UICOLOR(204,	85,	61),
	UICOLOR(230,	115,	92),
	UICOLOR(255,	153,	128),
	UICOLOR(229,	144,	115),
	UICOLOR(255,	112,	52),
	UICOLOR(255,	104,	31),
	UICOLOR(255,	136,	100),
	UICOLOR(255,	185,	123),
	UICOLOR(236,	177,	118),
	UICOLOR(231,	114,	0),
	UICOLOR(255,	174,	66),
	UICOLOR(242,	186,	73),
	UICOLOR(251,	231,	178),
	UICOLOR(242,	198,	73),
	UICOLOR(248,	213,	104),
	UICOLOR(252,	214,	103),
	UICOLOR(254,	216,	93),
	UICOLOR(252,	232,	131),
	UICOLOR(241,	231,	136),
	UICOLOR(255,	235,	0),
	UICOLOR(181,	179,	92),
	UICOLOR(236,	235,	189),
	UICOLOR(250,	250,	55),
	UICOLOR(255,	255,	153),
	UICOLOR(255,	255,	159),
	UICOLOR(217,	230,	80),
	UICOLOR(172,	191,	96),
	UICOLOR(175,	227,	19),
	UICOLOR(190,	230,	75),
	UICOLOR(197,	225,	122),
	UICOLOR(94,	140,	49),
	UICOLOR(123,	160,	91),
	UICOLOR(157,	224,	147),
	UICOLOR(99,	183,	108),
	UICOLOR(77,	140,	87),
	UICOLOR(58,	166,	85),
	UICOLOR(108,	166,	124),
	UICOLOR(95,	167,	119),
	UICOLOR(147,	223,	184),
	UICOLOR(51,	204,	153),
	UICOLOR(26,	179,	133),
	UICOLOR(41,	171,	135),
	UICOLOR(0,	204,	153),
	UICOLOR(0,	117,	94),
	UICOLOR(141,	217,	204),
	UICOLOR(1,	120,	111),
	UICOLOR(48,	191,	191),
	UICOLOR(0,	204,	204),
	UICOLOR(0,	128,	128),
	UICOLOR(143,	216,	216),
	UICOLOR(149,	224,	232),
	UICOLOR(108,	218,	231),
	UICOLOR(45,	56,	58),
	UICOLOR(118,	215,	234),
	UICOLOR(126,	212,	230),
	UICOLOR(0,	149,	183),
	UICOLOR(0,	157,	196),
	UICOLOR(2,	164,	211),
	UICOLOR(71,	171,	204),
	UICOLOR(46,	180,	230),
	UICOLOR(51,	154,	204),
	UICOLOR(147,	204,	234),
	UICOLOR(40,	135,	200),
	UICOLOR(0,	70,	140),
	UICOLOR(0,	102,	204),
	UICOLOR(21,	96,	189),
	UICOLOR(0,	102,	255),
	UICOLOR(169,	178,	195),
	UICOLOR(195,	205,	230),
	UICOLOR(69,	112,	230),
	UICOLOR(122,	137,	184),
	UICOLOR(79,	105,	198),
	UICOLOR(141,	144,	161),
	UICOLOR(140,	144,	200),
	UICOLOR(112,	112,	204),
	UICOLOR(153,	153,	204),
	UICOLOR(172,	172,	230),
	UICOLOR(118,	110,	200),
	UICOLOR(100,	86,	183),
	UICOLOR(63,	38,	191),
	UICOLOR(139,	114,	190),
	UICOLOR(101,	45,	193),
	UICOLOR(107,	63,	160),
	UICOLOR(131,	89,	163),
	UICOLOR(143,	71,	179),
	UICOLOR(201,	160,	220),
	UICOLOR(191,	143,	204),
	UICOLOR(128,	55,	144),
	UICOLOR(115,	51,	128),
	UICOLOR(214,	174,	221),
	UICOLOR(193,	84,	193),
	UICOLOR(252,	116,	253),
	UICOLOR(115,	46,	108),
	UICOLOR(230,	103,	206),
	UICOLOR(226,	156,	210),
	UICOLOR(142,	49,	121),
	UICOLOR(217,	108,	190),
	UICOLOR(235,	176,	215),
	UICOLOR(200,	80,	155),
	UICOLOR(187,	51,	133),
	UICOLOR(217,	130,	181),
	UICOLOR(187,	51,	133),
	UICOLOR(166,	58,	121),
	UICOLOR(165,	11,	94),
	UICOLOR(97,	64,	81),
	UICOLOR(246,	83,	166),
	UICOLOR(218,	50,	135),
	UICOLOR(255,	51,	153),
	UICOLOR(251,	174,	210),
	UICOLOR(255,	183,	213),
	UICOLOR(255,	166,	201),
	UICOLOR(247,	70,	138),
	UICOLOR(227,	11,	92),
	UICOLOR(253,	215,	228),
	UICOLOR(230,	46,	107),
	UICOLOR(219,	80,	121),
	UICOLOR(252,	128,	165),
	UICOLOR(240,	145,	169),
	UICOLOR(255,	145,	164),
	UICOLOR(165,	83,	83),
	UICOLOR(202,	52,	53),
	UICOLOR(254,	186,	173),
	UICOLOR(247,	163,	142),
	UICOLOR(233,	116,	81),
	UICOLOR(175,	89,	62),
	UICOLOR(158,	91,	64),
	UICOLOR(135,	66,	31),
	UICOLOR(146,	111,	91),
	UICOLOR(222,	166,	129),
	UICOLOR(210,	125,	70),
	UICOLOR(102,	66,	40),
	UICOLOR(217,	154,	108),
	UICOLOR(237,	201,	175),
	UICOLOR(255,	203,	164),
	UICOLOR(128,	85,	51),
	UICOLOR(253,	213,	177),
	UICOLOR(238,	217,	196),
	UICOLOR(102,	82,	51),
	UICOLOR(131,	112,	80),
	UICOLOR(230,	188,	92),
	UICOLOR(217,	214,	207),
	UICOLOR(146,	146,	110),
	UICOLOR(230,	190,	138),
	UICOLOR(201,	192,	187),
	UICOLOR(218,	138,	103),
	UICOLOR(200,	138,	101),
	UICOLOR(0,	0,	0),
	UICOLOR(115,	106,	98),
	UICOLOR(139,	134,	128),
	UICOLOR(200,	200,	205),
	UICOLOR(255,	255,	255),
      	UICOLOR(255,	53,	94),
      	UICOLOR(253,	91,	120),
      	UICOLOR(255,	96,	55),
      	UICOLOR(255,	153,	102),
      	UICOLOR(255,	153,	51),
      	UICOLOR(255,	204,	51),
      	UICOLOR(255,	255,	102),
      	UICOLOR(100,	255,	255),
      	UICOLOR(204,	255,	0),
      	UICOLOR(100,	102,	255),
      	UICOLOR(170,	240,	209),
      	UICOLOR(80,	191,	230),
      	UICOLOR(255,	110,	255),
      	UICOLOR(93,	238,	52),
      	UICOLOR(255,	0,	204),
      	UICOLOR(255,	0,	204),
      	UICOLOR(253, 217, 181),
      	UICOLOR(0, 0, 0),
      	UICOLOR(234, 126, 93),
      	UICOLOR(205, 74, 76),
      	UICOLOR(255, 207, 171),
      	UICOLOR(165, 105, 79),
      	UICOLOR(250, 167, 108),
	UICOLOR(255, 255, 255),
      	UICOLOR(196, 98, 16),
      	UICOLOR(46, 88, 148),
      	UICOLOR(156, 37, 66),
      	UICOLOR(191, 79, 81),
      	UICOLOR(165, 113, 100),
      	UICOLOR(88, 66, 124),
      	UICOLOR(74, 100, 108),
      	UICOLOR(133, 117, 78),
      	UICOLOR(49, 145, 119),
      	UICOLOR(10, 126, 140),
      	UICOLOR(156, 124, 56),
      	UICOLOR(141, 78, 133),
      	UICOLOR(143, 212, 0),
      	UICOLOR(217, 134, 149),
      	UICOLOR(117, 117, 117),
        UICOLOR(0, 129, 171),
     UICOLOR(255, 0, 0),
     UICOLOR(0,255,0),
     UICOLOR(0,0,255),
     UICOLOR(255,255,0),
     UICOLOR(255,0,255),
     UICOLOR(0,255,255),
     UICOLOR(255,128,0),
     UICOLOR(255,0,128),
     UICOLOR(128,255,0),
     UICOLOR(0,255,128),
     UICOLOR(128,0,255),
     UICOLOR(0,128,255),
     UICOLOR(255,128,128),
     UICOLOR(128,255,128),
     UICOLOR(128,128,255),
     UICOLOR(255,255,255),
     UICOLOR(255,128,64),
     UICOLOR(128,255,64),
     UICOLOR(64,128,255),
     UICOLOR(64,255,128)
      ];
    
    /*   
     UICOLOR(64, 0, 0),
     UICOLOR(128, 0, 0),
     UICOLOR(192, 0, 0),
     UICOLOR(255, 0, 0),
     UICOLOR(0, 64, 0),
     UICOLOR(0, 128, 0),
     UICOLOR(0,192,0),
     UICOLOR(0,255,0),
     UICOLOR(0,0,64),
     UICOLOR(0,0,128),
     UICOLOR(0,0,192),
     UICOLOR(0,0,255),
     UICOLOR(64,64,0),
     UICOLOR(128,128,0),
     UICOLOR(192,192,0),
     UICOLOR(255,255,0),
     UICOLOR(64,0,64),
     UICOLOR(128,0,128),
     UICOLOR(192,0,192),
     UICOLOR(255,0,255),
     UICOLOR(0,64,64),
     UICOLOR(0,128,128),
     UICOLOR(0,192,192),
     UICOLOR(0,255,255),
     UICOLOR(64,32,0),
     UICOLOR(128,64,0),
     UICOLOR(192,96,0),
     UICOLOR(255,128,0),
     UICOLOR(64,0,32),
     UICOLOR(128,0,64),
     UICOLOR(192,0,96),
     UICOLOR(255,0,128),
     UICOLOR(32,64,0),
     UICOLOR(64,128,0),
     UICOLOR(96,192,0),
     UICOLOR(128,255,0),
     UICOLOR(0,64,32),
     UICOLOR(0,128,64),
     UICOLOR(0,192,96),
     UICOLOR(0,255,128),
     UICOLOR(32,0,64),
     UICOLOR(64,0,128),
     UICOLOR(96,0,192),
     UICOLOR(128,0,255),
     UICOLOR(0,32,64),
     UICOLOR(0,64,128),
     UICOLOR(0,96,192),
     UICOLOR(0,128,255),
     UICOLOR(64,32,32),
     UICOLOR(128,64,64),
     UICOLOR(192,96,96),
     UICOLOR(255,128,128),
     UICOLOR(32,64,32),
     UICOLOR(64,128,64),
     UICOLOR(96,192,96),
     UICOLOR(128,255,128),
     UICOLOR(32,32,64),
     UICOLOR(64,64,128),
     UICOLOR(96,96,192),
     UICOLOR(128,128,255),
     UICOLOR(0,0,0),
     UICOLOR(37,37,37),
     UICOLOR(73,73,73),
     UICOLOR(110,110,110),
     UICOLOR(146,146,146),
     UICOLOR(183,183,183),
     UICOLOR(219,219,219),
     UICOLOR(255,255,255)
     ];*/
    /*
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
     
     ];*/
    
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
    //self.collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1.0];
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
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 3.0;
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
    //return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskLandscape;
}

@end
