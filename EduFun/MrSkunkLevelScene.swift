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
    
    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0
    var dt : NSTimeInterval = 0
    
    var restartingMrSkunk : Bool = false
    var hintDisappeared : Bool = false
    var levelCompleted : Bool = false
    
    var beginPoint : CGPoint = CGPointZero
    
    override func willMoveFromView(view: SKView) {
        
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        
        playableRect = CGRect(x:0, y: playableMargin, width: size.width, height: playableHeight)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        playableRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        super.init(coder: aDecoder)
    }
}
