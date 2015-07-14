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
    
    /*var woodNodeArr : [SKSpriteNode]! = []
    var stoneBallNode : SKSpriteNode!
    var ropeNode : SKSpriteNode!    */
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
        physicsWorld.gravity = CGVectorMake(0.0, -4.0)
        
        skunkNode = childNodeWithName("skunk") as! SKSpriteNode
        skunkNode.physicsBody!.categoryBitMask = PhysicsCategory.Skunk
        skunkNode.physicsBody!.contactTestBitMask = PhysicsCategory.GarbageCan | PhysicsCategory.Edge
        skunkNode.physicsBody!.collisionBitMask = kContactAll & ~(PhysicsCategory.Rope)
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
        
        /*let range = SKRange(lowerLimit: 0.0, upperLimit: 0.0)
        let orientConstraint = SKConstraint.orientToNode(woodNode, offset: range)
        ropeNode.constraints = [orientConstraint]*/
        
        //let woodRopeJoint = SKPhysicsJointSpring.jointWithBodyA(ropeEdgeAnchorNode.physicsBody, bodyB: ropeNode.physicsBody, anchorA: ropeEdgeAnchorNode.position, anchorB: CGPointMake(ropeNode.position.x-ropeNode.size.width/2, ropeNode.position.y))
        
        /*let woodRopeJoint = SKPhysicsJointSpring.jointWithBodyA(ropeEdgeAnchorNode.physicsBody, bodyB: woodNode.physicsBody, anchorA: ropeEdgeAnchorNode.position, anchorB: getPointTop(woodNode))
        physicsWorld.addJoint(woodRopeJoint)*/
        
        woodRopeJoint = SKPhysicsJointPin.jointWithBodyA(woodNode.physicsBody, bodyB: ropeNode.physicsBody, anchor: getPointTop(woodNode))
        physicsWorld.addJoint(woodRopeJoint)
        
        /*delay(seconds: 2.0,
        completion:
        {
        self.physicsWorld.removeJoint(woodRopeJoint)
        }
        )*/
        
        var woodEdgeAnchorNode = childNodeWithName("woodEdgeAnchor") as! SKSpriteNode
        
        //let woodJoint = SKPhysicsJointSpring.jointWithBodyA(woodEdgeAnchorNode.physicsBody, bodyB: woodNode.physicsBody, anchorA: woodEdgeAnchorNode.position, anchorB: getPointBottom(woodNode))
        let woodJoint = SKPhysicsJointPin.jointWithBodyA(woodEdgeAnchorNode.physicsBody, bodyB: woodNode.physicsBody, anchor: getPointBottom(woodNode))
        physicsWorld.addJoint(woodJoint)
        
        let ropeScreenJoint = SKPhysicsJointPin.jointWithBodyA(ropeEdgeAnchorNode.physicsBody, bodyB: ropeNode.physicsBody, anchor: getPointLeft(ropeNode))
        physicsWorld.addJoint(ropeScreenJoint)
        
        //ropeNode = childNodeWithName("rope") as! SKSpriteNode
        //stoneBallNode = childNodeWithName("stoneBall") as! SKSpriteNode
        //stoneBallNode.physicsBody!.density = 2.0
        
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
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch = touches.first as! UITouch
        sceneTouched(touch.locationInNode(self))
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
                doVictory()
                
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
    
    func doVictory()
    {
        mrSkunkDelegate.levelComplete()
        /*
        let victorySize = CGFloat(size.height/5.0)
        let victoryLabel = ASAttributedLabelNode(size:CGSizeMake(playableRect.size.width*0.8, victorySize))
        let buttonFrame : CGRect = CGRectMake(victoryLabel.position.x, victoryLabel.position.y+victoryLabel.size.height, victoryLabel.size.width, victoryLabel.size.height*2.0/3.0)
        let nextButton : THButton = THButton(frame: buttonFrame, text: "Next")
        view!.addSubview(nextButton)
        
        victoryLabel.attributedString = outlinedCenteredString("Yum", size: victorySize)
        
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
        
        victoryLabel.runAction(victoryAction)
        */
        /*victoryLabel = SKLabelNode(fontNamed: "Super Mario 256")
        victoryLabel.text = "Victory!"
        victoryLabel.position = CGPointMake(size.width/2.0, size.height/2.0)
        victoryLabel.fontSize = size.height/8
        //victoryLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        //victoryLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        victoryLabel.fontColor = SKColor.yellowColor()
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
}
