//
//  KnockBlocksScene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class KnockBlocksScene: SKScene, SKPhysicsContactDelegate {
    struct PhysicsCategory {
        static let None:        UInt32 = 0b0
        static let Wood:        UInt32 = 0b1
        static let StoneBall:   UInt32 = 0b10
        static let Rope:        UInt32 = 0b100
        static let Edge:        UInt32 = 0b1000
    }

    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0
    var dt : NSTimeInterval = 0
    
    var woodNodeArr : [SKSpriteNode]! = [SKSpriteNode]()
    var stoneBallNode : SKSpriteNode!
    var ropeNode : SKSpriteNode!    
    
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
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat =
        (size.height - maxAspectRatioHeight)/2
        let playableRect = CGRect(x: 0, y: playableMargin,
            width: size.width, height: size.height-playableMargin*2)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        //physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVectorMake(0.0, -2.0)
        
        ropeNode = childNodeWithName("rope") as! SKSpriteNode
        stoneBallNode = childNodeWithName("stoneBall") as! SKSpriteNode
        stoneBallNode.physicsBody!.density = 2.0
        //ropeNode.physicsBody!.applyAngularImpulse(30.0)
        delay(seconds: 2.0) {
            self.stoneBallNode.physicsBody!.applyAngularImpulse(1)
            self.stoneBallNode.physicsBody!.applyImpulse(CGVector(dx:500.0, dy:250.0))
        }
        
        
        delay(seconds: 2.0) {
            self.enumerateChildNodesWithName("wood", usingBlock: {
                node, _ -> Void in
                //NSLog("node=%@", node)
                node.physicsBody!.applyImpulse(CGVector(dx:0.0, dy:-300.0))
                node.physicsBody!.categoryBitMask = PhysicsCategory.Wood
            })
        }
        
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
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch = touches.first as! UITouch
        sceneTouched(touch.locationInNode(self))
    }
    
    func sceneTouched(location: CGPoint)
    {
        let targetNode = self.nodeAtPoint(location)
        
        if targetNode.physicsBody == nil
        {
            return
        }

        if targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Wood
        {
            targetNode.removeFromParent()
            return
        }
    }
}
