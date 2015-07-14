//
//  MrSkunkLevel1Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkLevel4Scene: MrSkunkLevelScene {
        
    var skunkNode : SKSpriteNode!
    var garbageCanNode : SKSpriteNode!
    var floorNodeArr : [SKSpriteNode!]! = []
    var grassFloorNodeArr : [SKSpriteNode!]! = []
    var skunkRopeNode : SKSpriteNode!
    var weightRopeNode : SKSpriteNode!
    var plankNode : SKSpriteNode!
    var orbNode : SKSpriteNode!
    var weightNode : SKSpriteNode!
    
    override func setupNodes(view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVectorMake(0.0, -kGravity)
        
        skunkNode = childNodeWithName("skunk") as! SKSpriteNode
        skunkNode.physicsBody = SKPhysicsBody(circleOfRadius: skunkNode.size.width/2)
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.GarbageCan
        skunkNode.physicsBody!.collisionBitMask = kContactAll & ~(PhysicsCategory.Rope | PhysicsCategory.Edge)
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        garbageCanNode = childNodeWithName("garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody = SKPhysicsBody(rectangleOfSize: garbageCanNode.size)
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        plankNode = childNodeWithName("plank") as! SKSpriteNode
        plankNode.physicsBody = SKPhysicsBody(rectangleOfSize: plankNode.size)
        plankNode.physicsBody!.categoryBitMask = PhysicsCategory.Plank
        plankNode.physicsBody!.collisionBitMask = kContactAll
        plankNode.zPosition = CGFloat(PhysicsCategory.Plank)
        
        orbNode = childNodeWithName("orb") as! SKSpriteNode
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width/2.0)
        orbNode.physicsBody!.categoryBitMask = PhysicsCategory.Orb
        orbNode.physicsBody!.collisionBitMask = kContactAll
        orbNode.zPosition = CGFloat(PhysicsCategory.Orb)
        orbNode.physicsBody!.affectedByGravity = false
        orbNode.physicsBody!.dynamic = false
        
        let orbPlankJoint = SKPhysicsJointPin.jointWithBodyA(orbNode.physicsBody, bodyB: plankNode.physicsBody, anchor: orbNode.position)
        physicsWorld.addJoint(orbPlankJoint)
        
        skunkRopeNode = childNodeWithName("skunkRope") as! SKSpriteNode
        skunkRopeNode.physicsBody = SKPhysicsBody(rectangleOfSize: skunkRopeNode.size)
        skunkRopeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        skunkRopeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        skunkRopeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let skunkRopeJoint = SKPhysicsJointPin.jointWithBodyA(skunkNode.physicsBody, bodyB: skunkRopeNode.physicsBody, anchor: getPointRight(skunkRopeNode))
        physicsWorld.addJoint(skunkRopeJoint)
        
        let skunkRopeEdgeJoint = SKPhysicsJointPin.jointWithBodyA(physicsBody, bodyB: skunkRopeNode.physicsBody, anchor: getPointLeft(skunkRopeNode))
        physicsWorld.addJoint(skunkRopeEdgeJoint)
        
        weightNode = childNodeWithName("weight") as! SKSpriteNode
        weightNode.physicsBody = SKPhysicsBody(rectangleOfSize: weightNode.size)
        weightNode.physicsBody!.categoryBitMask = PhysicsCategory.Weight
        weightNode.physicsBody!.collisionBitMask = kContactAll
        weightNode.physicsBody!.density = 4.0
        weightNode.zPosition = CGFloat(PhysicsCategory.Weight)
        
        weightRopeNode = childNodeWithName("weightRope") as! SKSpriteNode
        weightRopeNode.physicsBody = SKPhysicsBody(rectangleOfSize: weightRopeNode.size)
        weightRopeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        weightRopeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        weightRopeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let weightRopeJoint = SKPhysicsJointPin.jointWithBodyA(weightNode.physicsBody, bodyB: weightRopeNode.physicsBody, anchor: getPointRight(weightRopeNode))
        physicsWorld.addJoint(weightRopeJoint)
        
        let weightRopeEdgeJoint = SKPhysicsJointPin.jointWithBodyA(physicsBody, bodyB: weightRopeNode.physicsBody, anchor: getPointLeft(weightRopeNode))
        physicsWorld.addJoint(weightRopeEdgeJoint)
        
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
        }
        
        enumerateChildNodesWithName("grassFloor", usingBlock: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.grassFloorNodeArr.append(spriteNode)
            }
        })
        
        for grassFloorNode in grassFloorNodeArr
        {
            //grassFloorNode.physicsBody?.friction = 0.5
            grassFloorNode.physicsBody = SKPhysicsBody(rectangleOfSize: grassFloorNode.size)
            grassFloorNode.physicsBody!.categoryBitMask = PhysicsCategory.Floor
            grassFloorNode.physicsBody!.dynamic = false
            grassFloorNode.physicsBody!.affectedByGravity = false
            grassFloorNode.zPosition = -2 // behind floor image layer
            grassFloorNode.physicsBody!.friction = 0.5 // more friction for grass
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
        let skunkOffLeftScreen = skunkNode.position.x + (skunkNode.size.width/2.0) < 0
        
        let skunkOffRightScreen = skunkNode.position.x - (skunkNode.size.width/2.0) >= size.width
        
        let skunkOffBottomScreen = skunkNode.position.y - (skunkNode.size.height/2.0) < 0
        
        let skunkOffTopScreen = skunkNode.position.y + (skunkNode.size.height/2.0) >= size.height
        
        if !restartingMrSkunk &&
            (skunkOffLeftScreen || skunkOffRightScreen || skunkOffBottomScreen)
        {
            restartingMrSkunk = true
            mrSkunkDelegate.autoRestartLevel()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch = touches.first as! UITouch
        sceneTouched(touch.locationInNode(self))
        
        if !hintDisappeared
        {
            mrSkunkDelegate.hintDisappear()
            hintDisappeared = true
        }
    }
    
    func sceneTouched(location: CGPoint)
    {
        //enumerateBodiesInRect(usingBlock:)
        let targetNode = self.nodeAtPoint(location)
        
        if targetNode.physicsBody == nil
        {
            return
        }
        
        if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Rope) {
            targetNode.removeFromParent()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Skunk | PhysicsCategory.GarbageCan
        {
            if !levelCompleted
            {
                mrSkunkDelegate.levelComplete()
                
                println("You got the foods!")
            }
            levelCompleted = true
        }
        else
        {
            println("collision is some other collision")
        }
    }
    
    /*override func didSimulatePhysics() { if let body = catNode.physicsBody {
    if body.contactTestBitMask != PhysicsCategory.None && fabs(catNode.zRotation) > CGFloat(45).degreesToRadians() { lose()
    } }
    }*/
}
