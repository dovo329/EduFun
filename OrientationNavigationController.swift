//
//  OrientationNavigationController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/30/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class OrientationNavigationController: UINavigationController {

    override func supportedInterfaceOrientations() -> Int {
        if topViewController.presentedViewController != nil
        {
            return topViewController.presentedViewController!.supportedInterfaceOrientations()
        }
        else
        {
            return topViewController.supportedInterfaceOrientations()
        }
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return topViewController.preferredInterfaceOrientationForPresentation()
    }
    
    /*- (NSUInteger)supportedInterfaceOrientations {
    if (self.topViewController.presentedViewController) {
    return self.topViewController.presentedViewController.supportedInterfaceOrientations;
    }
    return self.topViewController.supportedInterfaceOrientations;
    }
    
    - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
    }*/

}
