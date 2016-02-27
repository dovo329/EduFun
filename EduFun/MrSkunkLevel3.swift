//
//  MrSkunkLevel1Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkLevel3Scene: MrSkunkLevelScene {
    
    struct PhysicsCategory {
        static let None:       UInt32 = 0b0
        static let Edge:       UInt32 = 0b1
        static let Floor:      UInt32 = 0b10
        static let Rope:       UInt32 = 0b100
        static let Plank:      UInt32 = 0b1000
        static let Orb:        UInt32 = 0b10000
        static let GarbageCan: UInt32 = 0b100000
        static let Weight:     UInt32 = 0b1000000
        static let Wedge:      UInt32 = 0b10000000
        static let Skunk:      UInt32 = 0b100000000
    }
    
    let kContactAllExceptCan : UInt32 = kContactAll & ~PhysicsCategory.GarbageCan
    
    var skunkNode : SKSpriteNode!
    var garbageCanNode : SKSpriteNode!
    var floorNodeArr : [SKSpriteNode!]! = []
    var ropeNode : SKSpriteNode!
    var plankNode : SKSpriteNode!
    var orbNode : SKSpriteNode!
    var weightNode : SKSpriteNode!
    var wedgeNode : SKSpriteNode!
    
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
        
        ropeNode = childNodeWithName("rope") as! SKSpriteNode
        ropeNode.physicsBody = SKPhysicsBody(rectangleOfSize: ropeNode.size)
        ropeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        ropeNode.physicsBody!.collisionBitMask = PhysicsCategory.Floor
        ropeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
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
        
        weightNode = childNodeWithName("weight") as! SKSpriteNode
        weightNode.physicsBody = SKPhysicsBody(rectangleOfSize: weightNode.size)
        weightNode.physicsBody!.categoryBitMask = PhysicsCategory.Weight
        weightNode.physicsBody!.collisionBitMask = kContactAll
        weightNode.zPosition = CGFloat(PhysicsCategory.Weight)
        
        wedgeNode = childNodeWithName("wedge") as! SKSpriteNode
        wedgeNode.physicsBody = SKPhysicsBody(circleOfRadius: wedgeNode.size.width/3.0)
        wedgeNode.physicsBody!.categoryBitMask = PhysicsCategory.Wedge
        wedgeNode.physicsBody!.collisionBitMask = kContactAll
        wedgeNode.zPosition = CGFloat(PhysicsCategory.Wedge)
        wedgeNode.physicsBody!.affectedByGravity = false
        wedgeNode.physicsBody!.dynamic = false
        
        let orbPlankJoint = SKPhysicsJointPin.jointWithBodyA(orbNode.physicsBody!, bodyB: plankNode.physicsBody!, anchor: orbNode.position)
        physicsWorld.addJoint(orbPlankJoint)
        
        let plankRopeJoint = SKPhysicsJointPin.jointWithBodyA(plankNode.physicsBody!, bodyB: ropeNode.physicsBody!, anchor: getPointRight(ropeNode))
        physicsWorld.addJoint(plankRopeJoint)
        
        let ropeWeightJoint = SKPhysicsJointPin.jointWithBodyA(ropeNode.physicsBody!, bodyB: weightNode.physicsBody!, anchor: getPointLeft(ropeNode))
        physicsWorld.addJoint(ropeWeightJoint)
        
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
        
        /*enumerateChildNodesWithName("wood", usingBlock: { (node, _) -> Void in
        if let spriteNode = node as? SKSpriteNode {
        self.woodNodeArr.append(spriteNode)
        }
        })*/
        
        //ropeNode.physicsBody!.applyAngularImpulse(30.0)
        /*delay(seconds: 2.0) {
        self.stoneBallNode.physicsBody!.applyAngularImpulse(1)
        self.stoneBallNode.physicsBody!.applyImpulse(CGVector(dx:500.0, dy:250.0))
        }
        
        
        delay(seconds: 2.0) {
        
        for node in self.woodNodeArr {
        node.physicsBody!.applyImpulse(CGVector(dx:0.0, dy:-300.0))
        node.physicsBody!.categoryBitMask = PhysicsCategory.Wood
        }
        }*/
        
        /*enumerateChildNodesWithName("wood") {node, _ in
        self.woodNodeArr.append(node)
        }*/
        
        //physicsWorld.gravity = CGVectorMake(0.0, -9.81)
        /*
        woodNode = SKSpriteNode(imageNamed: "WoodBlock")
        woodNode.physicsBody = SKPhysicsBody(rectangleOfSize: woodNode.frame.size)
        woodNode.position = CGPointMake(100, 250)
        woodNode.physicsBody!.categoryBitMask = PhysicsCategory.Wood
        woodNode.physicsBody!.collisionBitMask = PhysicsCategory.Wood | PhysicsCategory.StoneBall | PhysicsCategory.Edge | PhysicsCategory.Rope
        addChild(woodNode)
        woodNode.zRotation = (π/180.0)*33
        
        stoneBallNode = SKSpriteNode(imageNamed: "Stone")
        stoneBallNode.physicsBody = SKPhysicsBody(circleOfRadius: stoneBallNode.frame.size.width/2)
        stoneBallNode.physicsBody!.categoryBitMask = PhysicsCategory.StoneBall
        stoneBallNode.physicsBody!.collisionBitMask = PhysicsCategory.Wood | PhysicsCategory.StoneBall | PhysicsCategory.Edge | PhysicsCategory.Rope
        stoneBallNode.position = CGPointMake(100, 300)
        stoneBallNode.zRotation = 0.0
        stoneBallNode.xScale = 0.05
        stoneBallNode.yScale = 0.05
        addChild(stoneBallNode)
        
        ropeNode = SKSpriteNode(imageNamed: "ropeAlpha")
        var ropeNodeSize : CGSize = ropeNode.frame.size
        //ropeNodeSize.height /= 2
        ropeNode.physicsBody = SKPhysicsBody(rectangleOfSize: ropeNodeSize)
        ropeNode.physicsBody?.restitution = 0.7
        ropeNode.physicsBody!.categoryBitMask = PhysicsCategory.Wood
        ropeNode.physicsBody!.collisionBitMask = PhysicsCategory.Wood | PhysicsCategory.StoneBall | PhysicsCategory.Edge | PhysicsCategory.Rope
        ropeNode.xScale = 0.25
        ropeNode.yScale = 0.25
        ropeNode.position = CGPointMake(100, 200)
        ropeNode.zRotation = (π/180.0)*74
        addChild(ropeNode)
        
        delay(seconds: 4.0,
        completion:
        {(_) -> Void in
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.81)
        }
        )*/
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
        (skunkOffLeftScreen || skunkOffRightScreen || skunkOffBottomScreen || skunkOffTopScreen)
        {
            restartingMrSkunk = true
            mrSkunkDelegate.autoRestartLevel()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first as! UITouch!
        let location = touch.locationInNode(self)
        
        beginPoint = location
        let targetNode = self.nodeAtPoint(location)
        
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first as! UITouch!
        let endPoint : CGPoint = touch.locationInNode(self)
        
        physicsWorld.enumerateBodiesAlongRayStart(beginPoint, end:endPoint, usingBlock:
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
    }
}
