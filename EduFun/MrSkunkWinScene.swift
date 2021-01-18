//
//  MrSkunkLevel1Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkWinScene: MrSkunkLevelScene {
    
    struct PhysicsCategory {
        static let None:       UInt32 = 0b0
        static let Edge:       UInt32 = 0b1
        static let Floor:      UInt32 = 0b10
        static let YouWin:     UInt32 = 0b100
        static let Skunk:      UInt32 = 0b1000
    }
    
    var skunkNode : SKSpriteNode!
    var youwinNode : SKSpriteNode!
    var floorNodeArr : [SKSpriteNode?]! = []
    
    override func setupNodes(view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -kGravity)
        
        skunkNode = childNode(withName: "skunk") as! SKSpriteNode
        skunkNode.physicsBody = SKPhysicsBody(circleOfRadius: skunkNode.size.width/2)
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.collisionBitMask = kContactAll
        // physics categories arranged in Z order so just use that
        skunkNode.physicsBody!.restitution = 1.0
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        skunkNode.physicsBody!.applyAngularImpulse(CGFloat(arc4random_uniform(500)))
        
        youwinNode = childNode(withName: "youwin") as! SKSpriteNode
        youwinNode.physicsBody = SKPhysicsBody(rectangleOf:youwinNode.size)
        youwinNode.physicsBody!.categoryBitMask = PhysicsCategory.YouWin
        youwinNode.physicsBody!.collisionBitMask = kContactAll
        // physics categories arranged in Z order so just use that
        youwinNode.zPosition = CGFloat(PhysicsCategory.YouWin)
        youwinNode.physicsBody!.restitution = 1.0
        youwinNode.physicsBody!.applyAngularImpulse(CGFloat(arc4random_uniform(500)))
        
        enumerateChildNodes(withName: "floor", using: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.floorNodeArr.append(spriteNode)
            }
        })
        
        for floorNodeOpt in floorNodeArr
        {
            if let floorNode = floorNodeOpt {
                floorNode.physicsBody = SKPhysicsBody(rectangleOf: floorNode.size)
                floorNode.physicsBody!.categoryBitMask = PhysicsCategory.Floor
                floorNode.physicsBody!.isDynamic = false
                floorNode.physicsBody!.affectedByGravity = false
                floorNode.zPosition = -2 // behind floor image layer
                floorNode.physicsBody!.restitution = 1.0
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if lastUpdateTime > 0
        {
            dt = currentTime - lastUpdateTime
        }
        else
        {
            dt = 0
        }
        lastUpdateTime = currentTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        sceneTouched(location: touch.location(in: self))
    }
    
    func sceneTouched(location: CGPoint)
    {
        //let targetNode = self.atPoint(location)
        
        mrSkunkDelegate.levelComplete()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
}
