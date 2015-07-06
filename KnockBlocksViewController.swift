//
//  KnockBlocksViewController.swift
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
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! KnockBlocksScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class KnockBlocksViewController: UIViewController {
    
    //var exitButton : THButton!
    var toolbar = UIToolbar()
    let kToolbarHeight = CGFloat(30.0)
    var exitBarButton : UIBarButtonItem!
    var mapButton : UIBarButtonItem!
    var restartBarButton : UIBarButtonItem!
    var flexibleSpace : UIBarButtonItem!
    
    init(_ coder: NSCoder? = nil) {
        if let coder = coder {
            super.init(coder: coder)
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    required convenience init(coder: NSCoder) {
        self.init(coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startup()
    }
    
    func startup()
    {
        if let scene = KnockBlocksScene.unarchiveFromFile("MrSkunkLevel1") as? KnockBlocksScene
        {
            // Configure the view.
            //let skView = self.view as! SKView
            var view : SKView = SKView(frame: UIScreen.mainScreen().applicationFrame)
            self.view = view
            let skView = self.view as! SKView
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            let maxAspectRatio: CGFloat = 16.0/9.0
            // know we are coming from title screen which is always portrait to this screen which is always landscape but it hasn't autorotated yet but that's why height and width are swapped below
            let playableHeight = skView.frame.size.height / maxAspectRatio
            let playableMargin = (skView.frame.size.width - playableHeight)/2.0
            var playableRect = CGRect(x:0, y: playableMargin, width: skView.frame.size.width, height: playableHeight)
            
            //exitButton = THButton(frame: CGRectMake(playableRect.origin.x, playableRect.origin.y, 80.0, 40.0), text:"Exit")
            //exitButton!.addTarget(self, action: Selector("exitButtonMethod:event:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            exitBarButton = UIBarButtonItem(title: "Exit", style: UIBarButtonItemStyle.Plain, target: self, action: "exitButtonMethod")
            
            //UIImage *cameraImg = [UIImage imageNamed:@"Camera"];
            //cameraImg = [cameraImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            var restartImg = UIImage(named: "Restart")
            restartImg = restartImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            restartBarButton = UIBarButtonItem(image: restartImg, style: UIBarButtonItemStyle.Plain, target: self, action: "restartMethod")
            
            var mapImg = UIImage(named: "SkunkMap")
            mapImg = mapImg?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            mapButton = UIBarButtonItem(image: mapImg, style: UIBarButtonItemStyle.Plain, target: self, action: "mapMethod")
            
            /*
            UIImage *previousArrowImg = [UIImage imageNamed:@"Previous"];
            previousArrowImg = [previousArrowImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIBarButtonItem *previousArrowButton = [[UIBarButtonItem alloc] initWithImage:previousArrowImg style:UIBarButtonItemStylePlain target:self action:@selector(previousArrowMethod)];
            
            UIImage *nextArrowImg = [UIImage imageNamed:@"Next"];
            nextArrowImg = [nextArrowImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIBarButtonItem *nextArrowButton = [[UIBarButtonItem alloc] initWithImage:nextArrowImg style:UIBarButtonItemStylePlain target:self action:@selector(nextArrowMethod)];
            */
            
            flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            
            toolbar.frame = CGRectMake(0.0, 0.0, skView.frame.size.width, kToolbarHeight)
            
            toolbar.items = [exitBarButton, flexibleSpace, restartBarButton, flexibleSpace, mapButton]
            //skView.addSubview(exitButton)
            skView.addSubview(toolbar)
            //skView.showsPhysics = true
            skView.presentScene(scene)
            
            /*var view : SKView = SKView(frame: UIScreen.mainScreen().applicationFrame)
            self.view = view
            
            view.backgroundColor = UIColor.magentaColor()
            
            let scene = KnockBlocksScene(size: view.frame.size)
            
            let skView = self.view as! SKView*/
            //skView.showsPhysics = true
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            //skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            
            //skView.presentScene(scene)
        }
    }
    
    /*func exitButtonMethod(sender : THButton, event : UIEvent) {
        var app = UIApplication.sharedApplication().delegate as? AppDelegate
        app?.animateToViewController(ViewControllerEnum.TitleScreen, srcVCEnum: ViewControllerEnum.KnockBlocks)
    }*/
    
    func exitButtonMethod()
    {
        var app = UIApplication.sharedApplication().delegate as? AppDelegate
        app?.animateToViewController(ViewControllerEnum.TitleScreen, srcVCEnum: ViewControllerEnum.KnockBlocks)
    }
    
    func restartMethod()
    {
        startup()
    }
    
    func mapMethod()
    {
        println("Put in Map here")
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
        println("Knock Blocks ViewController deinit")
    }
}
