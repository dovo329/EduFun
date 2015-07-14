//
//  MrSkunkLevel1Scene.swift
//  EduFun
//
//  Created by Douglas Voss on 6/29/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import SpriteKit

class MrSkunkLevel2Scene: MrSkunkLevelScene {

    struct PhysicsCategory {
        static let None:       UInt32 = 0b0
        static let Edge:       UInt32 = 0b1
        static let Background: UInt32 = 0b10
        static let Skunk:      UInt32 = 0b100
        static let Cannon:     UInt32 = 0b1000
        static let Goal:       UInt32 = 0b10000
        static let Wheel:      UInt32 = 0b100000
    }
    
    var restartingMrSkunk : Bool = false
    var hintDisappeared : Bool = false
    
    let kCannonImpulseStrength : CGFloat = 1100.0
    
    var lastTouchedPoint : CGPoint!
    
    let kHintZPosition = CGFloat(100.0)
    let kVictoryZPosition = CGFloat(101.0)
    
    var playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0
    var dt : NSTimeInterval = 0
    
    var skunkNodeShot : Bool = false
    var skunkNode : SKSpriteNode!
    var goalNode : SKSpriteNode!
    var hoopNode : SKSpriteNode!
    var wheelNode : SKSpriteNode!
    var cannonNode : SKSpriteNode!
    var backgroundNodeArr : [SKSpriteNode!]! = []
    
    var levelCompleted : Bool = false
    
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
        
        lastTouchedPoint = CGPointMake(size.width/2, size.height/2)
        
        //doHint()
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.gravity = CGVectorMake(0.0, -kGravity)
        
        skunkNode = childNodeWithName("skunk") as! SKSpriteNode
        skunkNode.physicsBody = SKPhysicsBody(circleOfRadius: skunkNode.size.width/2.0)
        skunkNode.physicsBody!.dynamic = true
        skunkNode.physicsBody!.affectedByGravity = false
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.Goal | PhysicsCategory.Edge
        skunkNode.physicsBody!.collisionBitMask = PhysicsCategory.Background
        // physics categories arranged in Z order so just use that
        skunkNode.physicsBody!.restitution = 0.8
        skunkNode.zPosition = CGFloat(PhysicsCategory.Skunk)
        
        goalNode = childNodeWithName("goal") as! SKSpriteNode
        goalNode.physicsBody = SKPhysicsBody(rectangleOfSize:goalNode.size)
        goalNode.physicsBody!.dynamic = false
        goalNode.physicsBody!.affectedByGravity = false
        goalNode.physicsBody!.categoryBitMask = PhysicsCategory.Goal
        goalNode.physicsBody!.contactTestBitMask = PhysicsCategory.Goal
        goalNode.physicsBody!.collisionBitMask = kContactAll
        // physics categories arranged in Z order so just use that
        goalNode.zPosition = CGFloat(-101)
        
        hoopNode = childNodeWithName("hoop") as! SKSpriteNode
        hoopNode.physicsBody = SKPhysicsBody(circleOfRadius: hoopNode.size.width/2.0)
        hoopNode.physicsBody!.dynamic = false
        hoopNode.physicsBody!.affectedByGravity = false
        hoopNode.physicsBody!.categoryBitMask = PhysicsCategory.None
        hoopNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
        hoopNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        // physics categories arranged in Z order so just use that
        // always in front of skunk
        hoopNode.zPosition = CGFloat(PhysicsCategory.Skunk+1)
        
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
        
        let orientConstraint = SKConstraint.orientToPoint(lastTouchedPoint, offset: SKRange(lowerLimit: 0.0, upperLimit: 0.0))
        
        cannonNode.constraints = [orientConstraint]
        
        enumerateChildNodesWithName("background", usingBlock: { (node, _) -> Void in
            if let spriteNode = node as? SKSpriteNode {
                self.backgroundNodeArr.append(spriteNode)
            }
        })
        
