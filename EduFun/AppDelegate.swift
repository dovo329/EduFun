//
//  AppDelegate.swift
//  CollectionViewTest
//
//  Created by Douglas Voss on 6/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    @objc func animateToViewController(destVCEnum: UInt32, srcVCEnum: UInt32)
    {
        guard let window = window else {
            assert(false, "No window available")
            return
        }
        var destVC : UIViewController!
        
        let overlayView = UIScreen.main.snapshotView(afterScreenUpdates: true)
        let bounds = UIScreen.main.bounds
        print("bounds.width=\(bounds.width) height=\(bounds.height)")
        
        switch destVCEnum {
        case ViewControllerEnum.MrSkunk:

            //overlayView.transform = CGAffineTransformMakeRotation(-π/2)
            //overlayView.frame = CGRectMake(0, 0, 480, 320)
            destVC = MrSkunkViewController()

        case ViewControllerEnum.CardMatching:
            overlayView.transform = CGAffineTransform(rotationAngle: π/2)
            overlayView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width)
            destVC = MemoryGameViewController()

        case ViewControllerEnum.ColoringBook:
            destVC = ColoringBookViewController()

        case ViewControllerEnum.TitleScreen:
            if (srcVCEnum == ViewControllerEnum.CardMatching)
            {
                overlayView.transform = CGAffineTransform(rotationAngle: -π/2)
                overlayView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width)
            }
            else if (srcVCEnum == ViewControllerEnum.ColoringBook)
            {
                overlayView.transform = CGAffineTransform(rotationAngle: 0)
                overlayView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height) // why?  but I must or else
            }
            destVC = TitleScreenViewController()

        case ViewControllerEnum.About:
            destVC = AboutViewController()

        default:
            fatalError("unknown view controller enum passed")
        }
        
        destVC.view.addSubview(overlayView)
        window.rootViewController = destVC;
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations:
            { () -> Void in
                overlayView.alpha = 0.0
            },
            completion:
            { (_) -> Void in
                overlayView.removeFromSuperview()
            }
        )
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {

        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            assert(false, "Failed to create window")
            return
        }
        window.backgroundColor = UIColor.white
        window.rootViewController = TitleScreenViewController()
        window.makeKeyAndVisible()
    }
}

