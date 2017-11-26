//
//  MrSkunkLevel5Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkLevel5Scene: MrSkunkLevelScene {
    
    struct PhysicsCategory {
        static let None:       UInt32 = 0b0
        static let Edge:       UInt32 = 0b1
        static let Floor:      UInt32 = 0b10
        static let GarbageCan: UInt32 = 0b100
        static let Arrow:      UInt32 = 0b1000
        static let Skunk:      UInt32 = 0b10000
    }
    
    var skunkNode : SKSpriteNode!
    var garbageCanNode : SKSpriteNode!
    var floorNodeArr : [SKSpriteNode?]! = []
    var arrowNode : SKSpriteNode!
    var arrowDirectionIsDown : Bool = true
    
    override func setupNodes(view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -kGravity)
        
        skunkNode = childNode(withName: "skunk") as! SKSpriteNode
        skunkNode.physicsBody = SKPhysicsBody(circleOfRadius: skunkNode.size.width/2)
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.GarbageCan
        skunkNode.physicsBody!.collisionBitMask = kContactAll & (~PhysicsCategory.Edge)
        // physics categories arranged in Z order so just use that
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        garbageCanNode = childNode(withName: "garbageCan") as! SKSpriteNode
        garbageCanNode.physicsBody = SKPhysicsBody(rectangleOf: garbageCanNode.size)
        garbageCanNode.physicsBody!.categoryBitMask = PhysicsCategory.GarbageCan
        garbageCanNode.physicsBody!.contactTestBitMask = PhysicsCategory.Skunk
        garbageCanNode.physicsBody!.affectedByGravity = false
        garbageCanNode.physicsBody!.isDynamic = true
        garbageCanNode.zPosition = CGFloat(PhysicsCategory.GarbageCan)
        
        arrowNode = childNode(withName: "arrow") as! SKSpriteNode
        arrowNode.physicsBody = SKPhysicsBody(circleOfRadius: arrowNode.size.width/2)
        arrowNode.physicsBody!.categoryBitMask = PhysicsCategory.Arrow
        arrowNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        arrowNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        arrowNode.physicsBody!.affectedByGravity = false
        arrowNode.physicsBody!.isDynamic = false
        arrowNode.zPosition = CGFloat(PhysicsCategory.Arrow)
        
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
        
        let skunkOffTopScreen = skunkNode.position.y + (skunkNode.size.height/2.0) >= size.height
        
        if !restartingMrSkunk &&
            (skunkOffLeftScreen || skunkOffRightScreen || skunkOffBottomScreen || skunkOffTopScreen)
        {
            restartingMrSkunk = true
            mrSkunkDelegate.autoRestartLevel()
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch: UITouch = touches.first!
        sceneTouched(location: touch.location(in: self))
        
        if !hintDisappeared
        {
            mrSkunkDelegate.hintDisappear()
            hintDisappeared = true
        }
    }
    
    func sceneTouched(location: CGPoint)
    {
        //enumerateBodiesInRect(usingBlock:)
        let targetNode = self.atPoint(location)
        
        if targetNode.physicsBody == nil
        {
            return
        }
        
        if (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Arrow) {
            arrowDirectionIsDown = !arrowDirectionIsDown
            let flipArrowAction : SKAction!
            if arrowDirectionIsDown
            {
                flipArrowAction = SKAction.scale(to: 1.0, duration: 0.5)
                physicsWorld.gravity = CGVector(dx: 0.0, dy: -kGravity)
            }
            else
            {
                flipArrowAction = SKAction.scale(to: -1.0, duration: 0.5)
                physicsWorld.gravity = CGVector(dx: 0.0, dy: kGravity)
            }
            targetNode.run(flipArrowAction)
        }
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
