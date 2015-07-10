//
//  MrSkunkViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class MrSkunkViewController: UIViewController, MrSkunkLevelDelegate {
    
    var playableRect : CGRect = CGRectMake(0,0,0,0)
    var playableHeight : CGFloat = 0.0
    var playableMargin : CGFloat = 0.0
    //var exitButton : THButton!
    var toolbar = UIToolbar()
    let kToolbarHeight = CGFloat(25.0)
    var exitBarButton : UIBarButtonItem!
    var mapButton : UIBarButtonItem!
    var restartBarButton : UIBarButtonItem!
    var flexibleSpace : UIBarButtonItem!
    var completeLabel : THLabel = THLabel()
    var highestCompletedLevelNum : Int = 0
    let kHighestCompletedLevelKey = "highest.completed.level.key"
    var mapView : MrSkunkMapView!
    var mapVisible : Bool = false
    var currentLevel : Int = 0
    
    init(_ coder: NSCoder? = nil) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let level = defaults.integerForKey(kHighestCompletedLevelKey) as Int?
        {
            highestCompletedLevelNum = level
        }
        else
        {
            highestCompletedLevelNum = 0
        }
        println("highestCompletedLevelNum = \(highestCompletedLevelNum)")
        
        currentLevel = highestCompletedLevelNum+1
        
        if let coder = coder {
            super.init(coder: coder)
        } else {
            super.init(nibName: nil, bundle:nil)
        }
        
        mapView = MrSkunkMapView(frame: makeCenteredRectWithScale(0.7, ofFrame:view.frame), highestCompletedLevelNum: highestCompletedLevelNum)
        println("view.frame=\(view.frame) mapView.frame=\(mapView.frame)")
    }
    
    required convenience init(coder: NSCoder) {
        self.init(coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startup(level: currentLevel)
    }
    
    func startup(#level : Int)
    {
        var scene : MrSkunkLevelScene!
        switch level
        {
        case 1:
            if let level = MrSkunkLevel1Scene.unarchiveFromFile("MrSkunkLevel1") as? MrSkunkLevel1Scene
            {
                scene = level
            }
            else
            {
                fatalError("level1 failed to load")
            }
            
        case 2:
            if let level = MrSkunkLevel2Scene.unarchiveFromFile("MrSkunkLevel2") as? MrSkunkLevel2Scene
            {
                scene = level
            }
            else
            {
                fatalError("level2 failed to load")
            }
            
        case 3:
            if let level = MrSkunkLevel3Scene.unarchiveFromFile("MrSkunkLevel3") as? MrSkunkLevel3Scene
            {
                scene = level
            }
            else
            {
                fatalError("level3 failed to load")
            }
            
        default:
            fatalError("Invalid Level")
        }
        
        //scaleOutRemoveView(completeLabel, duration: 0.5, delay: 0.0)
        // Configure the view.
        // let skView = self.view as! SKView
        var view : SKView = SKView(frame: UIScreen.mainScreen().applicationFrame)
        self.view = view
        let skView = self.view as! SKView
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .AspectFill
        scene.mrSkunkDelegate = self
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        // know we are coming from title screen which is always portrait to this screen which is always landscape but it hasn't autorotated yet but that's why height and width are swapped below
        playableHeight = skView.frame.size.width / maxAspectRatio
        playableMargin = (skView.frame.size.height-playableHeight)/2.0
        playableRect = CGRect(x:0, y: playableMargin, width: skView.frame.size.width, height: playableHeight)
        
        exitBarButton = UIBarButtonItem(title: "Exit", style: UIBarButtonItemStyle.Plain, target: self, action: "exitButtonMethod")
        
        var restartImg = UIImage(named: "Restart")
        restartImg = restartImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        restartBarButton = UIBarButtonItem(image: restartImg, style: UIBarButtonItemStyle.Plain, target: self, action: "restartMethod")
        
        var mapImg = UIImage(named: "SkunkMap")
        mapImg = mapImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        mapButton = UIBarButtonItem(image: mapImg, style: UIBarButtonItemStyle.Plain, target: self, action: "mapMethod")
        
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbar.frame = CGRectMake(0.0, 0.0, skView.frame.size.width, kToolbarHeight)
        
        toolbar.items = [exitBarButton, flexibleSpace, restartBarButton, flexibleSpace, mapButton]
        skView.addSubview(toolbar)
        
        levelHint(level: level)
        
        //skView.showsPhysics = true
        skView.presentScene(scene)
    }
    
    func exitButtonMethod()
    {
        var app = UIApplication.sharedApplication().delegate as? AppDelegate
        app?.animateToViewController(ViewControllerEnum.TitleScreen, srcVCEnum: ViewControllerEnum.MrSkunk)
    }
    
    func restartMethod()
    {
        startup(level: currentLevel)
    }
    
    func mapMethod()
    {
        //println("Put in Map here")
        if (mapVisible)
        {
            scaleOutRemoveView(mapView, duration: 0.25, delay: 0.0)
        }
        else
        {
            scaleInAddView(mapView, parentView:view, duration: 0.25, delay: 0.0)
        }
        mapVisible = !mapVisible
        //only apply the blur if the user hasn't disabled transparency effects
        /*if !UIAccessibilityIsReduceTransparencyEnabled() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds //view is self.view in a UIViewController
        view.addSubview(blurEffectView)
        //if you have more UIViews on screen, use insertSubview:belowSubview: to place it underneath the lowest view
        
        //add auto layout constraints so that the blur fills the screen upon rotating device
        blurEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        } else {
        view.backgroundColor = UIColor.blackColor()
        }*/
    }
    
    func levelHint(#level: Int)
    {
        switch (level)
        {
        case 1:
            break
        case 2:
            let textHeight = CGFloat(15.0)
            var hint = THLabel()
            hint.text = "Touch Cannon to Shoot"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.Center
            hint.textColor = UIColor.yellowColor()
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.blackColor()
            hint.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint.layer.shouldRasterize = true
            view.addSubview(hint)
            
            var hint2 = THLabel()
            hint2.text = "Touch Screen To Aim"
            hint2.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: textHeight)
            hint2.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint2.frame.size.height = hint2.font.pointSize*1.3
            hint2.frame.origin.y = view.frame.size.height-(playableMargin+hint2.frame.size.height+hint.frame.size.height)
            hint2.textAlignment = NSTextAlignment.Center
            hint2.textColor = UIColor.yellowColor()
            hint2.strokeSize = (0.8/320.0)*hint2.frame.size.width
            hint2.strokeColor = UIColor.blackColor()
            hint2.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint2.layer.shouldRasterize = true
            view.addSubview(hint2)
            
        case 3:
            let textHeight = CGFloat(15.0)
            var hint = THLabel()
            hint.text = "Touch Orange Wedge to Start"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.Center
            hint.textColor = UIColor.yellowColor()
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.blackColor()
            hint.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint.layer.shouldRasterize = true
            view.addSubview(hint)
        
        default:
            fatalError("Invalid Level")
        }
    }
    
    func levelComplete() {
        //println("mr skunk delegate method called!")
        completeLabel.text = "Complete!"
        completeLabel.frame = makeCenteredRectWithScale(0.8, ofFrame: view.frame)
        completeLabel.font = UIFont(name: "Super Mario 256", size: 45.0)
        completeLabel.font = completeLabel.font.fontWithSize(getFontSizeToFitFrameOfLabel(completeLabel)-5.0)
        completeLabel.frame.size.height = completeLabel.font.pointSize*1.3
        completeLabel.frame.origin.y = (view.frame.size.height/2.0) - completeLabel.frame.size.height
        completeLabel.textAlignment = NSTextAlignment.Center
        completeLabel.textColor = UIColor.yellowColor()
        completeLabel.strokeSize = (3.0/320.0)*completeLabel.frame.size.width
        completeLabel.strokeColor = UIColor.blackColor()
        completeLabel.shadowOffset = CGSizeMake(completeLabel.strokeSize, completeLabel.strokeSize)
        completeLabel.shadowColor = UIColor.blackColor()
        completeLabel.shadowBlur = (1.0/320.0)*completeLabel.frame.size.width
        completeLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        completeLabel.layer.shouldRasterize = true
        view.addSubview(completeLabel)
        spin3BounceView(completeLabel, duration:0.5)
        
        var nextButtonFrame = makeCenteredRectWithScale(0.4, ofFrame: view.frame)
        nextButtonFrame.origin.y += completeLabel.frame.size.height*1.5
        nextButtonFrame.size.height *= 0.25
        var nextButton = THButton(frame: nextButtonFrame, text: "Next Level")
        nextButton.addTarget(self, action: Selector("nextButtonMethod:event:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(nextButton)
        bounceInView(nextButton, duration:CGFloat(0.5), delay:CGFloat(0.0))
    }
    
    func nextButtonMethod(sender : THButton, event : UIEvent)
    {
        currentLevel++
        highestCompletedLevelNum++
        startup(level: currentLevel)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    deinit {
        // save highest completed level
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(highestCompletedLevelNum, forKey: kHighestCompletedLevelKey)
        println("Mr Skunk ViewController deinit")
    }
}
