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
    
    let kContactAllExceptCan : UInt32 = kContactAll & ~PhysicsCategory.GarbageCan
    
    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0
    var dt : NSTimeInterval = 0
    
    var restartingMrSkunk : Bool = false
    var hintDisappeared : Bool = false
    
    var skunkNode : SKSpriteNode!
    var garbageCanNode : SKSpriteNode!
    var backgroundNodeArr : [SKSpriteNode!]! = []
    var ropeNode : SKSpriteNode!
    var woodNode : SKSpriteNode!
    
    var woodRopeJoint : SKPhysicsJoint!
    
    var levelCompleted : Bool = false
    var victoryLabel : SKLabelNode!
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        
        playableRect = CGRect(x:0, y: playableMargin, width: size.width, height: playableHeight)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        playableRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        setupSwipe()
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
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.GarbageCan | PhysicsCategory.Edge
        skunkNode.physicsBody!.collisionBitMask = PhysicsCategory.Background | PhysicsCategory.Wood | PhysicsCategory.GarbageCan
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        garbageCanNode = childNodeWithName("garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        ropeNode = childNodeWithName("rope") as! SKSpriteNode
        ropeNode.physicsBody!.categoryBitMask = PhysicsCategory.Rope
        ropeNode.physicsBody!.collisionBitMask = PhysicsCategory.Background
        ropeNode.zPosition = CGFloat(PhysicsCategory.Rope)
        
        var ropeEdgeAnchorNode = childNodeWithName("ropeEdgeAnchor") as! SKSpriteNode
        
        woodNode = childNodeWithName("wood") as! SKSpriteNode
        woodNode.physicsBody!.categoryBitMask = PhysicsCategory.Wood
        woodNode.physicsBody!.collisionBitMask = kContactAll & ~(PhysicsCategory.GarbageCan | PhysicsCategory.Rope)
        woodNode.zPosition = CGFloat(PhysicsCategory.Wood)
        
        woodRopeJoint = SKPhysicsJointPin.jointWithBodyA(woodNode.physicsBody, bodyB: ropeNode.physicsBody, anchor: getPointTop(woodNode))
        physicsWorld.addJoint(woodRopeJoint)
        
        var woodEdgeAnchorNode = childNodeWithName("woodEdgeAnchor") as! SKSpriteNode
        
        let woodJoint = SKPhysicsJointPin.jointWithBodyA(woodEdgeAnchorNode.physicsBody, bodyB: woodNode.physicsBody, anchor: getPointBottom(woodNode))
        physicsWorld.addJoint(woodJoint)
        
        let ropeScreenJoint = SKPhysicsJointPin.jointWithBodyA(ropeEdgeAnchorNode.physicsBody, bodyB: ropeNode.physicsBody, anchor: getPointLeft(ropeNode))
        physicsWorld.addJoint(ropeScreenJoint)
        
        enumerateChildNodesWithName("background", usingBlock: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.backgroundNodeArr.append(spriteNode)
            }
        })
        
        for backgroundNode in backgroundNodeArr
        {
            //backgroundNode.physicsBody?.friction = 0.5
            backgroundNode.physicsBody!.categoryBitMask = PhysicsCategory.Background
            backgroundNode.zPosition = -2 // behind background image layer
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
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch = touches.first as! UITouch
        let endPoint : CGPoint = touch.locationInNode(self)
        
        /*if let body : SKPhysicsBody = physicsWorld.bodyAlongRayStart(beginPoint, end: endPoint)
        {
            println("found swipe body \(body)")
        }*/
        physicsWorld.enumerateBodiesAlongRayStart(beginPoint, end:endPoint, usingBlock:
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
        beginPoint = location
        //enumerateBodiesInRect(usingBlock:)
        let targetNode = self.nodeAtPoint(location)
        
        if targetNode.physicsBody == nil
        {
            return
        }
        
        if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Rope) {
            self.physicsWorld.removeJoint(woodRopeJoint)
            self.ropeNode.removeFromParent()
        }
        
        //if targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Wood
        //{
        //    targetNode.removeFromParent()
        //    return
        //}
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
