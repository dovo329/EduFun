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
        
        if let scene = KnockBlocksScene.unarchiveFromFile("KnockBlocksScene") as? KnockBlocksScene {
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
            
            skView.presentScene(scene)
            
            /*var view : SKView = SKView(frame: UIScreen.mainScreen().applicationFrame)
            self.view = view
            
            view.backgroundColor = UIColor.magentaColor()
            
            let scene = KnockBlocksScene(size: view.frame.size)
            
            let skView = self.view as! SKView*/
            skView.showsPhysics = true
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            //skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            
            //skView.presentScene(scene)
        }
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
}


//
//  GameViewController.swift
//  sksTest
//
//  Created by Douglas Voss on 7/1/15.
//  Copyright (c) 2015 test. All rights reserved.
//

/*
import UIKit
import SpriteKit

extension SKNode {
class func unarchiveFromFile(file : String) -> SKNode? {
if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)

archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
archiver.finishDecoding()
return scene
} else {
return nil
}
}
}

class GameViewController: UIViewController {

override func viewDidLoad() {
super.viewDidLoad()

if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
// Configure the view.
let skView = self.view as! SKView
skView.showsFPS = true
skView.showsNodeCount = true

/* Sprite Kit applies additional optimizations to improve rendering performance */
skView.ignoresSiblingOrder = true

/* Set the scale mode to scale to fit the window */
scene.scaleMode = .AspectFill

skView.presentScene(scene)
}
}

override func shouldAutorotate() -> Bool {
return true
}

override func supportedInterfaceOrientations() -> Int {
if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
} else {
return Int(UIInterfaceOrientationMask.All.rawValue)
}
}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
// Release any cached data, images, etc that aren't in use.
}

override func prefersStatusBarHidden() -> Bool {
return true
}
}
*/