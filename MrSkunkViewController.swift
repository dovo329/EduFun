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
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

let kMrSkunkToolbarWidth = CGFloat(30.0)
let kMrSkunkIconHeight = CGFloat(30.0)
let kMrSkunkIconSpacing = CGFloat(20.0)

class MrSkunkViewController: UIViewController, MrSkunkLevelDelegate, MrSkunkMapViewDelegate {
    
    var skView : SKView!
    let kNewLevelAnimationDuration = 1.0
    var playableRect : CGRect = CGRectMake(0,0,0,0)
    var playableHeight : CGFloat = 0.0
    var playableMargin : CGFloat = 0.0
    //var exitButton : THButton!
    //var toolbar = UIToolbar()
    //var exitBarButton : UIBarButtonItem!
    //var mapButton : UIBarButtonItem!
    //var restartBarButton : UIBarButtonItem!
    
    var levelCompleteFlag : Bool = false
    
    var exitButton : THButton!
    var mapButton : UIButton!
    var restartButton : UIButton!
    
    //var flexibleSpace : UIBarButtonItem!
    var completeLabel : THLabel = THLabel()
    var nextButton : THButton = THButton(frame: CGRectMake(0,0,0,0))
    var highestCompletedLevelNum : Int = 0
    let kHighestCompletedLevelKey = "highest.completed.level.key"
    var mapView : MrSkunkMapView!
    var mapVisible : Bool = false
    var currentLevel : Int = 0
    var hint = THLabel()
    var hint2 = THLabel()
    
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
        print("highestCompletedLevelNum = \(highestCompletedLevelNum)")
        
        if (highestCompletedLevelNum >= kNumLevels)
        {
            currentLevel = 1
        }
        else
        {
            currentLevel = highestCompletedLevelNum + 1
        }
        //currentLevel=8 // just to test level out
        
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = SKView(frame: UIScreen.mainScreen().applicationFrame)
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        self.view.addSubview(skView)
        mapView = MrSkunkMapView(frame: makeCenteredRectWithScale(0.7, ofFrame:self.view.frame), highestCompletedLevelNum: highestCompletedLevelNum)
        mapView.delegate = self
        //println("view.frame=\(view.frame) mapView.frame=\(mapView.frame)")
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        // know we are coming from title screen which is always portrait to this screen which is always landscape but it hasn't autorotated yet but that's why height and width are swapped below
        playableHeight = self.view.frame.size.width / maxAspectRatio
        playableMargin = (self.view.frame.size.height-playableHeight)/2.0
        playableRect = CGRect(x:0, y: playableMargin, width: self.view.frame.size.width, height: playableHeight)
        
