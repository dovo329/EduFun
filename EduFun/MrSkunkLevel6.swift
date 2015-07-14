//
//  MrSkunkLevel6Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkLevel6Scene: MrSkunkLevelScene {
    
    struct PhysicsCategory {
        static let None:       UInt32 = 0b0
        static let Edge:       UInt32 = 0b1
        static let Floor:      UInt32 = 0b10
        static let Rope:       UInt32 = 0b100
        static let GarbageCan: UInt32 = 0b1000
        static let MissSkunk:  UInt32 = 0b10000
        static let Cannon:     UInt32 = 0b100000
        static let Wheel:      UInt32 = 0b1000000
        static let Skunk:      UInt32 = 0b10000000
    }
    
    var lastTouchedPoint : CGPoint = CGPointZero
    let kCannonImpulseStrength : CGFloat = 1100.0
    
    var missSkunkNodeShot : Bool = false
    
    var skunkNode : SKSpriteNode!
    var missSkunkNode : SKSpriteNode!
    var cannonNode : SKSpriteNode!
    var wheelNode : SKSpriteNode!
    var ropeNode : SKSpriteNode!
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
        skunkNode.physicsBody!.collisionBitMask = kContactAll & (~PhysicsCategory.Rope | ~PhysicsCategory.Edge)
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        missSkunkNode = childNodeWithName("missSkunk") as! SKSpriteNode
        missSkunkNode.physicsBody = SKPhysicsBody(circleOfRadius: missSkunkNode.size.width/2)
        missSkunkNode.physicsBody!.categoryBitMask = PhysicsCategory.MissSkunk
        missSkunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        missSkunkNode.physicsBody!.collisionBitMask = kContactAll & ~(PhysicsCategory.Rope | PhysicsCategory.Cannon | PhysicsCategory.Wheel)
        // physics categories arranged in Z order so just use that
        missSkunkNode.zPosition = CGFloat(PhysicsCategory.MissSkunk)
        missSkunkNode.physicsBody!.affectedByGravity = false
        missSkunkNode.physicsBody!.dynamic = false
        
        garbageCanNode = childNodeWithName("garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody = SKPhysicsBody(rectangleOfSize: garbageCanNode.size)
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.physicsBody!.affectedByGravity = false
        garbageCanNode.physicsBody!.dynamic = true
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        wheelNode = childNodeWithName("wheel") as! SKSpriteNode
        wheelNode.physicsBody = SKPhysicsBody(circleOfRadius: wheelNode.size.width/2.0)
        wheelNode.physicsBody!.dynamic = false
        wheelNode.physicsBody!.affectedByGravity = false
        wheelNode.physicsBody!.categoryBitMask = PhysicsCategory.Wheel
        wheelNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        wheelNode.zPosition = CGFloat(PhysicsCategory.Wheel)
        
        cannonNode = childNodeWithName("cannon") as! SKSpriteNode
        cannonNode.physicsBody = SKPhysicsBody(rectangleOfSize:cannonNode.size)
        cannonNode.physicsBody!.dynamic = false
        cannonNode.physicsBody!.affectedByGravity = false
        cannonNode.physicsBody!.categoryBitMask = PhysicsCategory.Cannon
        cannonNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        cannonNode.zPosition = CGFloat(PhysicsCategory.Cannon)
        updateCannonPoint(CGPointMake(playableRect.size.width/2, playableRect.size.height/2))
        
        ropeNode = childNodeWithName("rope") as! SKSpriteNode
        ropeNode.physicsBody = SKPhysicsBody(rectangleOfSize:ropeNode.size)
        ropeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        ropeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        ropeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let skunkRopeJoint = SKPhysicsJointPin.jointWithBodyA(skunkNode.physicsBody, bodyB: ropeNode.physicsBody, anchor: getPointRight(ropeNode))
        physicsWorld.addJoint(skunkRopeJoint)
        
        let edgeRopeJoint = SKPhysicsJointPin.jointWithBodyA(physicsBody, bodyB: ropeNode.physicsBody, anchor: getPointLeft(ropeNode))
        physicsWorld.addJoint(edgeRopeJoint)
        
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
            let orientConstraint = SKConstraint.orientToPoint(lastTouchedPoint, offset: SKRange(lowerLimit: 0.0, upperLimit: 0.0))
            cannonNode.constraints = [orientConstraint]
            return
        }
        
        if (targetNode.physicsBody!.categoryBitMask != PhysicsCategory.Cannon && targetNode.physicsBody!.categoryBitMask != PhysicsCategory.Wheel)
        {
            lastTouchedPoint = location
            let orientConstraint = SKConstraint.orientToPoint(lastTouchedPoint, offset: SKRange(lowerLimit: 0.0, upperLimit: 0.0))
            cannonNode.constraints = [orientConstraint]
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
    
    func updateCannonPoint(location: CGPoint)
    {
        lastTouchedPoint = location
            let orientConstraint = SKConstraint.orientToPoint(lastTouchedPoint, offset: SKRange(lowerLimit: 0.0, upperLimit: 0.0))
        cannonNode.constraints = [orientConstraint]
        //println("location=\(location)")
    }
    
    func sceneTouched(location: CGPoint)
    {
        //enumerateBodiesInRect(usingBlock:)
        let targetNode = self.nodeAtPoint(location)
        
        if (targetNode.physicsBody == nil)
        {
            updateCannonPoint(location)
            return
        }
        
        if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Rope) {
            updateCannonPoint(location)
            targetNode.removeFromParent()
        }
        
        if !missSkunkNodeShot && (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Cannon || targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Wheel)
        {
            missSkunkNodeShot = true
            missSkunkNode.physicsBody!.affectedByGravity = true
            missSkunkNode.physicsBody!.dynamic = true
            missSkunkNode.physicsBody!.applyAngularImpulse(0.5)
            
            var skunkVector = lastTouchedPoint - missSkunkNode.position
            skunkVector /= skunkVector.length()
            skunkVector *= kCannonImpulseStrength
            missSkunkNode.physicsBody!.applyImpulse(CGVector(dx:skunkVector.x, dy:skunkVector.y))
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
