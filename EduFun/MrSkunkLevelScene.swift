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

protocol MrSkunkLevelDelegate {
    func levelComplete()
    func willMoveFromView()
}

class MrSkunkLevelScene: SKScene, SKPhysicsContactDelegate {
    var mrSkunkDelegate : MrSkunkLevelDelegate! = nil
    
    override func willMoveFromView(view: SKView) {
        mrSkunkDelegate.willMoveFromView()
    }
}
