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
    var floorNodeArr : [SKSpriteNode!]! = []
    
    override func didMoveToView(view: SKView) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat =
        (size.height - maxAspectRatioHeight)/2
        playableRect = CGRect(x: 0, y: playableMargin,
            width: size.width, height: size.height-playableMargin*2)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVectorMake(0.0, -kGravity)
        
        skunkNode = childNodeWithName("skunk") as! SKSpriteNode
        skunkNode.physicsBody = SKPhysicsBody(circleOfRadius: skunkNode.size.width/2)
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.collisionBitMask = kContactAll
        // physics categories arranged in Z order so just use that
        skunkNode.physicsBody!.restitution = 1.0
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        skunkNode.physicsBody!.applyAngularImpulse(CGFloat(arc4random_uniform(500)))
        
        youwinNode = childNodeWithName("youwin") as! SKSpriteNode
        youwinNode.physicsBody = SKPhysicsBody(rectangleOfSize:youwinNode.size)
        youwinNode.physicsBody!.categoryBitMask = PhysicsCategory.YouWin
        youwinNode.physicsBody!.collisionBitMask = kContactAll
        // physics categories arranged in Z order so just use that
        youwinNode.zPosition = CGFloat(PhysicsCategory.YouWin)
        youwinNode.physicsBody!.restitution = 1.0
        youwinNode.physicsBody!.applyAngularImpulse(CGFloat(arc4random_uniform(500)))
        
        enumerateChildNodesWithName("floor", usingBlock: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.floorNodeArr.append(spriteNode)
            }
        })
        
        for floorNode in floorNodeArr
        {
            //floorNode.physicsBody?.friction = 0.5
            floorNode.physicsBody = SKPhysicsBody(rectangleOfSize: floorNode.size)
            floorNode.physicsBody!.categoryBitMask = PhysicsCategory.Floor
            floorNode.physicsBody!.dynamic = false
            floorNode.physicsBody!.affectedByGravity = false
            floorNode.zPosition = -2 // behind floor image layer
            floorNode.physicsBody!.restitution = 1.0
        }
    }
    
    override func update(currentTime: NSTimeInterval)
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
        //ropeNode.physicsBody!.applyTorque(0.1)
        //stoneBallNode.physicsBody!.applyTorque(-0.1)
        //println("\(dt*1000) milliseconds since the last update")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch = touches.first as! UITouch
        sceneTouched(touch.locationInNode(self))
    }
    
    func sceneTouched(location: CGPoint)
    {
        let targetNode = self.nodeAtPoint(location)
        
        mrSkunkDelegate.levelComplete()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
    }
    
    /*override func didSimulatePhysics() { if let body = catNode.physicsBody {
    if body.contactTestBitMask != PhysicsCategory.None && fabs(catNode.zRotation) > CGFloat(45).degreesToRadians() { lose()
    } }
    }*/
}
