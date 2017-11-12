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
    
    var lastTouchedPoint : CGPoint = CGPoint.zero
    
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
        //skunkNode.physicsBody!.collisionBitMask = kContactAll & (~PhysicsCategory.Rope | ~PhysicsCategory.Edge)
        skunkNode.physicsBody!.collisionBitMask = kContactAll & (~PhysicsCategory.Rope & ~PhysicsCategory.Edge)
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        plankNode = childNode(withName: "plank") as! SKSpriteNode
        plankNode.physicsBody = SKPhysicsBody(rectangleOf: plankNode.size)
        plankNode.physicsBody!.categoryBitMask = PhysicsCategory.Plank
        plankNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        plankNode.physicsBody!.affectedByGravity = true
        plankNode.physicsBody!.isDynamic = true
        plankNode.zPosition = CGFloat(PhysicsCategory.Plank)
        
        orbNode = childNode(withName: "orb") as! SKSpriteNode
        orbNode.physicsBody = SKPhysicsBody(rectangleOf: orbNode.size)
        orbNode.physicsBody!.categoryBitMask = PhysicsCategory.Orb
        orbNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        orbNode.physicsBody!.affectedByGravity = false
        orbNode.physicsBody!.isDynamic = false
        orbNode.zPosition = CGFloat(PhysicsCategory.Orb)
        
        let orbPlankJoint = SKPhysicsJointPin.joint(withBodyA: orbNode.physicsBody!, bodyB: plankNode.physicsBody!, anchor: orbNode.position)
        physicsWorld.add(orbPlankJoint)
        
        wedgeNode = childNode(withName: "wedge") as! SKSpriteNode
        wedgeNode.physicsBody = SKPhysicsBody(circleOfRadius: wedgeNode.size.width/3.0)
        wedgeNode.physicsBody!.categoryBitMask = PhysicsCategory.Wedge
        wedgeNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        wedgeNode.physicsBody!.affectedByGravity = false
        wedgeNode.physicsBody!.isDynamic = false
        wedgeNode.zPosition = CGFloat(PhysicsCategory.Wedge)
        
        drawbridgeNode = childNode(withName: "drawbridge") as! SKSpriteNode
        drawbridgeNode.physicsBody = SKPhysicsBody(rectangleOf: drawbridgeNode.size)
        drawbridgeNode.physicsBody!.categoryBitMask = PhysicsCategory.Drawbridge
        drawbridgeNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        drawbridgeNode.physicsBody!.collisionBitMask = kContactAll & (~PhysicsCategory.Rope & ~PhysicsCategory.Edge)
        drawbridgeNode.physicsBody!.affectedByGravity = true
        drawbridgeNode.physicsBody!.isDynamic = true
        drawbridgeNode.zPosition = CGFloat(PhysicsCategory.Drawbridge)
        
        let drawbridgeJoint = SKPhysicsJointPin.joint(withBodyA: drawbridgeNode.physicsBody!, bodyB: physicsBody!, anchor: getPointRight(node: drawbridgeNode))
        physicsWorld.addJoint(drawbridgeJoint)
        
        garbageCanNode = childNode(withName: "garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody = SKPhysicsBody(rectangleOf: garbageCanNode.size)
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.physicsBody!.affectedByGravity = true
        garbageCanNode.physicsBody!.isDynamic = true
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        smallWeightRopeNode = childNode(withName: "smallWeightRope") as! SKSpriteNode
        smallWeightRopeNode.physicsBody = SKPhysicsBody(rectangleOf:smallWeightRopeNode.size)
        smallWeightRopeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        smallWeightRopeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        smallWeightRopeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        smallWeightNode = childNode(withName: "smallWeight") as! SKSpriteNode
        smallWeightNode.physicsBody = SKPhysicsBody(rectangleOf:smallWeightNode.size)
        smallWeightNode.physicsBody!.categoryBitMask = PhysicsCategory.Weight
        // physics categories arranged in Z order so just use that
        smallWeightNode.zPosition = CGFloat(PhysicsCategory.Weight)
        
        let smallWeightRopeJoint = SKPhysicsJointPin.joint(withBodyA: smallWeightRopeNode.physicsBody!, bodyB: smallWeightNode.physicsBody!, anchor: getPointRight(node: smallWeightRopeNode))
        physicsWorld.add(smallWeightRopeJoint)
        
        let plankSmallRopeJoint = SKPhysicsJointPin.joint(withBodyA: smallWeightRopeNode.physicsBody!, bodyB: plankNode.physicsBody!, anchor: getPointLeft(node: smallWeightRopeNode))
        physicsWorld.add(plankSmallRopeJoint)
        
        heavyWeightRopeNode = childNode(withName: "heavyWeightRope") as! SKSpriteNode
        heavyWeightRopeNode.physicsBody = SKPhysicsBody(rectangleOf:heavyWeightRopeNode.size)
        heavyWeightRopeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        heavyWeightRopeNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        heavyWeightRopeNode.zPosition = CGFloat(PhysicsCategory.Weight)
        
        heavyWeightNode = childNode(withName: "heavyWeight") as! SKSpriteNode
        heavyWeightNode.physicsBody = SKPhysicsBody(rectangleOf:heavyWeightNode.size)
        heavyWeightNode.physicsBody!.categoryBitMask = PhysicsCategory.Weight
        // physics categories arranged in Z order so just use that
        heavyWeightNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        let heavyWeightRopeJoint = SKPhysicsJointPin.joint(withBodyA: heavyWeightRopeNode.physicsBody!, bodyB: heavyWeightNode.physicsBody!, anchor: getPointRight(node: heavyWeightRopeNode))
        physicsWorld.add(heavyWeightRopeJoint)
        
        let plankHeavyRopeJoint = SKPhysicsJointPin.joint(withBodyA: heavyWeightRopeNode.physicsBody!, bodyB: plankNode.physicsBody!, anchor: getPointLeft(node: heavyWeightRopeNode))
        physicsWorld.add(plankHeavyRopeJoint)
        
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        let targetNode = self.atPoint(location)
        
        if targetNode.physicsBody == nil
        {
            lastTouchedPoint = location
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        
        beginPoint = location
        let targetNode = self.AtPoint(location)
        
        if targetNode.physicsBody != nil
        {
            if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Rope || targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Wedge) {
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
                    if body.categoryBitMask == PhysicsCategory.Rope || body.categoryBitMask == PhysicsCategory.Wedge
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
    }
    
    /*override func didSimulatePhysics() { if let body = catNode.physicsBody {
    if body.contactTestBitMask != PhysicsCategory.None && fabs(catNode.zRotation) > CGFloat(45).degreesToRadians() { lose()
    } }
    }*/
}
