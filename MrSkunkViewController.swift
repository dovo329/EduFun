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
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKScene
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
    var playableRect : CGRect = CGRect(x: 0, y: 0, width: 0, height:0)
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
    var nextButton : THButton = THButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var highestCompletedLevelNum : Int = 0
    let kHighestCompletedLevelKey = "highest.completed.level.key"
    var mapView : MrSkunkMapView!
    var mapVisible : Bool = false
    var currentLevel : Int = 0
    var hint = THLabel()
    var hint2 = THLabel()
    
    init(_ coder: NSCoder? = nil) {
        
        let defaults = UserDefaults.standard
        if let level = defaults.integer(forKey: kHighestCompletedLevelKey) as Int?
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
        
        skView = SKView(frame: UIScreen.main.applicationFrame)
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        self.view.addSubview(skView)
        mapView = MrSkunkMapView(frame: makeCenteredRectWithScale(scale: 0.7, ofFrame:self.view.frame), highestCompletedLevelNum: highestCompletedLevelNum)
        mapView.delegate = self
        //println("view.frame=\(view.frame) mapView.frame=\(mapView.frame)")
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        // know we are coming from title screen which is always portrait to this screen which is always landscape but it hasn't autorotated yet but that's why height and width are swapped below
        playableHeight = self.view.frame.size.width / maxAspectRatio
        playableMargin = (self.view.frame.size.height-playableHeight)/2.0
        playableRect = CGRect(x:0, y: playableMargin, width: self.view.frame.size.width, height: playableHeight)
        
        let exitButtonFrame = CGRect(x: view.frame.size.width-(2.0*kMrSkunkToolbarWidth), y: 0, width: 2.0*kMrSkunkToolbarWidth, height: kMrSkunkIconHeight)
        exitButton = THButton(frame: exitButtonFrame, text: "Exit")
        exitButton!.addTarget(self, action: #selector(self.exitButtonMethod), for: UIControlEvents.touchUpInside)
        view.addSubview(exitButton)

        //exitBarButton = UIBarButtonItem(title: "Exit", style: UIBarButtonItemStyle.Plain, target: self, action: "exitButtonMethod")
        
        let restartButtonFrame = CGRect(x: view.frame.size.width-(2.0*kMrSkunkToolbarWidth), y: (kMrSkunkIconHeight+kMrSkunkIconSpacing), width: 2.0*kMrSkunkToolbarWidth, height: kMrSkunkIconHeight)
        var restartImg = UIImage(named: "Restart")
        restartImg = restartImg?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        restartButton = UIButton(type: UIButtonType.custom)
        restartButton.setImage(restartImg, for: UIControlState.normal)
        restartButton.frame = restartButtonFrame
        restartButton!.addTarget(self, action: #selector(restartMethod), for: UIControlEvents.touchUpInside)
        view.addSubview(restartButton)
        //restartBarButton = UIBarButtonItem(image: restartImg, style: UIBarButtonItemStyle.Plain, target: self, action: "restartMethod")
        
        var mapImg = UIImage(named: "SkunkMap")
        mapImg = mapImg?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let mapButtonFrame = CGRect(x: view.frame.size.width-(2.0*kMrSkunkToolbarWidth), y: 2*(kMrSkunkIconHeight+kMrSkunkIconSpacing), width: 2.0*kMrSkunkToolbarWidth, height: kMrSkunkIconHeight)
        mapButton = UIButton(type: UIButtonType.custom)
        mapButton.setImage(mapImg, for: UIControlState.normal)
        mapButton.frame = mapButtonFrame
        mapButton!.addTarget(self, action: #selector(mapMethod), for: UIControlEvents.touchUpInside)
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
    
    func startup(level : Int)
    {
        levelCompleteFlag = false
        scaleOutRemoveView(view: completeLabel, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(view: nextButton, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(view: hint, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(view: hint2, duration: 0.5, delay: 0.0)
        
        var scene : MrSkunkLevelScene!
        switch level
        {
        case 1:
            if let level = MrSkunkLevel1Scene.unarchiveFromFile(file: "MrSkunkLevel1") as? MrSkunkLevel1Scene
            {
                scene = level
            }
            else
            {
                fatalError("level1 failed to load")
            }
            
        case 2:
            if let level = MrSkunkLevel2Scene.unarchiveFromFile(file: "MrSkunkLevel2") as? MrSkunkLevel2Scene
            {
                scene = level
            }
            else
            {
                fatalError("level2 failed to load")
            }
            
        case 3:
            if let level = MrSkunkLevel3Scene.unarchiveFromFile(file: "MrSkunkLevel3") as? MrSkunkLevel3Scene
            {
                scene = level
            }
            else
            {
                fatalError("level3 failed to load")
            }
            
        case 4:
            if let level = MrSkunkLevel4Scene.unarchiveFromFile(file: "MrSkunkLevel4") as? MrSkunkLevel4Scene
            {scene = level}
            else
            {fatalError("level4 failed to load")}
            
        case 5:
            if let level = MrSkunkLevel5Scene.unarchiveFromFile(file: "MrSkunkLevel5") as? MrSkunkLevel5Scene
            {scene = level}
            else
            {fatalError("level5 failed to load")}
            
        case 6:
            if let level = MrSkunkLevel6Scene.unarchiveFromFile(file: "MrSkunkLevel6") as? MrSkunkLevel6Scene
            {scene = level}
            else
            {fatalError("level6 failed to load")}
            
        case 7:
            if let level = MrSkunkLevel7Scene.unarchiveFromFile(file: "MrSkunkLevel7") as? MrSkunkLevel7Scene
            {scene = level}
            else
            {fatalError("level7 failed to load")}
            
        case (kNumLevels+1):
            if let level = MrSkunkWinScene.unarchiveFromFile(file: "MrSkunkWinScene") as? MrSkunkWinScene
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
        scene.scaleMode = .aspectFill
        scene.mrSkunkDelegate = self
        //skView.showsPhysics = true
        let reveal = SKTransition.flipHorizontal(withDuration: kNewLevelAnimationDuration)
        skView.presentScene(scene, transition: reveal)
    }
    
    func willMoveFromView() {
        // skView scene transition complete
        //println("What happen?")
        levelHint(level: currentLevel)
    }
    
    @objc func exitButtonMethod()
    {
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.animateToViewController(destVCEnum: ViewControllerEnum.TitleScreen, srcVCEnum: ViewControllerEnum.MrSkunk)
    }
    
    @objc func restartMethod()
    {
        startup(level: currentLevel)
    }
    
    @objc func mapMethod()
    {
        //println("Put in Map here")
        if (mapVisible)
        {
            scaleOutRemoveView(view: mapView, duration: 0.25, delay: 0.0)
            //mapView.removeFromSuperview()
        }
        else
        {
            scaleInAddView(view: mapView, parentView:view, duration: 0.25, delay: 0.0)
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
    
    func levelHint(level: Int)
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
            hint.textAlignment = NSTextAlignment.center
            hint.textColor = UIColor.yellow
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.black
            hint.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(view: hint, parentView: view, duration: 0.5, delay: 0.0)
            
        case 2:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Touch Cannon to Shoot"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.center
            hint.textColor = UIColor.yellow
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.black
            hint.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hint.layer.shouldRasterize = true
            
            hint2 = THLabel()
            hint2.text = "Touch Screen To Aim"
            hint2.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint2.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint2.frame.size.height = hint2.font.pointSize*1.3
            hint2.frame.origin.y = view.frame.size.height-(playableMargin+hint2.frame.size.height+hint.frame.size.height)
            hint2.textAlignment = NSTextAlignment.center
            hint2.textColor = UIColor.yellow
            hint2.strokeSize = (0.8/320.0)*hint2.frame.size.width
            hint2.strokeColor = UIColor.black
            hint2.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hint2.layer.shouldRasterize = true
            
            scaleInAddView(view: hint, parentView: view, duration: 0.5, delay: 0.0)
            scaleInAddView(view: hint2, parentView: view, duration: 0.5, delay: 0.0)
            
        case 3:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Touch Orange Wedge to Start"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.center
            hint.textColor = UIColor.yellow
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.black
            hint.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(view: hint, parentView: view, duration: 0.5, delay: 0.0)
        
        case 4:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "You can swipe two ropes at once"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.center
            hint.textColor = UIColor.yellow
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.black
            hint.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(view: hint, parentView: view, duration: 0.5, delay: 0.0)
            
        case 5:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Touch Arrow to Change Gravity"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.center
            hint.textColor = UIColor.yellow
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.black
            hint.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(view: hint, parentView: view, duration: 0.5, delay: 0.0)
          
        case 6:
            let textHeight = CGFloat(15.0)
            hint = THLabel()
            hint.text = "Miss Skunk can help you"
            hint.frame = CGRect(x: 0.0, y: 0.0, width: skView.frame.size.width, height: textHeight)
            hint.font = UIFont(name: "Super Mario 256", size: textHeight)
            hint.frame.size.height = hint.font.pointSize*1.3
            hint.frame.origin.y = view.frame.size.height-(playableMargin+hint.frame.size.height)
            hint.textAlignment = NSTextAlignment.center
            hint.textColor = UIColor.yellow
            hint.strokeSize = (0.8/320.0)*hint.frame.size.width
            hint.strokeColor = UIColor.black
            hint.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            hint.layer.shouldRasterize = true
            scaleInAddView(view: hint, parentView: view, duration: 0.5, delay: 0.0)
            
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
        scaleOutRemoveView(view: hint, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(view: hint2, duration: 0.5, delay: 0.0)
    }
    
    func levelComplete() {
        levelCompleteFlag = true
        hintDisappear()
        
        if currentLevel <= kNumLevels
        {
            //println("mr skunk delegate method called!")
            completeLabel = THLabel()
            completeLabel.text = "Complete!"
            completeLabel.frame = makeCenteredRectWithScale(scale: 0.8, ofFrame: skView.frame)
            completeLabel.font = UIFont(name: "Super Mario 256", size: 45.0)
            completeLabel.font = completeLabel.font.withSize(getFontSizeToFitFrameOfLabel(label: completeLabel)-5.0)
            completeLabel.frame.size.height = completeLabel.font.pointSize*1.2
            completeLabel.frame.origin.y = (skView.frame.size.height/2.0) - completeLabel.frame.size.height
            completeLabel.textAlignment = NSTextAlignment.center
            completeLabel.textColor = UIColor.yellow
            completeLabel.strokeSize = (3.0/320.0)*completeLabel.frame.size.width
            completeLabel.strokeColor = UIColor.black
            completeLabel.shadowOffset = CGSize(width: completeLabel.strokeSize, height: completeLabel.strokeSize)
            completeLabel.shadowColor = UIColor.black
            completeLabel.shadowBlur = (1.0/320.0)*completeLabel.frame.size.width
            completeLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            completeLabel.layer.shouldRasterize = true
            view.addSubview(completeLabel)
            
            var nextButtonFrame = makeCenteredRectWithScale(scale: 0.4, ofFrame: view.frame)
            nextButtonFrame.origin.y = completeLabel.frame.origin.y + (completeLabel.frame.size.height)
            nextButtonFrame.size.height *= 0.25
            //if (nextButton == nil)
            //{
            nextButton = THButton(frame: nextButtonFrame, text: "Next Level")
            //}
            nextButton.label.text = "Next Level"
            nextButton.frame = nextButtonFrame
            nextButton.addTarget(self, action: #selector(nextButtonMethod(sender:event:)), for: UIControlEvents.touchUpInside)
            view.addSubview(nextButton)
            
            bounceInView(view: nextButton, duration:CGFloat(0.5), delay:CGFloat(0.0))
            bounceInView(view: completeLabel, duration:CGFloat(0.5), delay:CGFloat(0.0))
            
            //hint.removeFromSuperview()
            //hint2.removeFromSuperview()
            //scaleOutRemoveView(hint, duration: 0.5, delay: 0.0)
            //scaleOutRemoveView(hint2, duration: 0.5, delay: 0.0)
        }        
        else
        {
            // you win scene
            var nextButtonFrame = makeCenteredRectWithScale(scale: 0.5, ofFrame: view.frame)
            nextButtonFrame.size.height *= 0.7
            //if (nextButton == nil)
            //{
            nextButton = THButton(frame: nextButtonFrame, text: "Exit")
            //}
            nextButton.label.text = "Exit"
            nextButton.frame = nextButtonFrame
            nextButton.addTarget(self, action: #selector(self.exitButtonMethod), for: UIControlEvents.touchUpInside)
            view.addSubview(nextButton)
            
            bounceInView(view: nextButton, duration:CGFloat(0.5), delay:CGFloat(0.0))
        }
        
        if (currentLevel > highestCompletedLevelNum)
        {
            highestCompletedLevelNum = currentLevel
        }
        
        scaleOutRemoveView(view: mapView, duration: 0.25, delay: 0.0)
        mapVisible = false
        mapView = MrSkunkMapView(frame: makeCenteredRectWithScale(scale: 0.7, ofFrame:self.view.frame), highestCompletedLevelNum: highestCompletedLevelNum)
        mapView.delegate = self
        //mapView.collectionView.reloadData()
        saveHighestCompletedLevelNum()
    }
    
    func saveHighestCompletedLevelNum()
    {
        // save highest completed level
        let defaults = UserDefaults.standard
        defaults.set(highestCompletedLevelNum, forKey: kHighestCompletedLevelKey)
        //println("saving highest completed level \(highestCompletedLevelNum)")
    }
    
    @objc func nextButtonMethod(sender : THButton, event : UIEvent)
    {
        currentLevel += 1
        if currentLevel > (kNumLevels + 1) // +1 because of youwin scene
        {
            currentLevel=1
            highestCompletedLevelNum=kNumLevels
        }
        startup(level: currentLevel)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func mapLevelSelected(level: Int)
    {
        //println("The map selected level \(level)")
        scaleOutRemoveView(view: mapView, duration: 0.25, delay: 0.0)
        mapVisible = false
        currentLevel = level
        startup(level: level)
    }
}
