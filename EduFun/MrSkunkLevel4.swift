//
//  MrSkunkLevel1Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkLevel4Scene: MrSkunkLevelScene {
    
    struct PhysicsCategory {
        static let None:       UInt32 = 0b0
        static let Edge:       UInt32 = 0b1
        static let Floor:      UInt32 = 0b10
        static let Grass:      UInt32 = 0b100
        static let Rope:       UInt32 = 0b1000
        static let Plank:      UInt32 = 0b10000
        static let Orb:        UInt32 = 0b100000
        static let GarbageCan: UInt32 = 0b1000000
        static let Weight:     UInt32 = 0b10000000
        static let Skunk:      UInt32 = 0b100000000
    }
    
    var skunkNode : SKSpriteNode!
    var garbageCanNode : SKSpriteNode!
    var floorNodeArr : [SKSpriteNode?]! = []
    var grassFloorNodeArr : [SKSpriteNode?]! = []
    var skunkRopeNode : SKSpriteNode!
    var weightRopeNode : SKSpriteNode!
    var plankNode : SKSpriteNode!
    var orbNode : SKSpriteNode!
    var weightNode : SKSpriteNode!
    
    override func setupNodes(view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -kGravity)
        
        skunkNode = childNode(withName: "skunk") as! SKSpriteNode
        skunkNode.physicsBody = SKPhysicsBody(circleOfRadius: skunkNode.size.width/2)
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.GarbageCan
        skunkNode.physicsBody!.collisionBitMask = kContactAll & ~(PhysicsCategory.Rope | PhysicsCategory.Edge)
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        garbageCanNode = childNode(withName: "garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody = SKPhysicsBody(rectangleOf: garbageCanNode.size)
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        plankNode = childNode(withName: "plank") as! SKSpriteNode
        plankNode.physicsBody = SKPhysicsBody(rectangleOf: plankNode.size)
        plankNode.physicsBody!.categoryBitMask = PhysicsCategory.Plank
        plankNode.physicsBody!.collisionBitMask = kContactAll
        plankNode.zPosition = CGFloat(PhysicsCategory.Plank)
        
        orbNode = childNode(withName: "orb") as! SKSpriteNode
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width/2.0)
        orbNode.physicsBody!.categoryBitMask = PhysicsCategory.Orb
        orbNode.physicsBody!.collisionBitMask = kContactAll
        orbNode.zPosition = CGFloat(PhysicsCategory.Orb)
        orbNode.physicsBody!.affectedByGravity = false
        orbNode.physicsBody!.isDynamic = false
        
        let orbPlankJoint = SKPhysicsJointPin.joint(withBodyA: orbNode.physicsBody!, bodyB: plankNode.physicsBody!, anchor: orbNode.position)
        physicsWorld.add(orbPlankJoint)
        
        skunkRopeNode = childNode(withName: "skunkRope") as! SKSpriteNode
        skunkRopeNode.physicsBody = SKPhysicsBody(rectangleOf: skunkRopeNode.size)
        skunkRopeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        skunkRopeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        skunkRopeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let skunkRopeJoint = SKPhysicsJointPin.joint(withBodyA: skunkNode.physicsBody!, bodyB: skunkRopeNode.physicsBody!, anchor: getPointRight(node: skunkRopeNode))
        physicsWorld.add(skunkRopeJoint)
        
        let skunkRopeEdgeJoint = SKPhysicsJointPin.joint(withBodyA: physicsBody!, bodyB: skunkRopeNode.physicsBody!, anchor: getPointLeft(node: skunkRopeNode))
        physicsWorld.add(skunkRopeEdgeJoint)
        
        weightNode = childNode(withName: "weight") as! SKSpriteNode
        weightNode.physicsBody = SKPhysicsBody(rectangleOf: weightNode.size)
        weightNode.physicsBody!.categoryBitMask = PhysicsCategory.Weight
        weightNode.physicsBody!.collisionBitMask = kContactAll
        weightNode.physicsBody!.density = 4.0
        weightNode.zPosition = CGFloat(PhysicsCategory.Weight)
        
        weightRopeNode = childNode(withName: "weightRope") as! SKSpriteNode
        weightRopeNode.physicsBody = SKPhysicsBody(rectangleOf: weightRopeNode.size)
        weightRopeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        weightRopeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        weightRopeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let weightRopeJoint = SKPhysicsJointPin.joint(withBodyA: weightNode.physicsBody!, bodyB: weightRopeNode.physicsBody!, anchor: getPointRight(node: weightRopeNode))
        physicsWorld.add(weightRopeJoint)
        
        let weightRopeEdgeJoint = SKPhysicsJointPin.joint(withBodyA: physicsBody!, bodyB: weightRopeNode.physicsBody!, anchor: getPointLeft(node: weightRopeNode))
        physicsWorld.add(weightRopeEdgeJoint)
        
        enumerateChildNodes(withName: "floor", using: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.floorNodeArr.append(spriteNode)
            }
        })
        
        for floorNode in floorNodeArr
        {
            if let floorNode = floorNode {
                //floorNode.physicsBody?.friction = 0.5
                floorNode.physicsBody = SKPhysicsBody(rectangleOf: floorNode.size)
                floorNode.physicsBody!.categoryBitMask = PhysicsCategory.Floor
                floorNode.physicsBody!.isDynamic = false
                floorNode.physicsBody!.affectedByGravity = false
                floorNode.zPosition = -2 // behind floor image layer
            }
        }
        
        enumerateChildNodes(withName: "grassFloor", using: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.grassFloorNodeArr.append(spriteNode)
            }
        })
        
        for grassFloorNode in grassFloorNodeArr
        {
            if let grassFloorNode = grassFloorNode {
                //grassFloorNode.physicsBody?.friction = 0.5
                grassFloorNode.physicsBody = SKPhysicsBody(rectangleOf: grassFloorNode.size)
                grassFloorNode.physicsBody!.categoryBitMask = PhysicsCategory.Floor
                grassFloorNode.physicsBody!.isDynamic = false
                grassFloorNode.physicsBody!.affectedByGravity = false
                grassFloorNode.zPosition = -2 // behind floor image layer
                grassFloorNode.physicsBody!.friction = 0.5 // more friction for grass
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
        //ropeNode.physicsBody!.applyTorque(0.1)
        //stoneBallNode.physicsBody!.applyTorque(-0.1)
        //println("\(dt*1000) milliseconds since the last update")
        let skunkOffLeftScreen = skunkNode.position.x + (skunkNode.size.width/2.0) < 0
        
        let skunkOffRightScreen = skunkNode.position.x - (skunkNode.size.width/2.0) >= size.width
        
        let skunkOffBottomScreen = skunkNode.position.y - (skunkNode.size.height/2.0) < 0
        
        //let skunkOffTopScreen = skunkNode.position.y + (skunkNode.size.height/2.0) >= size.height
        
        if !restartingMrSkunk &&
            (skunkOffLeftScreen || skunkOffRightScreen || skunkOffBottomScreen)
        {
            restartingMrSkunk = true
            mrSkunkDelegate.autoRestartLevel()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        
        beginPoint = location
        let targetNode = self.atPoint(location)
        
        if targetNode.physicsBody != nil
        {
            if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Rope) {
                targetNode.removeFromParent()
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
    
    func didBegin(_ contact: SKPhysicsContact) {

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
    }
}