        for backgroundNode in backgroundNodeArr
        {
            backgroundNode.physicsBody = SKPhysicsBody(rectangleOfSize: backgroundNode.size)
            backgroundNode.physicsBody!.dynamic = false
            backgroundNode.physicsBody!.affectedByGravity = false
            backgroundNode.physicsBody!.categoryBitMask = PhysicsCategory.Background
            backgroundNode.physicsBody!.collisionBitMask = kContactAll
            // physics categories arranged in Z order so just use that
            backgroundNode.zPosition = -1000
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
    
    func sceneTouched(location: CGPoint)
    {
        //println("lastTouchedPoint=\(lastTouchedPoint)")
        
        /*physicsWorld.enumerateBodiesAtPoint(location, usingBlock: { (physicsBody, pointer) -> Void in
            println("enumerate.physicsBody=\(physicsBody)")
        })*/
        
        let targetNode = self.nodeAtPoint(location)
        //println("targetNode=\(targetNode)")
        //println("")
        /*let targetNodeArr = self.nodesAtPoint(location) as! [SKSpriteNode]
        println("targetNodeArr=\(targetNodeArr)")
        println("")
        //let targetNode = targetNodeArr[targetNodeArr.count-1]
        let targetNode = targetNodeArr[0]
        println("targetNode=\(targetNode)")
        println("")*/
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
        
        if !skunkNodeShot && (targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Cannon || targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Wheel)
        {
            skunkNodeShot = true
            skunkNode.physicsBody!.affectedByGravity = true
            skunkNode.physicsBody!.applyAngularImpulse(0.5)
            
            var skunkVector = lastTouchedPoint - skunkNode.position
            skunkVector /= skunkVector.length()
            skunkVector *= kCannonImpulseStrength
            skunkNode.physicsBody!.applyImpulse(CGVector(dx:skunkVector.x, dy:skunkVector.y))
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Skunk | PhysicsCategory.Goal
        {
            if !levelCompleted
            {
                doVictory()
                
                println("You made a basket!")
            }
            levelCompleted = true
        }
        else if (collision & PhysicsCategory.Edge) != 0
        {
            println("collision with edge")
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
    
    func doVictory()
    {
        mrSkunkDelegate.levelComplete()
        /*let victorySize = CGFloat(size.height/5.0)
        let victoryLabel = ASAttributedLabelNode(size:CGSizeMake(playableRect.size.width*0.8, victorySize))
        let buttonFrame : CGRect = CGRectMake(victoryLabel.position.x, victoryLabel.position.y+victoryLabel.size.height, victoryLabel.size.width, victoryLabel.size.height*2.0/3.0)
        
        victoryLabel.attributedString = outlinedCenteredString("Goal", size: victorySize)
        
        victoryLabel.position =
            CGPointMake(
                size.width/2.0,
                (size.height/2.0) + victorySize/2.0
        )

        victoryLabel.zPosition = kVictoryZPosition
        victoryLabel.xScale = 0.0
        victoryLabel.yScale = 0.0
        addChild(victoryLabel)
        
        var victoryAction = SKAction.sequence(
            [
                SKAction.scaleTo(2.0, duration: 0.25),
                SKAction.scaleTo(1.0, duration: 0.25)
            ])
        
        victoryLabel.runAction(victoryAction)*/
    }
    
    func outlinedCenteredString(string : String, size: CGFloat) -> NSAttributedString
    {
        var myMutableString : NSMutableAttributedString
        var font =  UIFont(name: "Super Mario 256", size: size)!
        var alignment : CTTextAlignment = CTTextAlignment.TextAlignmentCenter
        let alignmentSetting = [CTParagraphStyleSetting(spec: .Alignment, valueSize: Int(sizeofValue(alignment)), value: &alignment)]
        var paragraphRef = CTParagraphStyleCreate(alignmentSetting, 1)
        
        let textFontAttributes = [
            NSFontAttributeName : font,
            // Note: SKColor.whiteColor().CGColor breaks this
            NSForegroundColorAttributeName: UIColor.yellowColor(),
            NSStrokeColorAttributeName: UIColor.blackColor(),
            // Note: Use negative value here if you want foreground color to show
            NSStrokeWidthAttributeName:-3
            //,NSParagraphStyleAttributeName: paragraphRef
        ]
        
        myMutableString = NSMutableAttributedString(string: string, attributes: textFontAttributes as [NSObject : AnyObject])
        
        let para = NSMutableParagraphStyle()
        para.headIndent = 00
        para.firstLineHeadIndent = 00
        para.tailIndent = 0
        para.lineBreakMode = .ByWordWrapping
        para.alignment = .Center
        para.paragraphSpacing = 0
        myMutableString.addAttribute(
            NSParagraphStyleAttributeName,
            value:para, range:NSMakeRange(0,1))
        return myMutableString
    }
    
    func doHint()
    {
        let hintSize = CGFloat(80.0)
        let hintLabel = ASAttributedLabelNode(size:CGSizeMake(playableRect.size.width*0.9, hintSize))
        
        hintLabel.attributedString = outlinedCenteredString("Touch Cannon to Shoot", size: hintSize)
        
        hintLabel.position =
            CGPointMake(
                size.width/2.0,
                ((size.height - playableRect.size.height)/2.0) + hintSize/2.0
        )

        hintLabel.zPosition = kHintZPosition
        addChild(hintLabel)
        
        let hintSize2 = CGFloat(80.0)
        let hintLabel2 = ASAttributedLabelNode(size:CGSizeMake(playableRect.size.width*0.9, hintSize2))
        
        hintLabel2.attributedString = outlinedCenteredString("Touch Screen to Aim", size: hintSize2)
        
        hintLabel2.position =
            CGPointMake(
                size.width/2.0,
                ((size.height - playableRect.size.height)/2.0) + (hintSize2/2.0) + (hintSize)
        )

        hintLabel2.zPosition = kHintZPosition
        addChild(hintLabel2)
    }
}
