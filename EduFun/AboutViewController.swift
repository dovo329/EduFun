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
            cgColor(red: 255.0, green:255.0, blue:255.0),
            cgColor(red: 255.0, green:224.0, blue:224.0),
            cgColor(red: 255.0, green:216.0, blue:173.0),
            cgColor(red: 255.0, green:255.0, blue:167.0),
            cgColor(red: 152.0, green:255.0, blue:152.0),
            cgColor(red: 162.0, green:255.0, blue:255.0)
        ]
        bgGradLayer.startPoint = CGPoint(x:0.0, y:0.0)
        bgGradLayer.endPoint = CGPoint(x:0.0, y:1.0)
        bgGradLayer.shouldRasterize = true
        view.layer.addSublayer(bgGradLayer)
        
        aboutText = UITextView()
        
        aboutText.isEditable = false
        aboutText.text = "KidsFun\r\rProgrammed by Douglas Carl Voss Copyright 2015\r\r\r\rArtwork in Card Match Game by Doug Voss, Font by fsuarez913\r\rArtwork in Coloring Book by Doug Voss\r\rArtwork in Adventures of Mr. Skunk by Doug Voss except for rope and wood textures from public domain\r\rrope image by Nikki Taylor: http://www.clker.com/clipart-223790.html\r\rwood texture by unknown: http://freestocktextures.com/texture/id/315\r\r\r\rIncorporates the following third party code:\r\rTHLabel by Tobias Hagemann\r\rFont: SuperMario256.ttf by fsuarez913 (dafont.com) \r\rUIImage category extension from Trevor Harmon\r\rOBButton from Ole Begemann\r\rSVGKit by Matt Rajca\r\r\r\rThanks:\r\rThanks to Matti Räty for SpriteKit rope cutting example\r\rThanks to Ray Wenderlich iOS Games by Tutorials book for SpriteKit tutorials.\r\rThanks to DevMountain: Joshua Howland, Taylor Mott, Caleb Hicks, Daniel Curvelo, Andrew Madsen, Layne Moseley, Bryan Bryce, Jordan Nelson, Jake Herrmann, and rest of Salt Lake City iOS immersive cohort #2 for help."
        
        aboutText.backgroundColor = UIColor.white
        aboutText.layer.cornerRadius = 4.0
        view.addSubview(aboutText)
        
        aboutText.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(
            NSLayoutConstraint(
                item: aboutText,
                attribute: NSLayoutConstraint.Attribute.right,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: view,
                attribute: NSLayoutConstraint.Attribute.rightMargin,
                multiplier: 1.0,
                constant: 0.0
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: aboutText,
                attribute: NSLayoutConstraint.Attribute.bottom,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: view,
                attribute: NSLayoutConstraint.Attribute.bottom,
                multiplier: 1.0,
                constant: -20.0
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: aboutText,
                attribute: NSLayoutConstraint.Attribute.left,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: view,
                attribute: NSLayoutConstraint.Attribute.leftMargin,
                multiplier: 1.0,
                constant: 0.0
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: aboutText,
                attribute: NSLayoutConstraint.Attribute.top,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: view,
                attribute: NSLayoutConstraint.Attribute.top,
                multiplier: 1.0,
                constant: 20.0
            )
        )
        backButton = UIButton(type: UIButton.ButtonType.custom)
        backButton.setTitle("Done", for: UIControl.State.normal)
        backButton.setTitle("Done", for: UIControl.State.highlighted)
        backButton.backgroundColor = UIColor.blue
        //backButton.layer.backgroundColor = UIColor.blueColor().CGColor
        backButton.layer.cornerRadius = 4.0
        backButton.frame = CGRect(x: self.view.frame.width-60.0, y: self.view.frame.height-20.0, width: 60.0, height: 20.0)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonMethod(sender:event:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func backButtonMethod(sender : THButton, event : UIEvent) {
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.animateToViewController(destVCEnum: ViewControllerEnum.TitleScreen, srcVCEnum: ViewControllerEnum.About)
    }
    
    override func viewDidLayoutSubviews() {
        bgGradLayer.frame = view.bounds
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }

    override var shouldAutorotate: Bool {
        return true
    }
}
