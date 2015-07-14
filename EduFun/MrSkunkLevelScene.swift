//
//  MrSkunkLevelScene.swift
//  EduFun
//
//  Created by Douglas Voss on 7/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit
import SpriteKit

let kContactAll : UInt32 = 0xffffffff
let kGravity : CGFloat = 9.8

protocol MrSkunkLevelDelegate {
    func levelComplete()
    func willMoveFromView()
    func autoRestartLevel()
    func hintDisappear()
}

class MrSkunkLevelScene: SKScene, SKPhysicsContactDelegate {
    var mrSkunkDelegate : MrSkunkLevelDelegate! = nil
    
    var beginPoint : CGPoint = CGPointZero
    
    var verticalSwipeRecognizer : UISwipeGestureRecognizer!
    var horizontalSwipeRecognizer : UISwipeGestureRecognizer!
    var swipeCnt : Int = 0
    
    override func willMoveFromView(view: SKView) {
        /*view.removeGestureRecognizer(verticalSwipeRecognizer)
        view.removeGestureRecognizer(horizontalSwipeRecognizer)
        mrSkunkDelegate.willMoveFromView()*/
    }
    
    func setupSwipe()
    {
        /*verticalSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "handleVerticalSwipe:")
        verticalSwipeRecognizer.direction = /*UISwipeGestureRecognizerDirection.Right | UISwipeGestureRecognizerDirection.Left |*/
            UISwipeGestureRecognizerDirection.Up |
            UISwipeGestureRecognizerDirection.Down
        view!.addGestureRecognizer(verticalSwipeRecognizer)
        
        horizontalSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "handleHorizontalSwipe:")
        horizontalSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.Right | UISwipeGestureRecognizerDirection.Left
        view!.addGestureRecognizer(horizontalSwipeRecognizer)*/
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Ended
        {
            let touchLocation : CGPoint = convertPointFromView(sender.locationInView(sender.view))
            let touchedNode : SKNode = nodeAtPoint(touchLocation)
            println("")
            println("swipedNode\(swipeCnt)=\(touchedNode)")
            println("")
            swipeCnt++
        }
    }
    
    func handleVerticalSwipe(sender: UISwipeGestureRecognizer)
    {
        handleSwipe(sender)
    }
    
    func handleHorizontalSwipe(sender: UISwipeGestureRecognizer)
    {
        handleSwipe(sender)
    }
}
