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
    
    var playableRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var lastUpdateTime: TimeInterval = 0
    var dt : TimeInterval = 0
    
    var restartingMrSkunk : Bool = false
    var hintDisappeared : Bool = false
    var levelCompleted : Bool = false
    
    var beginPoint : CGPoint = CGPoint.zero
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat =
        (size.height - maxAspectRatioHeight)/2
        playableRect = CGRect(x: 0, y: playableMargin,
            width: size.width, height: size.height-playableMargin*2)
        
        restartingMrSkunk = false
        hintDisappeared = false
        levelCompleted = false
        
        setupNodes(view: view)
    }
    
    func setupNodes(view: SKView)
    {
        fatalError("Mr Skunk level subclasses should override this")
    }
    
    override func willMove(from view: SKView) {

        mrSkunkDelegate.willMoveFromView()
    }
}
