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
    emitterLayer.emitterSize = self.view.frame.size;
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.contents = (id)[UIImage imageNamed:@"StarCell"].CGImage;
    emitterCell.name = @"StarCell";
        
    emitterCell.birthRate = 150;
    emitterCell.lifetime = 1.0;
    emitterCell.lifetimeRange = 0.5;
    emitterCell.color = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0].CGColor;
    emitterCell.redRange = 1.0;
    emitterCell.redSpeed = 0.5;
    emitterCell.blueRange = 1.0;
    emitterCell.blueSpeed = 0.5;
    emitterCell.greenRange = 1.0;
    emitterCell.greenSpeed = 0.5;
    emitterCell.alphaSpeed = -0.2;
    
    emitterCell.velocity = 50;
    emitterCell.velocityRange = 20;
    emitterCell.yAcceleration = -100;
    emitterCell.emissionLongitude = -M_PI / 2;
    emitterCell.emissionRange = M_PI / 4;
    
    emitterCell.scale = 1.0;
    emitterCell.scaleSpeed = 1.0;
    emitterCell.scaleRange = 1.0;
    
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
