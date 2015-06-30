//
//  ContainerViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/30/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var currentViewController = TitleScreenViewController()
    var childNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childNumber=0
        view.backgroundColor = UIColor.blueColor()
        
        NSLog("ViewController:  %@",self)
        currentViewController = TitleScreenViewController();
        
        addChildViewController(currentViewController)
        currentViewController.view.frame = view.bounds
        
        view.addSubview(currentViewController.view)
        currentViewController.didMoveToParentViewController(self)
    }
    
    func swapViewControllers() {
        
        var aNewViewController = ColoringBookViewController()
    
        childNumber++
        aNewViewController.view.layoutIfNeeded()
   
        aNewViewController.view.frame=self.view.bounds
        
        currentViewController.willMoveToParentViewController(nil)
        addChildViewController(aNewViewController)
    
        transitionFromViewController(
            currentViewController,
            toViewController: aNewViewController,
            duration: NSTimeInterval(1.0),
            options: UIViewAnimationOptions.TransitionCurlUp,
            animations: nil,
            completion:
            {(_) -> Void in
                self.currentViewController.removeFromParentViewController()
                aNewViewController.didMoveToParentViewController(self)
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
