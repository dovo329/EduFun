//
//  MemoryGameViewController.swift
//  CollectionViewTest
//
//  Created by Douglas Voss on 6/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit
import QuartzCore

let π : CGFloat = CGFloat(M_PI)

class MemoryGameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let kFlipDuration : NSTimeInterval = 0.5
    let kMatchDisappearDuration : NSTimeInterval = 3.0
    let kSparkleLifetimeMean : Float = 1.5
    let kSparkleLifetimeVariance : Float = 0.5
    let kConfettiTime : NSTimeInterval = 2.0
    
    let numRows : Int = 4
    let numColumns : Int = 4
    let imageNameArr : [String] = ["BearCard", "CarCard", "FlowerCard", "IceCreamCard","RainbowCard", "StarCard", "CatCard", "PenguinCard"]
    let kCardMinMargin : CGFloat = 5.0
    var collectionView: UICollectionView?
    let cardImg : UIImage = UIImage(named: "IceCreamCard")!
    let bgImgView : UIImageView = UIImageView(image: UIImage(named: "SkyGrassBackground"))
    var card2dArr = Array<Array<Card>>()
    let kCellReuseId : String = "cell.reuse.id"
    var flippedCnt = 0
    var completeLabel : UILabel = UILabel()
    var elapsedTimeLabel : UILabel = UILabel()
    let startTime = NSDate()
    
    var elapsedTime : Double = 0.0
    
    var emitterLayerArr : [CAEmitterLayer]! = Array()
    
    func stopMatchSparkles() {
        var emitterLayer : CAEmitterLayer
        
        for emitterLayer in emitterLayerArr {
            emitterLayer.lifetime = 0.0
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(kSparkleLifetimeVariance+kSparkleLifetimeMean)) * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(),
            {
                    emitterLayer.removeFromSuperlayer()
            })
        }
    }
    
    func startMatchSparkles(#frame1: CGRect, frame2: CGRect) {
        
        emitterLayerArr[0].emitterPosition = CGPointMake(frame1.origin.x + frame1.size.width/2, frame1.origin.y + frame1.size.height/2)
        emitterLayerArr[0].emitterSize = frame1.size
        emitterLayerArr[0].emitterShape = kCAEmitterLayerRectangle
        emitterLayerArr[0].lifetime = kSparkleLifetimeMean
        emitterLayerArr[0].beginTime = CACurrentMediaTime()
        view.layer.addSublayer(emitterLayerArr[0])
        
        emitterLayerArr[1].emitterPosition = CGPointMake(frame2.origin.x + frame2.size.width/2, frame2.origin.y + frame2.size.height/2)
        emitterLayerArr[1].emitterSize = frame2.size
        emitterLayerArr[1].emitterShape = kCAEmitterLayerRectangle
        emitterLayerArr[1].lifetime = kSparkleLifetimeMean
        emitterLayerArr[1].beginTime = CACurrentMediaTime()
        view.layer.addSublayer(emitterLayerArr[1])
    }
    
    func setupMatchSparkles() {
        
        var emitterCell : CAEmitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "StarCell")!.CGImage
        emitterCell.name = "StarCell"
        
        emitterCell.birthRate = 40
        emitterCell.lifetime = kSparkleLifetimeMean
        emitterCell.lifetimeRange = kSparkleLifetimeVariance
        emitterCell.color = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0).CGColor
        emitterCell.redRange = 0.0
        emitterCell.redSpeed = 0.0
        emitterCell.blueRange = 0.0
        emitterCell.blueSpeed = 1.0
        emitterCell.greenRange = 0.0
        emitterCell.greenSpeed = -1.0
        emitterCell.alphaSpeed = 0.0
        
        emitterCell.velocity = 200
        emitterCell.velocityRange = 50
        emitterCell.yAcceleration = 400
        emitterCell.emissionLongitude = -π / 2
        emitterCell.emissionRange = π / 6
        
        emitterCell.scale = 0.25
        emitterCell.scaleSpeed = -0.125
        emitterCell.scaleRange = 0.0
        
        var emitterLayer0 = CAEmitterLayer()!
        emitterLayer0.emitterCells = [emitterCell]
        
        var emitterLayer1 = CAEmitterLayer()!
        emitterLayer1.emitterCells = [emitterCell]
        
        emitterLayerArr.append(emitterLayer0)
        emitterLayerArr.append(emitterLayer1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImgView)
        
        bgImgView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let viewsDictionary = ["bg": bgImgView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bg]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bg]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
        
        /*view.addConstraint(
            NSLayoutConstraint(
                item: bgImgView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0));
        
        view.addConstraint(
            NSLayoutConstraint(
                item: bgImgView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0));
        
        view.addConstraint(
            NSLayoutConstraint(
                item: bgImgView,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Left,
                multiplier: 1.0,
                constant: 0.0));
        
        view.addConstraint(
            NSLayoutConstraint(
                item: bgImgView,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Right,
                multiplier: 1.0,
                constant: 0.0));*/
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kCardMinMargin, left: kCardMinMargin, bottom: kCardMinMargin, right: kCardMinMargin)
        var aspectRatio : CGFloat = cardImg.size.width/cardImg.size.height
        var width : CGFloat = (CGFloat(view.frame.size.width)-(CGFloat(numColumns+1)*kCardMinMargin))/CGFloat(numColumns)
        var height : CGFloat = width/aspectRatio
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = kCardMinMargin
        layout.minimumLineSpacing = kCardMinMargin

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellReuseId)
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.scrollEnabled = false
        
        var cardCountDict = [String:Int]()
        for imageName in imageNameArr
        {
            cardCountDict[imageName] = 0
        }
        
        var numCards = numRows*numColumns
        var numRequiredImages = Int(ceil(Double(numCards)/2.0))
        
        if (numRequiredImages > imageNameArr.count)
        {
            fatalError("Need more cards than have unique images")
        }
        
        var imageNameSubArr = imageNameArr // swift copies arrays with assignment = operator
        var imageNameLtdArr = [String]()
        
        for var i=0; i < numRequiredImages; i++
        {
            var randIndex = Int(arc4random_uniform(UInt32(imageNameSubArr.count)))
            imageNameLtdArr.append(imageNameSubArr[randIndex])
            imageNameSubArr.removeAtIndex(randIndex)
            println("i=\(i) imageNameLtdArr=\(imageNameLtdArr)")
        }
        
        var row : Int = 0
        var column : Int = 0
        for row=0; row < numRows; row++
        {
            var columnArr = Array<Card>()
            for column=0; column < numColumns; column++
            {
                var card : Card = Card()
                //card.isFlipped = (arc4random_uniform(2) > 0)
                card.isFlipped = false
                
                var imageName : String
                var randIndex = Int(arc4random_uniform(UInt32(imageNameLtdArr.count)))
                // find a random card image that hasn't been assigned twice yet
                // if randIndex has already been assigned just pick the next image
                do {
                    imageName = imageNameLtdArr[randIndex]
                    randIndex = (randIndex + 1) % imageNameLtdArr.count
                } while cardCountDict[imageName] >= 2
                
                card.imageName = imageName
                cardCountDict[card.imageName!]!++
                //println("cardCountDict[\(card.imageName)]==\(cardCountDict[card.imageName!]!)")
                
                card.row = row
                card.column = column
                
                columnArr.append(card)
            }
            card2dArr.append(columnArr)
        }
        collectionView?.backgroundColor = UIColor.clearColor()
        view.addSubview(collectionView!)
        collectionViewConstraints()
        
        view.addSubview(completeLabel)
        view.addSubview(elapsedTimeLabel)
        
        setupMatchSparkles()
        
        roundCompleteMethod()
    }

    func collectionViewConstraints() {
        collectionView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        let topConstraint =
        NSLayoutConstraint(
            item: collectionView!,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: topLayoutGuide,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0);
        view.addConstraint(topConstraint);
        
        let bottomConstraint =
        NSLayoutConstraint(
            item: collectionView!,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0);
        view.addConstraint(bottomConstraint);
        
        let leftConstraint =
        NSLayoutConstraint(
            item: collectionView!,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0.0);
        view.addConstraint(leftConstraint);
        
        let rightConstraint =
        NSLayoutConstraint(
            item: collectionView!,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0.0);
        view.addConstraint(rightConstraint);
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numColumns
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numRows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuseId, forIndexPath: indexPath) as! UICollectionViewCell
        
        //cell.backgroundColor = .redColor()
        
        var card : Card = card2dArr[indexPath.section][indexPath.row]

        if (card.isFlipped)
        {
            //cell.backgroundView = UIImageView(image:UIImage(named: card.imageName!)!)
            cell.backgroundView = UIImageView(image: UIImage(named: card.imageName!)!)
        } else
        {
            cell.backgroundView = UIImageView(image: UIImage(named: "CardBack")!)
        }
        
        //println("storedCell at row:\(indexPath.section) column:\(indexPath.row) isFlipped:\(card.isFlipped) imageNames:\(card.imageName)")

        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        var card : Card = card2dArr[indexPath.section][indexPath.row]
        
        // only process unmatched cards
        if (!card.matched) {
            println("selectedCell at row:\(indexPath.section) column:\(indexPath.row) isFlipped:\(card.isFlipped)")
            
            if (flippedCnt < 2)
            {
                if !card.isFlipped
                {
                    flippedCnt++
                    println("flippedCnt=\(flippedCnt)")
                    
                    var newImgView : UIImageView?
                    newImgView = UIImageView(image: UIImage(named: card.imageName!)!)
                    newImgView!.frame = ((cell!.backgroundView)!).frame
                    UIView.transitionFromView((cell!.backgroundView)!, toView:newImgView!, duration: kFlipDuration, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: {(Bool)  in
                           // do nothing
                        }
                    )
                    ((cell!.backgroundView)!) = newImgView!
                    card2dArr[indexPath.section][indexPath.row].isFlipped = true
                } else {
                    //fatalError("tried to flip a card that was already flipped")
                    // do nothing because it's already been flipped over
                }
                
                if (flippedCnt >= 2)
                {
                    var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((kFlipDuration) * Double(NSEC_PER_SEC)))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(),
                        {
                            var compareArr = [Card]()
                            // check for match if 2 cards have been flipped over
                            //println("checkForMatch called")
                            
                            
                            // find all flipped over cards and add them to an array
                            for var row=0; row<self.card2dArr.count; row++
                            {
                                for var column=0; column<self.card2dArr[row].count; column++
                                {
                                    if self.card2dArr[row][column].isFlipped
                                    {
                                        compareArr.append(self.card2dArr[row][column])
                                        //println("true isFlipped row=\(row) column=\(column)")
                                    }
                                }
                            }
                            
                            if compareArr.count > 2
                            {
                                fatalError("more than 2 cards flipped over.  Error alert!")
                            }
                            
                            self.flippedCnt = 0
                            if (compareArr[0].imageName == compareArr[1].imageName)
                            {
                                //println("You made a match! Yay!")
                                
                                self.card2dArr[compareArr[0].row][compareArr[0].column].matched = true
                                self.card2dArr[compareArr[0].row][compareArr[0].column].isFlipped = false
                                var indexPath0 = NSIndexPath(forRow: compareArr[0].column, inSection: compareArr[0].row)
                                self.card2dArr[compareArr[1].row][compareArr[1].column].matched = true
                                self.card2dArr[compareArr[1].row][compareArr[1].column].isFlipped = false
                                var indexPath1 = NSIndexPath(forRow: compareArr[1].column, inSection: compareArr[1].row)
                                
                                var cell0 = collectionView.cellForItemAtIndexPath(indexPath0)
                                var cell1 = collectionView.cellForItemAtIndexPath(indexPath1)
                                
                                self.startMatchSparkles(frame1:cell0!.frame, frame2:cell1!.frame)
                                
                                var blankView0 = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                                UIView.transitionFromView((cell0!.backgroundView)!, toView:blankView0, duration: self.kMatchDisappearDuration, options: UIViewAnimationOptions.TransitionCurlUp, completion:
                                    {(Bool) in
                                        //
                                    }
                                )
                                
                                var blankView1 = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                                UIView.transitionFromView((cell1!.backgroundView)!, toView:blankView1, duration: self.kMatchDisappearDuration, options: UIViewAnimationOptions.TransitionCurlUp, completion: nil)
                                
                                var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(self.kMatchDisappearDuration*(1.0/2.0))) * Double(NSEC_PER_SEC)))
                                dispatch_after(dispatchTime, dispatch_get_main_queue(),
                                    {
                                        self.stopMatchSparkles()
                                    })

                                // check for all matches
                                if self.allMatched()
                                {
                                    self.roundCompleteMethod()
                                }
                            } else {
                                println("Nope, no match for you.")
                                
                                var indexPath0 = NSIndexPath(forRow: compareArr[0].column, inSection: compareArr[0].row)
                                var cell0 = collectionView.cellForItemAtIndexPath(indexPath0)
                                var newImgView0 = UIImageView(image: UIImage(named: "CardBack")!)
                                newImgView0.frame = ((cell0!.backgroundView)!).frame
                                UIView.transitionFromView((cell0!.backgroundView)!, toView:newImgView0, duration: self.kFlipDuration, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
                                ((cell0!.backgroundView)!) = newImgView0
                                self.card2dArr[compareArr[0].row][compareArr[0].column].isFlipped = false
                                
                                var indexPath1 = NSIndexPath(forRow: compareArr[1].column, inSection: compareArr[1].row)
                                var cell1 = collectionView.cellForItemAtIndexPath(indexPath1)
                                var newImgView1 = UIImageView(image: UIImage(named: "CardBack")!)
                                newImgView1.frame = ((cell1!.backgroundView)!).frame
                                UIView.transitionFromView((cell1!.backgroundView)!, toView:newImgView1, duration: self.kFlipDuration, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
                                ((cell1!.backgroundView)!) = newImgView1
                                self.card2dArr[compareArr[1].row][compareArr[1].column].isFlipped = false
                            }
                            
                            println("Card1 row:\(compareArr[0].row) col:\(compareArr[0].column)")
                            println("Card2 row:\(compareArr[1].row) col:\(compareArr[1].column)")
                            
                            /*
                            // unflip all cards
                            self.flippedCnt = 0
                            // find all flipped over cards and add them to an array
                            for var row=0; row<self.card2dArr.count; row++
                            {
                            for var column=0; column<self.card2dArr[row].count; column++
                            {
                            if (self.card2dArr[row][column].isFlipped) {
                            var indexPath = NSIndexPath(forRow: column, inSection: row)
                            var cell = collectionView.cellForItemAtIndexPath(indexPath)
                            
                            var newImgView = UIImageView(image: UIImage(named: "CardBack")!)
                            newImgView.frame = ((cell!.backgroundView)!).frame
                            UIView.transitionFromView((cell!.backgroundView)!, toView:newImgView, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
                            ((cell!.backgroundView)!) = newImgView
                            self.card2dArr[indexPath.section][indexPath.row].isFlipped = false
                            }
                            }
                            }*/
                    })
                }
            }
        }
    }
    
    func allMatched() -> Bool
    {
        var allMatched = true
        for var row=0; row<self.card2dArr.count; row++
        {
            for var column=0; column<self.card2dArr[row].count; column++
            {
                if !self.card2dArr[row][column].matched
                {
                    allMatched = false
                }
            }
        }
        return allMatched
    }
    
    func rotateOnceCompleteLabel(#durationPerRotation: NSTimeInterval, numRotationsLeft: Int)
    {
        UIView.animateWithDuration(
            durationPerRotation/2.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,
            animations:
            {(_) -> (Void)
                in self.completeLabel.transform = CGAffineTransformMakeRotation(π)
            },
            completion:
            {(_) -> (Void) in
                UIView.animateWithDuration(durationPerRotation/2.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,
                    animations:
                    {(_) -> (Void)
                        in self.completeLabel.transform = CGAffineTransformMakeRotation(0)
                    },
                    completion:
                    {(_) -> (Void) in
                        if (numRotationsLeft > 1)
                        {
                            self.rotateOnceCompleteLabel(durationPerRotation: durationPerRotation, numRotationsLeft: numRotationsLeft-1)
                        }
                    }
                )
        })
    }
    
    func rotateAndScaleCompleteLabel(#duration: CGFloat, numRotations: Int, maxScale: CGFloat)
    {
        rotateOnceCompleteLabel(durationPerRotation: NSTimeInterval(duration/CGFloat(numRotations)), numRotationsLeft:numRotations)
    }
    
    func roundCompleteMethod() {
        println("Complete!")
        let endTime = NSDate();
        let elapsedTime: Double = endTime.timeIntervalSinceDate(self.startTime);
        println("Time: \(elapsedTime) seconds");
        
        completeLabel.text = "Complete!"
        completeLabel.font = UIFont(name: "Super Mario 256", size: 50.0)
        completeLabel.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height/3.0)
        completeLabel.textAlignment = NSTextAlignment.Center
        completeLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        
        rotateAndScaleCompleteLabel(duration:2.0, numRotations:3, maxScale:3.0)
        
        //UIView.animateWithDuration(2.0) {
            //self.completeLabel.transform = CGAffineTransformMakeRotation(π)
            //self.completeLabel.transform = CGAffineTransformMakeScale(2.0, 2.0)
        //}

        self.elapsedTimeLabel.text = NSString(format: "Time: %.0f seconds", elapsedTime) as? String
        self.elapsedTimeLabel.font = UIFont(name: "Super Mario 256", size: 25.0)
        self.elapsedTimeLabel.frame = CGRect(x: self.view.frame.size.width/2.0, y: self.view.frame.size.height/4.0+100.0, width: self.view.frame.size.width, height: self.view.frame.size.height/3.0)
        UIView.animateWithDuration(3.0) {
            self.elapsedTimeLabel.transform = CGAffineTransformMakeScale(2.0, 2.0)
        }
        
        var confettiEmitterCell : CAEmitterCell = CAEmitterCell()
        var confettiCellUIImage : UIImage = UIImage(named:"ConfettiCell")!
        confettiEmitterCell.contents = confettiCellUIImage.CGImage;
        
        var confettiEmitterLayer = CAEmitterLayer()
        confettiEmitterLayer.emitterPosition = CGPointMake(self.view.frame.origin.x + (self.view.frame.size.width/2), self.view.frame.origin.y - confettiCellUIImage.size.height)
        confettiEmitterLayer.emitterSize = CGSizeMake(self.view.frame.size.width, 0.0)
        confettiEmitterLayer.emitterShape = kCAEmitterLayerLine
        
        confettiEmitterCell.name = "ConfettiCell"
        
        confettiEmitterCell.birthRate = 50
        confettiEmitterCell.lifetime = 5
        confettiEmitterCell.lifetimeRange = 0
        confettiEmitterCell.color = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0).CGColor
        confettiEmitterCell.redRange = 0.8
        confettiEmitterCell.redSpeed = 0.0
        confettiEmitterCell.blueRange = 0.8
        confettiEmitterCell.blueSpeed = 0.0
        confettiEmitterCell.greenRange = 0.8
        confettiEmitterCell.greenSpeed = 0.0
        confettiEmitterCell.alphaSpeed = 0.0
        
        confettiEmitterCell.spin = 0.0
        confettiEmitterCell.spinRange = 1.5
        
        confettiEmitterCell.velocity = 125
        confettiEmitterCell.velocityRange = 0
        confettiEmitterCell.yAcceleration = 100
        confettiEmitterCell.emissionLongitude = π
        confettiEmitterCell.emissionRange = π/4
        
        confettiEmitterCell.scale = 0.4
        confettiEmitterCell.scaleSpeed = 0.0
        confettiEmitterCell.scaleRange = 0.1
        
        confettiEmitterLayer.emitterCells = [confettiEmitterCell]
        
        confettiEmitterLayer.beginTime = CACurrentMediaTime()
        view.layer.addSublayer(confettiEmitterLayer)
        
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(kConfettiTime)) * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
        {
            confettiEmitterLayer.lifetime = 0.0
        })
        
        dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(2*kConfettiTime)) * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
        {
            confettiEmitterLayer.removeFromSuperlayer()
        })
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        //println("DeselectedCell at row:\(indexPath.section) column:\(indexPath.row)")
    }
}
