//
//  EmitterTestViewController.m
//  EduFun
//
//  Created by Douglas Voss on 6/24/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

#import "EmitterTestViewController.h"

@interface EmitterTestViewController ()

@end

@implementation EmitterTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    
    emitterLayer.emitterPosition = CGPointMake(self.view.frame.origin.x + (self.view.frame.size.width/2), self.view.frame.origin.y + (self.view.frame.size.height/2));
    emitterLayer.emitterSize = CGSizeMake(self.view.frame.size.width/4.0, self.view.frame.size.height/4.0);
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.contents = (id)[UIImage imageNamed:@"StarCell"].CGImage;
    emitterCell.name = @"StarCell";
        
    emitterCell.birthRate = 40;
    emitterCell.lifetime = 1.5;
    emitterCell.lifetimeRange = 0.5;
    emitterCell.color = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0].CGColor;
    emitterCell.redRange = 0.0;
    emitterCell.redSpeed = 0.0;
    emitterCell.blueRange = 0.0;
    emitterCell.blueSpeed = 1.0;
    emitterCell.greenRange = 0.0;
    emitterCell.greenSpeed = -1.0;
    emitterCell.alphaSpeed = 0.0;

    emitterCell.spin = 0.0;
    emitterCell.spinRange = 10.0;
    
    emitterCell.velocity = 200;
    emitterCell.velocityRange = 50;
    emitterCell.yAcceleration = 400;
    emitterCell.emissionLongitude = -M_PI / 2;
    emitterCell.emissionRange = M_PI/6;
    
    emitterCell.scale = 0.25;
    emitterCell.scaleSpeed = -0.125;
    emitterCell.scaleRange = 0.0;
    
    emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
        
    [self.view.layer addSublayer:emitterLayer];
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
