//
//  TitleScreenViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/26/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class TitleScreenViewController: UIViewController {

    var titleLabel : THLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundGradient()
        setupTitleLabel()
    }

    func setupBackgroundGradient()
    {
        var bgGradLayer = CAGradientLayer()
        bgGradLayer.frame = view.bounds
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
    }
    
    func setupTitleLabel()
    {
        titleLabel = THLabel()
        titleLabel.text = "Kids Fun!"
        titleLabel.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        //titleLabel.font = UIFont(name: "Super Mario 256", size: 300.0)
        titleLabel.font = UIFont(name: "Super Mario 256", size: 45.0)
        titleLabel.font = titleLabel.font.fontWithSize(getFontSizeToFitFrameOfLabel(titleLabel)-6.0)
        titleLabel.frame.origin.y -= titleLabel.font.pointSize
        println("titleLabel.font.pointSize=\(titleLabel.font.pointSize)")
        titleLabel.frame.size.height = titleLabel.font.pointSize*1.3
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.yellowColor()
        titleLabel.strokeSize = (3.0/320.0)*titleLabel.frame.size.width
        titleLabel.strokeColor = UIColor.blackColor()
        titleLabel.shadowOffset = CGSizeMake(titleLabel.strokeSize, titleLabel.strokeSize)
        titleLabel.shadowColor = UIColor.blackColor()
        titleLabel.shadowBlur = (1.0/320.0)*titleLabel.frame.size.width
        titleLabel.layer.shouldRasterize = true
        titleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        view.addSubview(titleLabel)
        
        UIView.animateWithDuration(NSTimeInterval(3.0), delay: NSTimeInterval(0.0),
            usingSpringWithDamping: CGFloat(0.4),
            initialSpringVelocity: CGFloat(0.0),
            options: nil,
            animations:
            {(_) -> (Void) in
                self.titleLabel.frame.origin.y = 20.0
            },
            completion:
            {(_) -> (Void) in
                
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
