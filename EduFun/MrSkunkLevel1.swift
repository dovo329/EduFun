//
//  MrSkunkLevel1Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkLevel1Scene: MrSkunkLevelScene {
    
    struct PhysicsCategory {
        static let None:       UInt32 = 0b0
        static let Edge:       UInt32 = 0b1
        static let Background: UInt32 = 0b10
        static let Rope:       UInt32 = 0b100
        static let Wood:       UInt32 = 0b1000
        static let GarbageCan: UInt32 = 0b10000
        static let Skunk:      UInt32 = 0b100000
    }
    
    var skunkNode : SKSpriteNode!
    var garbageCanNode : SKSpriteNode!
    var backgroundNodeArr : [SKSpriteNode?]! = []
    var ropeNode : SKSpriteNode!
    var woodNode : SKSpriteNode!
    var woodRopeJoint : SKPhysicsJoint!
    
    override func setupNodes(view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -kGravity)
        
        skunkNode = childNode(withName: "skunk") as! SKSpriteNode
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.GarbageCan | PhysicsCategory.Edge
        skunkNode.physicsBody!.collisionBitMask = PhysicsCategory.Background | PhysicsCategory.Wood | PhysicsCategory.GarbageCan
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        garbageCanNode = childNode(withName: "garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        ropeNode = childNode(withName: "rope") as! SKSpriteNode
        ropeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        ropeNode.physicsBody!.collisionBitMask = PhysicsCategory.Background
        ropeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let ropeEdgeAnchorNode = childNode(withName: "ropeEdgeAnchor") as! SKSpriteNode
        
        woodNode = childNode(withName: "wood") as! SKSpriteNode
        woodNode.physicsBody!.categoryBitMask = PhysicsCategory.Wood
        woodNode.physicsBody!.collisionBitMask = kContactAll & ~(PhysicsCategory.GarbageCan | PhysicsCategory.Rope)
        woodNode.zPosition = CGFloat(PhysicsCategory.Wood)
        
        woodRopeJoint = SKPhysicsJointPin.joint(withBodyA: woodNode.physicsBody!, bodyB: ropeNode.physicsBody!, anchor: getPointTop(node: woodNode))
        physicsWorld.add(woodRopeJoint)
        
        let woodEdgeAnchorNode = childNode(withName: "woodEdgeAnchor") as! SKSpriteNode
        
        let woodJoint = SKPhysicsJointPin.joint(withBodyA: woodEdgeAnchorNode.physicsBody!, bodyB: woodNode.physicsBody!, anchor: getPointBottom(node: woodNode))
        physicsWorld.add(woodJoint)
        
        let ropeScreenJoint = SKPhysicsJointPin.joint(withBodyA: ropeEdgeAnchorNode.physicsBody!, bodyB: ropeNode.physicsBody!, anchor: getPointLeft(node: ropeNode))
        physicsWorld.add(ropeScreenJoint)
        
        enumerateChildNodes(withName: "background", using: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.backgroundNodeArr.append(spriteNode)
            }
        })
        
        for backgroundNode in backgroundNodeArr
        {
            if let backgroundNode = backgroundNode {
                //backgroundNode.physicsBody?.friction = 0.5
                backgroundNode.physicsBody!.categoryBitMask = PhysicsCategory.Background
                backgroundNode.zPosition = -2 // behind background image layer
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
        //println("\(dt*1000) milliseconds since the last update")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        
        beginPoint = location
        //enumerateBodiesInRect(usingBlock:)
        let targetNode = self.atPoint(location)
            
        if targetNode.physicsBody != nil
        {
            if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Rope) {
                self.physicsWorld.remove(woodRopeJoint)
                self.ropeNode.removeFromParent()
            }
        }
        
        if !hintDisappeared
        {
            mrSkunkDelegate.hintDisappear()
            hintDisappeared = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch: UITouch = touches.first!
        let endPoint : CGPoint = touch.location(in: self)
        
        /*if let body : SKPhysicsBody = physicsWorld.bodyAlongRayStart(beginPoint, end: endPoint)
        {
            println("found swipe body \(body)")
        }*/
        physicsWorld.enumerateBodies(alongRayStart: beginPoint, end:endPoint, using:
            { (body, point, normalVector, stop) -> Void in
                if let spriteNode = body.node as? SKSpriteNode
                {
                    //println("spriteNode: \(spriteNode)")
                    if body.categoryBitMask == PhysicsCategory.Rope
                    {
                        spriteNode.removeFromParent()
                    }
                }
            }
        )
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Skunk | PhysicsCategory.GarbageCan
        {
            if !levelCompleted
            {
                mrSkunkDelegate.levelComplete()
                
                //println("You got the foods!")
            }
            levelCompleted = true
        }
        else
        {
            //println("collision is some other collision")
        }
        
        let skunkOffLeftScreen = skunkNode.position.x + (skunkNode.size.width/2.0) < 0
        
        let skunkOffRightScreen = skunkNode.position.x - (skunkNode.size.width/2.0) >= size.width
        
        let skunkOffBottomScreen = skunkNode.position.y - (skunkNode.size.height/2.0) < 0
        
        let skunkOffTopScreen = skunkNode.position.y + (skunkNode.size.height/2.0) >= size.height
        
        if !restartingMrSkunk &&
        (skunkOffLeftScreen || skunkOffRightScreen || skunkOffBottomScreen || skunkOffTopScreen)
        {
            restartingMrSkunk = true
            mrSkunkDelegate.autoRestartLevel()
        }
    }
}
