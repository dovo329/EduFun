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
    
    var lastTouchedPoint : CGPoint = CGPoint.zero
    let kCannonImpulseStrength : CGFloat = 1100.0
    
    var missSkunkNodeShot : Bool = false
    
    var skunkNode : SKSpriteNode!
    var missSkunkNode : SKSpriteNode!
    var cannonNode : SKSpriteNode!
    var wheelNode : SKSpriteNode!
    var ropeNode : SKSpriteNode!
    var garbageCanNode : SKSpriteNode!
    var floorNodeArr : [SKSpriteNode?]! = []
    
    override func setupNodes(view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -kGravity)
        
        skunkNode = childNode(withName: "skunk") as! SKSpriteNode
        skunkNode.physicsBody = SKPhysicsBody(circleOfRadius: skunkNode.size.width/2)
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.GarbageCan
        skunkNode.physicsBody!.collisionBitMask = kContactAll & ~(PhysicsCategory.Rope | PhysicsCategory.Edge)
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        missSkunkNode = childNode(withName: "missSkunk") as! SKSpriteNode
        missSkunkNode.physicsBody = SKPhysicsBody(circleOfRadius: missSkunkNode.size.width/2)
        missSkunkNode.physicsBody!.categoryBitMask = PhysicsCategory.MissSkunk
        missSkunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        missSkunkNode.physicsBody!.collisionBitMask = kContactAll & ~(PhysicsCategory.Rope | PhysicsCategory.Cannon | PhysicsCategory.Wheel | PhysicsCategory.Edge)
        // physics categories arranged in Z order so just use that
        missSkunkNode.zPosition = CGFloat(PhysicsCategory.MissSkunk)
        missSkunkNode.physicsBody!.affectedByGravity = false
        missSkunkNode.physicsBody!.isDynamic = false
        
        garbageCanNode = childNode(withName: "garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody = SKPhysicsBody(rectangleOf: garbageCanNode.size)
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.physicsBody!.affectedByGravity = false
        garbageCanNode.physicsBody!.isDynamic = true
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        wheelNode = childNode(withName: "wheel") as! SKSpriteNode
        wheelNode.physicsBody = SKPhysicsBody(circleOfRadius: wheelNode.size.width/2.0)
        wheelNode.physicsBody!.isDynamic = false
        wheelNode.physicsBody!.affectedByGravity = false
        wheelNode.physicsBody!.categoryBitMask = PhysicsCategory.Wheel
        wheelNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        wheelNode.zPosition = CGFloat(PhysicsCategory.Wheel)
        
        cannonNode = childNode(withName: "cannon") as! SKSpriteNode
        cannonNode.physicsBody = SKPhysicsBody(rectangleOf:cannonNode.size)
        cannonNode.physicsBody!.isDynamic = false
        cannonNode.physicsBody!.affectedByGravity = false
        cannonNode.physicsBody!.categoryBitMask = PhysicsCategory.Cannon
        cannonNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        cannonNode.zPosition = CGFloat(PhysicsCategory.Cannon)
        updateCannonPoint(location: CGPoint(x: playableRect.size.width/2, y: playableRect.size.height/2))
        
        ropeNode = childNode(withName: "rope") as! SKSpriteNode
        ropeNode.physicsBody = SKPhysicsBody(rectangleOf:ropeNode.size)
        ropeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        ropeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        ropeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let skunkRopeJoint = SKPhysicsJointPin.joint(withBodyA: skunkNode.physicsBody!, bodyB: ropeNode.physicsBody!, anchor: getPointRight(node: ropeNode))
        physicsWorld.add(skunkRopeJoint)
        
        let edgeRopeJoint = SKPhysicsJointPin.joint(withBodyA: physicsBody!, bodyB: ropeNode.physicsBody!, anchor: getPointLeft(node: ropeNode))
        physicsWorld.add(edgeRopeJoint)
        
        enumerateChildNodes(withName: "floor", using: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.floorNodeArr.append(spriteNode)
            }
        })
        
        for floorNode in floorNodeArr
        {
            if let floorNode = floorNode {
                floorNode.physicsBody = SKPhysicsBody(rectangleOf: floorNode.size)
                floorNode.physicsBody!.categoryBitMask = PhysicsCategory.Floor
                floorNode.physicsBody!.isDynamic = false
                floorNode.physicsBody!.affectedByGravity = false
                floorNode.zPosition = -2 // behind floor image layer
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
            if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Rope)
            {
                self.ropeNode.removeFromParent()
            }
            
            if !missSkunkNodeShot && (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Cannon || targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Wheel)
            {
                missSkunkNodeShot = true
                missSkunkNode.physicsBody!.affectedByGravity = true
                missSkunkNode.physicsBody!.isDynamic = true
                missSkunkNode.physicsBody!.applyAngularImpulse(0.5)
                
                var skunkVector = lastTouchedPoint - missSkunkNode.position
                skunkVector /= skunkVector.length()
                skunkVector *= kCannonImpulseStrength
                missSkunkNode.physicsBody!.applyImpulse(CGVector(dx:skunkVector.x, dy:skunkVector.y))
            }
        }
        else
        {
            updateCannonPoint(location: location)
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        let targetNode = self.atPoint(location)
        
        if targetNode.physicsBody == nil
        {
            lastTouchedPoint = location
            let orientConstraint = SKConstraint.orient(to: lastTouchedPoint, offset: SKRange(lowerLimit: 0.0, upperLimit: 0.0))
            cannonNode.constraints = [orientConstraint]
            return
        }
        
        if (targetNode.physicsBody!.categoryBitMask != PhysicsCategory.Cannon && targetNode.physicsBody!.categoryBitMask != PhysicsCategory.Wheel)
        {
            lastTouchedPoint = location
            let orientConstraint = SKConstraint.orient(to: lastTouchedPoint, offset: SKRange(lowerLimit: 0.0, upperLimit: 0.0))
            cannonNode.constraints = [orientConstraint]
        }
    }
    
    func updateCannonPoint(location: CGPoint)
    {
        lastTouchedPoint = location
        let orientConstraint = SKConstraint.orient(to: lastTouchedPoint, offset: SKRange(lowerLimit: 0.0, upperLimit: 0.0))
        cannonNode.constraints = [orientConstraint]
        //println("location=\(location)")
    }
    
    func sceneTouched(location: CGPoint)
    {
        
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
