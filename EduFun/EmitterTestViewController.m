//
//  EmitterTestViewController.m
//  EduFun
//
//  Created by Douglas Voss on 6/24/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

#import "EmitterTestViewController.h"

@interface EmitterTestViewController ()

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@end

@implementation EmitterTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emitterLayer = [CAEmitterLayer layer];

    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    UIImage *cellUIImage = [UIImage imageNamed:@"ConfettiCell"];
    emitterCell.contents = (id)cellUIImage.CGImage;
    
    self.emitterLayer.emitterPosition = CGPointMake(self.view.frame.origin.x + (self.view.frame.size.width/2), self.view.frame.origin.y - cellUIImage.size.height);
    //self.emitterLayer.emitterPosition = CGPointMake(self.view.frame.origin.x + (self.view.frame.size.width/2), self.view.frame.origin.y);
    self.emitterLayer.emitterSize = CGSizeMake(self.view.frame.size.width, 0.0);
    self.emitterLayer.emitterShape = kCAEmitterLayerLine;
        

    emitterCell.name = @"ConfettiCell";
        
    emitterCell.birthRate = 50;
    emitterCell.lifetime = 5;
    emitterCell.lifetimeRange = 0;
    emitterCell.color = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0].CGColor;
    emitterCell.redRange = 0.8;
    emitterCell.redSpeed = 0.0;
    emitterCell.blueRange = 0.8;
    emitterCell.blueSpeed = 0.0;
    emitterCell.greenRange = 0.8;
    emitterCell.greenSpeed = 0.0;
    emitterCell.alphaSpeed = 0.0;

    emitterCell.spin = 0.0;
    emitterCell.spinRange = 1.5;
    
    emitterCell.velocity = 125;
    emitterCell.velocityRange = 0;
    emitterCell.yAcceleration = 100;
    emitterCell.emissionLongitude = M_PI;
    emitterCell.emissionRange = M_PI/4;
    
    emitterCell.scale = 0.4;
    emitterCell.scaleSpeed = 0.0;
    emitterCell.scaleRange = 0.1;
    
    self.emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
    
    self.emitterLayer.beginTime = CACurrentMediaTime();
    [self.view.layer addSublayer:self.emitterLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches Began!");
    /*NSString *animationPath = [NSString stringWithFormat:@"%@.birthRate", self.emitterLayer.name];
    CABasicAnimation *birthRateAnimation = [CABasicAnimation animationWithKeyPath:animationPath];
    birthRateAnimation.fromValue = [NSNumber numberWithFloat:30.0];
    birthRateAnimation.toValue = [NSNumber numberWithFloat:0.0];
    birthRateAnimation.removedOnCompletion = NO;
    birthRateAnimation.duration = 1.0;
    [self.emitterLayer addAnimation:birthRateAnimation forKey:@"birthRate"];*/
    self.emitterLayer.lifetime = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
