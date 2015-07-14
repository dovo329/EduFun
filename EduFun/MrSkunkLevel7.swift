//
//  MrSkunkLevel6Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkLevel7Scene: MrSkunkLevelScene {
    
    struct PhysicsCategory {
        static let None:         UInt32 = 0b0
        static let Edge:         UInt32 = 0b1
        static let Floor:        UInt32 = 0b10
        static let Wedge:        UInt32 = 0b100
        static let Weight:       UInt32 = 0b1000
        static let Rope:         UInt32 = 0b10000
        static let Plank:        UInt32 = 0b100000
        static let Drawbridge:   UInt32 = 0b1000000
        static let Orb:          UInt32 = 0b100000000
        static let GarbageCan:   UInt32 = 0b1000000000
        static let Skunk:        UInt32 = 0b10000000000
    }
    
    var lastTouchedPoint : CGPoint = CGPointZero
    
    var skunkNode : SKSpriteNode!
    var smallWeightRopeNode : SKSpriteNode!
    var heavyWeightRopeNode : SKSpriteNode!
    var smallWeightNode : SKSpriteNode!
    var heavyWeightNode : SKSpriteNode!
    var orbNode : SKSpriteNode!
    var wedgeNode : SKSpriteNode!
    var drawbridgeNode : SKSpriteNode!
    var plankNode : SKSpriteNode!
    var garbageCanNode : SKSpriteNode!
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
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsWorld.gravity = CGVectorMake(0.0, -kGravity)
        
        skunkNode = childNodeWithName("skunk") as! SKSpriteNode
        skunkNode.physicsBody = SKPhysicsBody(circleOfRadius: skunkNode.size.width/2)
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.GarbageCan
        //skunkNode.physicsBody!.collisionBitMask = kContactAll & (~PhysicsCategory.Rope | ~PhysicsCategory.Edge)
        skunkNode.physicsBody!.collisionBitMask = kContactAll & (~PhysicsCategory.Rope & ~PhysicsCategory.Edge)
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        plankNode = childNodeWithName("plank") as! SKSpriteNode
        plankNode.physicsBody = SKPhysicsBody(rectangleOfSize: plankNode.size)
        plankNode.physicsBody!.categoryBitMask = PhysicsCategory.Plank
        plankNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        plankNode.physicsBody!.affectedByGravity = true
        plankNode.physicsBody!.dynamic = true
        plankNode.zPosition = CGFloat(PhysicsCategory.Plank)
        
        orbNode = childNodeWithName("orb") as! SKSpriteNode
        orbNode.physicsBody = SKPhysicsBody(rectangleOfSize: orbNode.size)
        orbNode.physicsBody!.categoryBitMask = PhysicsCategory.Orb
        orbNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        orbNode.physicsBody!.affectedByGravity = false
        orbNode.physicsBody!.dynamic = false
        orbNode.zPosition = CGFloat(PhysicsCategory.Orb)
        
        let orbPlankJoint = SKPhysicsJointPin.jointWithBodyA(orbNode.physicsBody, bodyB: plankNode.physicsBody, anchor: orbNode.position)
        physicsWorld.addJoint(orbPlankJoint)
        
        wedgeNode = childNodeWithName("wedge") as! SKSpriteNode
        wedgeNode.physicsBody = SKPhysicsBody(circleOfRadius: wedgeNode.size.width/3.0)
        wedgeNode.physicsBody!.categoryBitMask = PhysicsCategory.Wedge
        wedgeNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        wedgeNode.physicsBody!.affectedByGravity = false
        wedgeNode.physicsBody!.dynamic = false
        wedgeNode.zPosition = CGFloat(PhysicsCategory.Wedge)
        
        drawbridgeNode = childNodeWithName("drawbridge") as! SKSpriteNode
        drawbridgeNode.physicsBody = SKPhysicsBody(rectangleOfSize: drawbridgeNode.size)
        drawbridgeNode.physicsBody!.categoryBitMask = PhysicsCategory.Drawbridge
        drawbridgeNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        drawbridgeNode.physicsBody!.collisionBitMask = kContactAll & (~PhysicsCategory.Rope & ~PhysicsCategory.Edge)
        drawbridgeNode.physicsBody!.affectedByGravity = true
        drawbridgeNode.physicsBody!.dynamic = true
        drawbridgeNode.zPosition = CGFloat(PhysicsCategory.Drawbridge)
        
        let drawbridgeJoint = SKPhysicsJointPin.jointWithBodyA(drawbridgeNode.physicsBody, bodyB: physicsBody, anchor: getPointRight(drawbridgeNode))
        physicsWorld.addJoint(drawbridgeJoint)
        
        garbageCanNode = childNodeWithName("garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody = SKPhysicsBody(rectangleOfSize: garbageCanNode.size)
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.physicsBody!.affectedByGravity = true
        garbageCanNode.physicsBody!.dynamic = true
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        smallWeightRopeNode = childNodeWithName("smallWeightRope") as! SKSpriteNode
        smallWeightRopeNode.physicsBody = SKPhysicsBody(rectangleOfSize:smallWeightRopeNode.size)
        smallWeightRopeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        smallWeightRopeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        smallWeightRopeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        smallWeightNode = childNodeWithName("smallWeight") as! SKSpriteNode
        smallWeightNode.physicsBody = SKPhysicsBody(rectangleOfSize:smallWeightNode.size)
        smallWeightNode.physicsBody!.categoryBitMask = PhysicsCategory.Weight
        // physics categories arranged in Z order so just use that
        smallWeightNode.zPosition = CGFloat(PhysicsCategory.Weight)
        
        let smallWeightRopeJoint = SKPhysicsJointPin.jointWithBodyA(smallWeightRopeNode.physicsBody, bodyB: smallWeightNode.physicsBody, anchor: getPointRight(smallWeightRopeNode))
        physicsWorld.addJoint(smallWeightRopeJoint)
        
        let plankSmallRopeJoint = SKPhysicsJointPin.jointWithBodyA(smallWeightRopeNode.physicsBody, bodyB: plankNode.physicsBody, anchor: getPointLeft(smallWeightRopeNode))
        physicsWorld.addJoint(plankSmallRopeJoint)
        
        heavyWeightRopeNode = childNodeWithName("heavyWeightRope") as! SKSpriteNode
        heavyWeightRopeNode.physicsBody = SKPhysicsBody(rectangleOfSize:heavyWeightRopeNode.size)
        heavyWeightRopeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        heavyWeightRopeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        heavyWeightRopeNode.zPosition = CGFloat(PhysicsCategory.Weight)
        
        heavyWeightNode = childNodeWithName("heavyWeight") as! SKSpriteNode
        heavyWeightNode.physicsBody = SKPhysicsBody(rectangleOfSize:heavyWeightNode.size)
        heavyWeightNode.physicsBody!.categoryBitMask = PhysicsCategory.Weight
        // physics categories arranged in Z order so just use that
        heavyWeightNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let heavyWeightRopeJoint = SKPhysicsJointPin.jointWithBodyA(heavyWeightRopeNode.physicsBody, bodyB: heavyWeightNode.physicsBody, anchor: getPointRight(heavyWeightRopeNode))
        physicsWorld.addJoint(heavyWeightRopeJoint)
        
        let plankHeavyRopeJoint = SKPhysicsJointPin.jointWithBodyA(heavyWeightRopeNode.physicsBody, bodyB: plankNode.physicsBody, anchor: getPointLeft(heavyWeightRopeNode))
        physicsWorld.addJoint(plankHeavyRopeJoint)
        
        enumerateChildNodesWithName("floor", usingBlock: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.floorNodeArr.append(spriteNode)
            }
        })
        
        for floorNode in floorNodeArr
        {
            floorNode.physicsBody = SKPhysicsBody(rectangleOfSize: floorNode.size)
            floorNode.physicsBody!.categoryBitMask = PhysicsCategory.Floor
            floorNode.physicsBody!.dynamic = false
            floorNode.physicsBody!.affectedByGravity = false
            floorNode.zPosition = -2 // behind floor image layer
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
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let targetNode = self.nodeAtPoint(location)
        
        if targetNode.physicsBody == nil
        {
            lastTouchedPoint = location
            return
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
        
        if (targetNode.physicsBody == nil)
        {
            return
        }
        
        if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Rope ||
            targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Wedge) {
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
                
                //println("You got the foods!")
            }
            levelCompleted = true
        }
        else
        {
            //println("collision is some other collision")
        }
    }
    
    /*override func didSimulatePhysics() { if let body = catNode.physicsBody {
    if body.contactTestBitMask != PhysicsCategory.None && fabs(catNode.zRotation) > CGFloat(45).degreesToRadians() { lose()
    } }
    }*/
}
