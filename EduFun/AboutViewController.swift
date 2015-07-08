//
//  AboutViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 7/3/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    var aboutText : UITextView!
    var bgGradLayer : CAGradientLayer = CAGradientLayer()
    var backButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgGradLayer.colors = [
            cgColorForRed(255.0, green:255.0, blue:255.0),
            cgColorForRed(255.0, green:224.0, blue:224.0),
            cgColorForRed(255.0, green:216.0, blue:173.0),
            cgColorForRed(255.0, green:255.0, blue:167.0),
            cgColorForRed(152.0, green:255.0, blue:152.0),
            cgColorForRed(162.0, green:255.0, blue:255.0)
        ]
        bgGradLayer.startPoint = CGPoint(x:0.0, y:0.0)
        bgGradLayer.endPoint = CGPoint(x:0.0, y:1.0)
        bgGradLayer.shouldRasterize = true
        view.layer.addSublayer(bgGradLayer)
        
        aboutText = UITextView()
        
        aboutText.editable = false
        aboutText.text = "KidsFun\r\rProgrammed by Douglas Carl Voss 2015\r\rArtwork in Card Match Game by Doug Voss, Font by fsuarez913\r\rArtwork in Coloring Book by Doug Voss\r\rUses the following third party code\r\rTHLabel by Tobias Hagemann\r\rSVGKit by Matt Rajca\r\rFont: SuperMario256.ttf by fsuarez913 (dafont.com) \r\rUIImage category extension from Trevor Harmon\r\rOBButton from Ole Begemann"
        
        aboutText.backgroundColor = UIColor.whiteColor()
        aboutText.layer.cornerRadius = 4.0
        view.addSubview(aboutText)
        
        aboutText.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(
            NSLayoutConstraint(
                item: aboutText,
                attribute: NSLayoutAttribute.Right,
                relatedBy: NSLayoutRelation.Equal,
                toItem: view,
                attribute: NSLayoutAttribute.RightMargin,
                multiplier: 1.0,
                constant: 0.0
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: aboutText,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: view,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: -20.0
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: aboutText,
                attribute: NSLayoutAttribute.Left,
                relatedBy: NSLayoutRelation.Equal,
                toItem: view,
                attribute: NSLayoutAttribute.LeftMargin,
                multiplier: 1.0,
                constant: 0.0
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: aboutText,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: view,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 20.0
            )
        )
        backButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.setTitle("Done", forState: UIControlState.Normal)
        backButton.setTitle("Done", forState: UIControlState.Highlighted)
        backButton.backgroundColor = UIColor.blueColor()
        //backButton.layer.backgroundColor = UIColor.blueColor().CGColor
        backButton.layer.cornerRadius = 4.0
        backButton.frame = CGRectMake(self.view.frame.width-60.0, self.view.frame.height-20.0, 60.0, 20.0)
        view.addSubview(backButton)
        backButton.addTarget(self, action: Selector("backButtonMethod:event:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func backButtonMethod(sender : THButton, event : UIEvent) {
        var app = UIApplication.sharedApplication().delegate as? AppDelegate
        app?.animateToViewController(ViewControllerEnum.TitleScreen, srcVCEnum: ViewControllerEnum.About)
    }
    
    override func viewDidLayoutSubviews() {
        bgGradLayer.frame = view.bounds
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
}
