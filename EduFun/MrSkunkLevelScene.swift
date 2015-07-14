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
    
    struct PhysicsCategory {
        static let None:       UInt32 = 0b0
        static let Edge:       UInt32 = 0b1
        static let Background: UInt32 = 0b10
        static let Floor:      UInt32 = 0b100
        static let Grass:      UInt32 = 0b1000
        static let Rope:       UInt32 = 0b10000
        static let Wood:       UInt32 = 0b100000
        static let Arrow:      UInt32 = 0b1000000
        static let Plank:      UInt32 = 0b10000000
        static let Drawbridge: UInt32 = 0b100000000
        static let Orb:        UInt32 = 0b1000000000
        static let Cannon:     UInt32 = 0b10000000000
        static let Wheel:      UInt32 = 0b100000000000
        static let GarbageCan: UInt32 = 0b1000000000000
        static let Goal:       UInt32 = 0b10000000000000
        static let Weight:     UInt32 = 0b100000000000000
        static let Wedge:      UInt32 = 0b1000000000000000
        static let YouWin:     UInt32 = 0b10000000000000000
        static let MissSkunk:  UInt32 = 0b100000000000000000
        static let Skunk:      UInt32 = 0b1000000000000000000
    }
    
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
