//
//  MrSkunkLevelScene.swift
//  EduFun
//
//  Created by Douglas Voss on 7/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit
import SpriteKit

let kContactAll : UInt32 = 0xffffffff
let kGravity : CGFloat = 9.8

protocol MrSkunkLevelDelegate {
    func levelComplete()
    func willMoveFromView()
    func autoRestartLevel()
    func hintDisappear()
}

class MrSkunkLevelScene: SKScene, SKPhysicsContactDelegate {
    var mrSkunkDelegate : MrSkunkLevelDelegate! = nil
    
    var playableRect: CGRect = CGRectMake(0,0,0,0)
    var lastUpdateTime: NSTimeInterval = 0
    var dt : NSTimeInterval = 0
    
    var restartingMrSkunk : Bool = false
    var hintDisappeared : Bool = false
    var levelCompleted : Bool = false
    
    var beginPoint : CGPoint = CGPointZero
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat =
        (size.height - maxAspectRatioHeight)/2
        playableRect = CGRect(x: 0, y: playableMargin,
            width: size.width, height: size.height-playableMargin*2)
        
        setupNodes(view)
    }
    
    func setupNodes(view: SKView)
    {
        fatalError("Mr Skunk level subclasses should override this")
    }
    
    override func willMoveFromView(view: SKView) {
        
    }
}