        let exitButtonFrame = CGRectMake(view.frame.size.width-(2.0*kMrSkunkToolbarWidth), 0, 2.0*kMrSkunkToolbarWidth, kMrSkunkIconHeight)
        exitButton = THButton(frame: exitButtonFrame, text: "Exit")
        exitButton!.addTarget(self, action: Selector("exitButtonMethod"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(exitButton)

        //exitBarButton = UIBarButtonItem(title: "Exit", style: UIBarButtonItemStyle.Plain, target: self, action: "exitButtonMethod")
        
        let restartButtonFrame = CGRectMake(view.frame.size.width-(2.0*kMrSkunkToolbarWidth), (kMrSkunkIconHeight+kMrSkunkIconSpacing), 2.0*kMrSkunkToolbarWidth, kMrSkunkIconHeight)
        var restartImg = UIImage(named: "Restart")
        restartImg = restartImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        restartButton = UIButton(type: UIButtonType.Custom)
        restartButton.setImage(restartImg, forState: UIControlState.Normal)
        restartButton.frame = restartButtonFrame
        restartButton!.addTarget(self, action: Selector("restartMethod"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(restartButton)
        //restartBarButton = UIBarButtonItem(image: restartImg, style: UIBarButtonItemStyle.Plain, target: self, action: "restartMethod")
        
        var mapImg = UIImage(named: "SkunkMap")
        mapImg = mapImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let mapButtonFrame = CGRectMake(view.frame.size.width-(2.0*kMrSkunkToolbarWidth), 2*(kMrSkunkIconHeight+kMrSkunkIconSpacing), 2.0*kMrSkunkToolbarWidth, kMrSkunkIconHeight)
        mapButton = UIButton(type: UIButtonType.Custom)
        mapButton.setImage(mapImg, forState: UIControlState.Normal)
        mapButton.frame = mapButtonFrame
        mapButton!.addTarget(self, action: Selector("mapMethod"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(mapButton)
        //mapButton = UIBarButtonItem(image: mapImg, style: UIBarButtonItemStyle.Plain, target: self, action: "mapMethod")
        
        //flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        //toolbar.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, kMrSkunkToolbarHeight)
        
        //toolbar.items = [exitBarButton, flexibleSpace, restartBarButton, flexibleSpace, mapButton]
        
        startup(level: currentLevel)
        
        //toolbar.frame = CGRectMake(view.frame.size.width-(view.frame.size.height/2.0), (view.frame.size.height-kMrSkunkToolbarHeight)/2.0, view.frame.size.height, kMrSkunkToolbarHeight)
        //toolbar.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI/2));
        
        //toolbar.frame = CGRectMake(size.width-kMrSkunkToolbarHeight, 0, kMrSkunkToolbarHeight, size.height)
        
        //self.view.addSubview(toolbar)
    }
    
    func startup(level level : Int)
    {
        levelCompleteFlag = false
        scaleOutRemoveView(completeLabel, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(nextButton, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(hint, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(hint2, duration: 0.5, delay: 0.0)
        
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
            
        case 4:
            if let level = MrSkunkLevel4Scene.unarchiveFromFile("MrSkunkLevel4") as? MrSkunkLevel4Scene
            {scene = level}
            else
            {fatalError("level4 failed to load")}
            
        case 5:
            if let level = MrSkunkLevel5Scene.unarchiveFromFile("MrSkunkLevel5") as? MrSkunkLevel5Scene
            {scene = level}
            else
            {fatalError("level5 failed to load")}
            
        case 6:
            if let level = MrSkunkLevel6Scene.unarchiveFromFile("MrSkunkLevel6") as? MrSkunkLevel6Scene
            {scene = level}
            else
            {fatalError("level6 failed to load")}
            
        case 7:
            if let level = MrSkunkLevel7Scene.unarchiveFromFile("MrSkunkLevel7") as? MrSkunkLevel7Scene
            {scene = level}
            else
            {fatalError("level7 failed to load")}
            
        case (kNumLevels+1):
            if let level = MrSkunkWinScene.unarchiveFromFile("MrSkunkWinScene") as? MrSkunkWinScene
            {
                scene = level
            }
            else
            {
                fatalError("win scene failed to load")
            }
            
        default:
            fatalError("Invalid Level")
        }
        
        if skView.scene == nil
        {
            levelHint(level: currentLevel)
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .AspectFill
        scene.mrSkunkDelegate = self
        //skView.showsPhysics = true
        let reveal = SKTransition.flipHorizontalWithDuration(kNewLevelAnimationDuration)
        skView.presentScene(scene, transition: reveal)
    }
    
    func willMoveFromView() {
        // skView scene transition complete
        //println("What happen?")
        levelHint(level: currentLevel)
    }
    
    func exitButtonMethod()
    {
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
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
            //mapView.removeFromSuperview()
        }
        else
        {
            scaleInAddView(mapView, parentView:view, duration: 0.25, delay: 0.0)
            //skView.addSubview(mapView)
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
    
    func levelHint(level level: Int)
    {
        switch (level)
        {
        case 1:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Touch/Swipe Rope To Free Wood"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.Center
            hint.textColor = UIColor.yellowColor()
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.blackColor()
            hint.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(hint, parentView: view, duration: 0.5, delay: 0.0)
            
        case 2:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Touch Cannon to Shoot"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.Center
            hint.textColor = UIColor.yellowColor()
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.blackColor()
            hint.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint.layer.shouldRasterize = true
            
            hint2 = THLabel()
            hint2.text = "Touch Screen To Aim"
            hint2.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint2.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint2.frame.size.height = hint2.font.pointSize*1.3
            hint2.frame.origin.y = view.frame.size.height-(playableMargin+hint2.frame.size.height+hint.frame.size.height)
            hint2.textAlignment = NSTextAlignment.Center
            hint2.textColor = UIColor.yellowColor()
            hint2.strokeSize = (0.8/320.0)*hint2.frame.size.width
            hint2.strokeColor = UIColor.blackColor()
            hint2.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint2.layer.shouldRasterize = true
            
            scaleInAddView(hint, parentView: view, duration: 0.5, delay: 0.0)
            scaleInAddView(hint2, parentView: view, duration: 0.5, delay: 0.0)
            
        case 3:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Touch Orange Wedge to Start"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.Center
            hint.textColor = UIColor.yellowColor()
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.blackColor()
            hint.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(hint, parentView: view, duration: 0.5, delay: 0.0)
        
        case 4:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "You can swipe two ropes at once"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.Center
            hint.textColor = UIColor.yellowColor()
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.blackColor()
            hint.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(hint, parentView: view, duration: 0.5, delay: 0.0)
            
        case 5:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Touch Arrow to Change Gravity"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.Center
            hint.textColor = UIColor.yellowColor()
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.blackColor()
            hint.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(hint, parentView: view, duration: 0.5, delay: 0.0)
          
        case 6:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Miss Skunk can help you"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.Center
            hint.textColor = UIColor.yellowColor()
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.blackColor()
            hint.layer.anchorPoint = CGPointMake(0.5, 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(hint, parentView: view, duration: 0.5, delay: 0.0)
            
        case 7:
            break
            
        case (kNumLevels+1):
            break
            
        default:
            fatalError("Invalid Level")
        }
    }
    
    func autoRestartLevel() {
        if !levelCompleteFlag // only autorestart if level is not yet complete
        {
            startup(level: currentLevel)
        }
    }
    
    func hintDisappear() {
        scaleOutRemoveView(hint, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(hint2, duration: 0.5, delay: 0.0)
    }
    
    func levelComplete() {
        levelCompleteFlag = true
        hintDisappear()
        
        if currentLevel <= kNumLevels
        {
            //println("mr skunk delegate method called!")
            completeLabel = THLabel()
            completeLabel.text = "Complete!"
            completeLabel.frame = makeCenteredRectWithScale(0.8, ofFrame: skView.frame)
            completeLabel.font = UIFont(name: "Super Mario 256", size: 45.0)
            completeLabel.font = completeLabel.font.fontWithSize(getFontSizeToFitFrameOfLabel(completeLabel)-5.0)
            completeLabel.frame.size.height = completeLabel.font.pointSize*1.2
            completeLabel.frame.origin.y = (skView.frame.size.height/2.0) - completeLabel.frame.size.height
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
            
            var nextButtonFrame = makeCenteredRectWithScale(0.4, ofFrame: view.frame)
            nextButtonFrame.origin.y = completeLabel.frame.origin.y + (completeLabel.frame.size.height)
            nextButtonFrame.size.height *= 0.25
            //if (nextButton == nil)
            //{
            nextButton = THButton(frame: nextButtonFrame, text: "Next Level")
            //}
            nextButton.label.text = "Next Level"
            nextButton.frame = nextButtonFrame
            nextButton.addTarget(self, action: Selector("nextButtonMethod:event:"), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(nextButton)
            
            bounceInView(nextButton, duration:CGFloat(0.5), delay:CGFloat(0.0))
            bounceInView(completeLabel, duration:CGFloat(0.5), delay:CGFloat(0.0))
            
            //hint.removeFromSuperview()
            //hint2.removeFromSuperview()
            //scaleOutRemoveView(hint, duration: 0.5, delay: 0.0)
            //scaleOutRemoveView(hint2, duration: 0.5, delay: 0.0)
        }        
        else
        {
            // you win scene
            var nextButtonFrame = makeCenteredRectWithScale(0.5, ofFrame: view.frame)
            nextButtonFrame.size.height *= 0.7
            //if (nextButton == nil)
            //{
            nextButton = THButton(frame: nextButtonFrame, text: "Exit")
            //}
            nextButton.label.text = "Exit"
            nextButton.frame = nextButtonFrame
            nextButton.addTarget(self, action: Selector("exitButtonMethod"), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(nextButton)
            
            bounceInView(nextButton, duration:CGFloat(0.5), delay:CGFloat(0.0))
        }
        
        if (currentLevel > highestCompletedLevelNum)
        {
            highestCompletedLevelNum = currentLevel
        }
        
        scaleOutRemoveView(mapView, duration: 0.25, delay: 0.0)
        mapVisible = false
        mapView = MrSkunkMapView(frame: makeCenteredRectWithScale(0.7, ofFrame:self.view.frame), highestCompletedLevelNum: highestCompletedLevelNum)
        mapView.delegate = self
        //mapView.collectionView.reloadData()
        saveHighestCompletedLevelNum()
    }
    
    func saveHighestCompletedLevelNum()
    {
        // save highest completed level
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(highestCompletedLevelNum, forKey: kHighestCompletedLevelKey)
        //println("saving highest completed level \(highestCompletedLevelNum)")
    }
    
    func nextButtonMethod(sender : THButton, event : UIEvent)
    {
        currentLevel++
        if currentLevel > (kNumLevels + 1) // +1 because of youwin scene
        {
            currentLevel=1
            highestCompletedLevelNum=kNumLevels
        }
        startup(level: currentLevel)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.LandscapeRight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func mapLevelSelected(level: Int)
    {
        //println("The map selected level \(level)")
        scaleOutRemoveView(mapView, duration: 0.25, delay: 0.0)
        mapVisible = false
        currentLevel = level
        startup(level: level)
    }
}
