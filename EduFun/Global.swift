//
//  Global.swift
//  EduFun
//
//  Created by Douglas Voss on 6/25/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

let π : CGFloat = CGFloat(M_PI)

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
            println("label.size w=\(label.frame.size.width) h=\(label.frame.size.height)")
            println("initial.size w=\(initialSize.width) h=\(initialSize.height)")
            println("font.pointSize=\(label.font.pointSize)")
            println("")
        }
    } else {
        while initialSize.width < label.frame.size.width &&
            initialSize.height < label.frame.size.height
        {
            label.font = label.font.fontWithSize(label.font.pointSize + 1)
            initialSize = label.text!.sizeWithAttributes([NSFontAttributeName : label.font])
            println("label.size w=\(label.frame.size.width) h=\(label.frame.size.height)")
            println("initial.size w=\(initialSize.width) h=\(initialSize.height)")
            println("font.pointSize=\(label.font.pointSize)")
            println("")
        }
        label.font = label.font.fontWithSize(label.font.pointSize - 1)
    }
    return label.font.pointSize;
}

public func cgColorForRed(red: CGFloat, #green: CGFloat, #blue: CGFloat) -> CGColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).CGColor as CGColor
}

func rotateViewRecurse(view: UIView, #durationPerRotation: NSTimeInterval, #numRotationsLeft: Int, #scaleIncPerRotation: CGFloat, #startScale: CGFloat, #completionBlock: (Void) -> Void)
{
    UIView.animateWithDuration(
        durationPerRotation/2.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,
        animations:
        {(_) -> (Void) in
            var rotateTransform : CGAffineTransform = CGAffineTransformMakeRotation(π)
            var scaleTransform : CGAffineTransform = CGAffineTransformMakeScale(startScale + (scaleIncPerRotation/2.0), startScale + (scaleIncPerRotation/2.0))
            view.transform = CGAffineTransformConcat(scaleTransform, rotateTransform)
        },
        completion:
        {(_) -> (Void) in
            UIView.animateWithDuration(durationPerRotation/2.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,
                animations:
                {(_) -> (Void) in
                    var rotateTransform : CGAffineTransform = CGAffineTransformMakeRotation(0)
                    var scaleTransform : CGAffineTransform = CGAffineTransformMakeScale(startScale + (scaleIncPerRotation), startScale + (scaleIncPerRotation))
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

func bounceInView(view: UIView, #duration: CGFloat, #delay: CGFloat)
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

func scaleOutRemoveView(view: UIView, #duration: CGFloat, #delay: CGFloat)
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

func spin3BounceView(view: UIView, #duration: CGFloat)
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