//
//  Global.swift
//  EduFun
//
//  Created by Douglas Voss on 6/25/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

let π : CGFloat = CGFloat(M_PI)

struct ViewControllerEnum {
    static let CardMatching : UInt32 = 0b00001
    static let ColoringBook : UInt32 = 0b00010
    static let MrSkunk  : UInt32 = 0b00100
    static let TitleScreen  : UInt32 = 0b01000
    static let About        : UInt32 = 0b10000
}

public func getFontSizeToFitFrameOfLabel(label: UILabel) -> CGFloat
{
    var initialSize : CGSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
    
    if initialSize.width > label.frame.size.width ||
        initialSize.height > label.frame.size.height
    {
        while initialSize.width > label.frame.size.width ||
            initialSize.height > label.frame.size.height
        {
            label.font = label.font.fontWithSize(label.font.pointSize - 1)
            initialSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
            /*println("label.size w=\(label.frame.size.width) h=\(label.frame.size.height)")
            println("initial.size w=\(initialSize.width) h=\(initialSize.height)")
            println("font.pointSize=\(label.font.pointSize)")
            println("")*/
        }
    } else {
        while initialSize.width < label.frame.size.width &&
            initialSize.height < label.frame.size.height
        {
            label.font = label.font.fontWithSize(label.font.pointSize + 1)
            initialSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
            /*println("label.size w=\(label.frame.size.width) h=\(label.frame.size.height)")
            println("initial.size w=\(initialSize.width) h=\(initialSize.height)")
            println("font.pointSize=\(label.font.pointSize)")
            println("")*/
        }
        label.font = label.font.fontWithSize(label.font.pointSize - 1)
    }
    return label.font.pointSize;
}

public func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).CGColor as CGColor
}

func rotateViewRecurse(view: UIView, durationPerRotation: NSTimeInterval, numRotationsLeft: Int, scaleIncPerRotation: CGFloat, startScale: CGFloat, completionBlock: (Void) -> Void)
{
    UIView.animateWithDuration(
        durationPerRotation/2.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,
        animations:
        {(_) -> (Void) in
            let rotateTransform : CGAffineTransform = CGAffineTransformMakeRotation(π)
            let scaleTransform : CGAffineTransform = CGAffineTransformMakeScale(startScale + (scaleIncPerRotation/2.0), startScale + (scaleIncPerRotation/2.0))
            view.transform = CGAffineTransformConcat(scaleTransform, rotateTransform)
        },
        completion:
        {(_) -> (Void) in
            UIView.animateWithDuration(durationPerRotation/2.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,
                animations:
                {(_) -> (Void) in
                    let rotateTransform : CGAffineTransform = CGAffineTransformMakeRotation(0)
                    let scaleTransform : CGAffineTransform = CGAffineTransformMakeScale(startScale + (scaleIncPerRotation), startScale + (scaleIncPerRotation))
                    view.transform = CGAffineTransformConcat(scaleTransform, rotateTransform)
                },
                completion:
                {(_) -> (Void) in
                    if (numRotationsLeft > 1)
                    {
                        rotateViewRecurse(view, durationPerRotation: durationPerRotation, numRotationsLeft: numRotationsLeft-1, scaleIncPerRotation:scaleIncPerRotation, startScale:(startScale + scaleIncPerRotation), completionBlock: completionBlock)
                    }
                    else
                    {
                        completionBlock()
                    }
                }
            )
    })
}

func bounceInView(view: UIView, duration: CGFloat, delay: CGFloat)
{
    view.transform = CGAffineTransformMakeScale(0.01, 0.01)
    
    UIView.animateWithDuration(
        NSTimeInterval(duration*(1.0/2.0)), delay: NSTimeInterval(delay), options: UIViewAnimationOptions.CurveLinear,
        animations:
        {(_) -> (Void) in
            view.transform = CGAffineTransformMakeScale(1.5, 1.5)
        },
        completion:
        {(_) -> (Void) in
            UIView.animateWithDuration(
                NSTimeInterval(duration*(1.0/2.0)), delay: 0.0, options: UIViewAnimationOptions.CurveLinear,
                animations:
                {(_) -> (Void) in
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                },
                completion:
                nil
            )
        }
    )
}

func scaleOutRemoveView(view: UIView, duration: CGFloat, delay: CGFloat)
{
    view.transform = CGAffineTransformMakeScale(1.0, 1.0)
    
    UIView.animateWithDuration(
        NSTimeInterval(duration), delay: NSTimeInterval(delay), options: UIViewAnimationOptions.CurveLinear,
        animations:
        {(_) -> (Void) in
            view.transform = CGAffineTransformMakeScale(0.01, 0.01)
        },
        completion:
        {(_) -> (Void) in
            view.removeFromSuperview()
        }
    )
}

