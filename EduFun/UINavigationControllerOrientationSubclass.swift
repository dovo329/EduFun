//
//  UINavigationControllerOrientationSubclass.swift
//  EduFun
//
//  Created by Douglas Voss on 6/30/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import Cocoa

class UINavigationControllerOrientationSubclass: UINavigationController {

    - (NSUInteger)supportedInterfaceOrientations {
    if (self.topViewController.presentedViewController) {
    return self.topViewController.presentedViewController.supportedInterfaceOrientations;
    }
    return self.topViewController.supportedInterfaceOrientations;
    }
    
    - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
    }
    
}