func scaleInAddView(view: UIView, parentView: UIView, duration: CGFloat, delay: CGFloat)
{
    view.transform = CGAffineTransformMakeScale(0.01, 0.01)
    parentView.addSubview(view)
    
    UIView.animateWithDuration(
        NSTimeInterval(duration), delay: NSTimeInterval(delay), options: UIViewAnimationOptions.CurveLinear,
        animations:
        {(_) -> (Void) in
            view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        },
        completion:
        {(_) -> (Void) in
            
        }
    )
}

func makeCenteredRectWithScale(scale: CGFloat, ofFrame: CGRect) -> CGRect
{
    var frame = ofFrame
    frame.size.width *= scale
    frame.size.height *= scale
    frame.origin.x = (ofFrame.size.width-frame.size.width)/2.0
    frame.origin.y = (ofFrame.size.height-frame.size.height)/2.0
    //frame.origin.y += frame.size.height*0.07
    return frame
}

func spin3BounceView(view: UIView, duration: CGFloat)
{
    // start out at (nearly) zero size.  Can't be zero size since this will make the rotation matrix not work when scaling from 0
    view.transform = CGAffineTransformMakeScale(0.01, 0.01)
    // scale on first rotation from 0 to 1.0
    rotateViewRecurse(view, durationPerRotation: NSTimeInterval(duration/3.0), numRotationsLeft:1, scaleIncPerRotation:1.0, startScale: 0.0,
        
        // scale on second rotation from 1.0 to 2.0
        completionBlock:
        {(_)->Void in
            rotateViewRecurse(view, durationPerRotation: NSTimeInterval(duration/3.0), numRotationsLeft:1, scaleIncPerRotation:1.0, startScale: 1.0,
                
                // scale on third rotation from 2.0 back down to 1.0
                completionBlock:
                {(_)->Void in
                    rotateViewRecurse(view, durationPerRotation: NSTimeInterval(duration/3.0), numRotationsLeft:1, scaleIncPerRotation:-1.0, startScale: 2.0,
                        completionBlock:
                        {(_)->Void in
                            //println("completion block called!")
                        }
                    )}
            )}
    )
}

public func delay(seconds seconds: Double, completion:()->())
{
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0))
    {
        completion()
    }
}

func random(min min: CGFloat, max: CGFloat) -> CGFloat
{
    return CGFloat(Float(arc4random()) / Float(0x7FFFFFFF)) * (max - min) + min
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (inout left: CGPoint, right: CGPoint) {
    left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (inout left: CGPoint, right: CGPoint) {
    left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (inout point: CGPoint, scalar: CGFloat) {
    point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (inout left: CGPoint, right: CGPoint) {
    left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (inout point: CGPoint, scalar: CGFloat) {
    point = point / scalar
}

#if !(arch(x86_64) || arch(arm64))
    func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
        return CGFloat(atan2f(Float(y), Float(x)))
    }
    
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
    var angle: CGFloat {
        return atan2(y, x)
    }
}

func shortestAngleBetween(angle1: CGFloat,
    angle2: CGFloat) -> CGFloat {
        let twoπ = π * 2.0
        var angle = (angle2 - angle1) % twoπ
        if (angle >= π) {
            angle = angle - twoπ
        }
        if (angle <= -π) {
            angle = angle + twoπ
        }
        return angle
}

extension CGFloat {
    func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0
    }
}

public func getPointTop(node: SKSpriteNode) -> CGPoint
{
    let nodeEndPt = CGPointMake(0.0, -node.size.height/2)
    return nodeToSceneCoordinatesTransform(point: nodeEndPt, node: node)
}

public func getPointBottom(node: SKSpriteNode) -> CGPoint
{
    let nodeEndPt = CGPointMake(0.0, node.size.height/2)
    return nodeToSceneCoordinatesTransform(point: nodeEndPt, node: node)
}

public func getPointLeft(node: SKSpriteNode) -> CGPoint
{
    let nodeEndPt = CGPointMake(-node.size.width/2, 0.0)
    return nodeToSceneCoordinatesTransform(point: nodeEndPt, node: node)
}

public func getPointRight(node: SKSpriteNode) -> CGPoint
{
    let nodeEndPt = CGPointMake(node.size.width/2, 0.0)
    return nodeToSceneCoordinatesTransform(point: nodeEndPt, node: node)
}

public func nodeToSceneCoordinatesTransform(point point: CGPoint, node: SKSpriteNode) -> CGPoint
{
    var rotatedPt = CGPointApplyAffineTransform(point, CGAffineTransformMakeRotation(-node.zRotation))
    // spriteNode local coordinates have inverted y axis
    // how confusing
    rotatedPt.y = -rotatedPt.y
    
    let finalPt = rotatedPt + node.position
    return finalPt
}
