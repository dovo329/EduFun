//
//  MemoryGameViewController.swift
//  CollectionViewTest
//
//  Created by Douglas Voss on 6/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit
import QuartzCore

class MemoryGameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let kPeekDuration : TimeInterval = 2.0
    let kFlipDuration : TimeInterval = 0.5
    let kMatchDisappearDuration : TimeInterval = 2.0
    let kSparkleLifetimeMean : Float = 1.5
    let kConfetti4STime : TimeInterval = 2.0
    
    let kNumRows : Int = 4
    let kNumColumns : Int = 4
    let kImageNameArr : [String] = ["BearCard", "CarCard", "FlowerCard", "IceCreamCard","RainbowCard", "StarCard", "CatCard", "PenguinCard"]
    var collectionView: UICollectionView!
    var card2dArr = Array<Array<Card>>()
    let kCellReuseId : String = "cell.reuse.id"
    var flippedCnt = 0
    var numMoves = 0
    
    var titleView : UIView!
    var completeView : UIView!
    var newGameButton : THButton?
    var exitButton    : THButton?
    
    var cardWidth : CGFloat!
    var cardHeight : CGFloat!
    
    var title1Label : THLabel = THLabel()
    var title2Label : THLabel = THLabel()
    var completeLabel : THLabel = THLabel()
    var elapsedTimeLabel : THLabel
    var numMovesLabel : THLabel = THLabel()
    
    var startTime = NSDate()
    var elapsedTime : Double = 0.0
    
    var emitterLayerArr : [CAEmitterLayer]! = Array()
    var emitterLayer0 : CAEmitterLayer!
    var emitterLayer1 : CAEmitterLayer!
    
    init(_ coder: NSCoder? = nil) {
        elapsedTimeLabel = THLabel()
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // since titlescreen viewcontroller is landscape, and since apparently the view.frame never updates to be the new orientation (why?), need to swap width and height of frame
        let width = view.frame.size.width
        let height = view.frame.size.height
        view.frame = CGRect(x: 0, y: 0, width: height, height: width)

        let bgGradLayer = CAGradientLayer()
        bgGradLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        bgGradLayer.colors = [
            cgColor(red: 255.0, green:255.0, blue:255.0),
            cgColor(red: 0.0, green:217.0, blue:240.0)
        ]
        bgGradLayer.startPoint = CGPoint(x:0.0, y:0.0)
        bgGradLayer.endPoint = CGPoint(x:0.0, y:1.0)
        bgGradLayer.shouldRasterize = true
        view.layer.addSublayer(bgGradLayer)
        
        let kCardXMargin : CGFloat = view.frame.size.width*(1/69.0)
        let kCardYMargin : CGFloat = (view.frame.size.height-20.0)*(1/69.0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kCardYMargin, left: kCardXMargin, bottom: 0, right: kCardXMargin)
        cardWidth = (16.0/69.0)*view.frame.size.width
        cardHeight = (16.0/69.0)*(view.frame.size.height-20.0)
        
        /*let kCardXMargin : CGFloat = view.frame.size.width*(1/69.0)
        let kCardYMargin : CGFloat = (view.frame.size.height-20.0)*(1/69.0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kCardYMargin, left: kCardXMargin, bottom: 0, right: kCardXMargin)
        cardWidth = (16.0/69.0)*view.frame.size.width
        cardHeight = (16.0/69.0)*(view.frame.size.height-20.0)*/
        
        /*let kCardXMargin : CGFloat = view.frame.size.height*(1/69.0)
        let kCardYMargin : CGFloat = (view.frame.size.width-20.0)*(1/69.0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kCardYMargin, left: kCardXMargin, bottom: 0, right: kCardXMargin)
        cardWidth = (16.0/69.0)*view.frame.size.height
        cardHeight = (16.0/69.0)*(view.frame.size.width-20.0)*/
        
        layout.itemSize = CGSize(width: cardWidth, height: cardHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        self.collectionView.isUserInteractionEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellReuseId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        
        view.addSubview(collectionView)
        collectionViewConstraints()
        
        newGameButton = THButton(frame: CGRect(x: self.view.frame.width/4, y: self.view.frame.height*5/8, width: self.view.frame.width/2, height: self.view.frame.height/10.0), text: "New Game")
        newGameButton!.addTarget(self, action: #selector(newGameButtonMethod(sender:event:)), for: UIControlEvents.touchUpInside)
        
        exitButton = THButton(frame: CGRect(x: self.view.frame.width/4, y: self.view.frame.height*5/8 + newGameButton!.frame.size.height+20.0, width: self.view.frame.width/2, height: self.view.frame.height/10.0), text:"Exit    ")
        exitButton!.addTarget(self, action: #selector(exitButtonMethod(sender:event:)), forControlEvents: UIControlEvents.touchUpInside)
        
        setupMatchSparkles()
        
        setupCardArr()
        
        initTitleLabels()
        initRoundCompleteLabels()
        //roundCompleteMethod()
        titleMethod()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.activateCardArr()
    }
    
    func setupMatchSparkles() {
        
        var emitterCell : CAEmitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "StarCell")!.CGImage
        emitterCell.name = "StarCell" // 🌟
        
        emitterCell.birthRate = 40
        emitterCell.lifetime = kSparkleLifetimeMean
        emitterCell.lifetimeRange = 0
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
        
        //emitterCell.scale = 0.25
        emitterCell.scale = view.frame.size.width*(0.25/320.0)
        emitterCell.scaleSpeed = -0.125
        emitterCell.scaleRange = 0.0
        
        var emitterLayer0 = CAEmitterLayer()
        emitterLayer0.emitterCells = [emitterCell]
        emitterLayer0.lifetime = 0.0
        
        var emitterLayer1 = CAEmitterLayer()
        emitterLayer1.emitterCells = [emitterCell]
        emitterLayer1.lifetime = 0.0
        
        emitterLayerArr.append(emitterLayer0)
        emitterLayerArr.append(emitterLayer1)
        
        view.layer.addSublayer(emitterLayer0)
        view.layer.addSublayer(emitterLayer1)
    }
    
    func startMatchSparkles(frame1: CGRect, frame2: CGRect) {
        
        emitterLayerArr[0].emitterPosition = CGPointMake(frame1.origin.x + frame1.size.width/2, frame1.origin.y + frame1.size.height/2)
        emitterLayerArr[0].emitterSize = frame1.size
        emitterLayerArr[0].emitterShape = kCAEmitterLayerRectangle
        emitterLayerArr[0].lifetime = kSparkleLifetimeMean
        view.layer.addSublayer(emitterLayerArr[0])
        //emitterLayerArr[0].beginTime = CACurrentMediaTime()-0.5
        //emitterLayerArr[0].beginTime = CACurrentMediaTime()
        //println("currentMediaTime=\(CACurrentMediaTime())")
        
        emitterLayerArr[1].emitterPosition = CGPointMake(frame2.origin.x + frame2.size.width/2, frame2.origin.y + frame2.size.height/2)
        emitterLayerArr[1].emitterSize = frame2.size
        emitterLayerArr[1].emitterShape = kCAEmitterLayerRectangle
        view.layer.addSublayer(emitterLayerArr[1])
        emitterLayerArr[1].lifetime = kSparkleLifetimeMean
        //emitterLayerArr[1].beginTime = CACurrentMediaTime()-0.5
        //emitterLayerArr[1].beginTime = CACurrentMediaTime()
        
        /*var emitterCell : CAEmitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "StarCell")!.CGImage
        emitterCell.name = "StarCell" // 🌟
        
        emitterCell.birthRate = 40
        emitterCell.lifetime = kSparkleLifetimeMean
        emitterCell.lifetimeRange = 0
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
        
        //emitterCell.scale = 0.25
        emitterCell.scale = view.frame.size.width*(0.25/320.0)
        emitterCell.scaleSpeed = -0.125
        emitterCell.scaleRange = 0.0
        
        emitterLayer0 = nil
        emitterLayer0 = CAEmitterLayer()
        emitterLayer0.emitterCells = [emitterCell]
        emitterLayer0.emitterPosition = CGPointMake(frame1.origin.x + frame1.size.width/2, frame1.origin.y + frame1.size.height/2)
        emitterLayer0.emitterSize = frame1.size
        emitterLayer0.emitterShape = kCAEmitterLayerRectangle
        emitterLayer0.lifetime = kSparkleLifetimeMean
        view.layer.addSublayer(emitterLayer0)
        emitterLayer0.beginTime = CACurrentMediaTime()
        //println("currentMediaTime=\(CACurrentMediaTime())")
        
        emitterLayer1 = nil
        emitterLayer1 = CAEmitterLayer()
        emitterLayer1.emitterCells = [emitterCell]
        emitterLayer1.emitterPosition = CGPointMake(frame2.origin.x + frame2.size.width/2, frame2.origin.y + frame2.size.height/2)
        emitterLayer1.emitterSize = frame1.size
        emitterLayer1.emitterShape = kCAEmitterLayerRectangle
        emitterLayer1.lifetime = kSparkleLifetimeMean
        view.layer.addSublayer(emitterLayer1)
        emitterLayer1.beginTime = CACurrentMediaTime()*/
    }
    
    func stopMatchSparkles() {
        //var emitterLayer : CAEmitterLayer
        //emitterLayer0.lifetime = 0
        //emitterLayer1.lifetime = 0
        emitterLayerArr[0].lifetime = 0.0
        emitterLayerArr[1].lifetime = 0.0
        
        /*var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(kSparkleLifetimeMean)) * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
            {
                //self.emitterLayer0.removeFromSuperlayer()
                //self.emitterLayer1.removeFromSuperlayer()
                //self.emitterLayer0 = nil
                //self.emitterLayer1 = nil
        })*/

        /*for var layer in self.view.sublayers
        {
                if layer.isKindOfClass(CAEmitterLayer.class)
                {
                    layer.removeFromSuperview()
                    layer = nil
                }
            }*/

        /*for emitterLayer in emitterLayerArr {
            emitterLayer.lifetime = 0.0
            
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(kSparkleLifetimeMean)) * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(),
                {
                    emitterLayer.removeFromSuperlayer()
        })
        }*/
    }
    
    func activateCardArr() {
        numMoves = 0
        //println("collectionView.userInteractionEnabled=\(collectionView.userInteractionEnabled)")
        for var row=0; row<kNumRows; row++
        {
            for var column=0; column<kNumColumns; column++
            {
                let indexPath = NSIndexPath(forRow: column, inSection: row)
                let cell = collectionView.cellForItemAtIndexPath(indexPath)
                let card : Card = card2dArr[row][column]
                //var toView = UIImageView(image: UIImage(named: "CardBack"))
                let toView = UIImageView(image: UIImage(named: card.imageName!))
                toView.frame = cell!.backgroundView!.frame
                
                UIView.transitionFromView((cell!.backgroundView)!, toView:toView, duration: self.kFlipDuration, options: UIViewAnimationOptions.TransitionFlipFromBottom, completion:
                    {(Bool) in
                        cell!.backgroundView = UIImageView(image: UIImage(named: card.imageName!))
                        toView.removeFromSuperview()
                    }
                )
                
                card.active = true
                card.isFlipped = false
                card2dArr[row][column] = card
            }
        }
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(kFlipDuration+kPeekDuration)) * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
            {
                for var row=0; row<self.kNumRows; row++
                {
                    for var column=0; column<self.kNumColumns; column++
                    {
                        let indexPath = NSIndexPath(forRow: column, inSection: row)
                        let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
                        var card : Card = self.card2dArr[row][column]
                        let toView = UIImageView(image: UIImage(named: "CardBack"))
                        //var toView = UIImageView(image: UIImage(named: card.imageName!))
                        toView.frame = cell!.backgroundView!.frame
                        
                        UIView.transitionFromView((cell!.backgroundView)!, toView:toView, duration: self.kFlipDuration, options: UIViewAnimationOptions.TransitionFlipFromBottom, completion:
                            {(Bool) in
                                cell!.backgroundView = UIImageView(image: UIImage(named: "CardBack"))
                                toView.removeFromSuperview()
                                self.startTime = NSDate()
                                self.collectionView.userInteractionEnabled = true
                            }
                        )
                    }
                }
            }
        )
        /*var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(kMatchDisappearDuration)) * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
            {
                self.collectionView.reloadData()
            }
        )*/
        
    }
    
    func setupCardArr() {
        flippedCnt = 0
        
        var cardCountDict = [String:Int]()
        for imageName in kImageNameArr
        {
            cardCountDict[imageName] = 0
        }
        
        let numCards = kNumRows*kNumColumns
        let numRequiredImages = Int(ceil(Double(numCards)/2.0))
        
        if (numRequiredImages > kImageNameArr.count)
        {
            fatalError("Need more cards than have unique images")
        }
        
        var imageNameSubArr = kImageNameArr // swift copies arrays with assignment = operator
        var imageNameLtdArr = [String]()
        
        for var i=0; i < numRequiredImages; i++
        {
            let randIndex = Int(arc4random_uniform(UInt32(imageNameSubArr.count)))
            imageNameLtdArr.append(imageNameSubArr[randIndex])
            imageNameSubArr.removeAtIndex(randIndex)
            //println("i=\(i) imageNameLtdArr=\(imageNameLtdArr)")
        }
        
        card2dArr.removeAll(keepCapacity: false)
        var row : Int = 0
        var column : Int = 0
        for row=0; row < kNumRows; row++
        {
            var columnArr = Array<Card>()
            for column=0; column < kNumColumns; column++
            {
                let card : Card = Card()
                card.isFlipped = false
                card.active = false
                
                var imageName : String
                var randIndex = Int(arc4random_uniform(UInt32(imageNameLtdArr.count)))
                // find a random card image that hasn't been assigned twice yet
                // if randIndex has already been assigned just pick the next image
                repeat {
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
    }
    
    func collectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDictionary = ["cv": collectionView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20.0-[cv]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cv]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kNumColumns
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return kNumRows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuseId, forIndexPath: indexPath) 
        
        let card : Card = card2dArr[indexPath.section][indexPath.row]
        
        if !card.active
        {
            cell.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
        }
        else
        {
            if card.isFlipped
            {
                cell.backgroundView = UIImageView(image: UIImage(named: card.imageName!)!)
            }
            else
            {
                cell.backgroundView = UIImageView(image: UIImage(named: "CardBack")!)
            }
        }
        
        //println("storedCell at row:\(indexPath.section) column:\(indexPath.row) isFlipped:\(card.isFlipped) imageNames:\(card.imageName)")
        
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        let card : Card = card2dArr[indexPath.section][indexPath.row]
        //println("numMoves=\(numMoves)")
        
        // only flip over another card if there are < 2 cards already flipped over
        if (self.flippedCnt < 2 && !card.matched && !card.isFlipped)
        {
            //println("selectedCell at row:\(indexPath.section) column:\(indexPath.row) isFlipped:\(card.isFlipped) flippedCnt=\(flippedCnt) !card.matched !card.isFlipped")
            
            self.flippedCnt++
            card.isFlipped = true
            
            var newImgView : UIImageView?
            newImgView = UIImageView(image: UIImage(named: card.imageName!)!)
            newImgView!.frame = ((cell.backgroundView)!).frame
            UIView.transitionFromView(
                (cell.backgroundView)!, toView:newImgView!, duration: kFlipDuration, options: UIViewAnimationOptions.TransitionFlipFromRight,
                completion:
                {(Bool) in
                    ((cell.backgroundView)!) = UIImageView(image: UIImage(named: card.imageName!)!)
                    newImgView?.removeFromSuperview()
                }
            )
            
            if (self.flippedCnt > 2)
            {
                fatalError("invalid flippedCnt is \(self.flippedCnt)")
            }
            else if (self.flippedCnt == 2)
            {
                numMoves++
                let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(self.kFlipDuration*(1.05))) * Double(NSEC_PER_SEC)))
                dispatch_after(
                    dispatchTime, dispatch_get_main_queue(),
                    {
                        //self.collectionView.userInteractionEnabled = false
                        //println("disabled collectionView userinteraction")
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
                        
                        if compareArr.count < 2
                        {
                            fatalError("less than 2 cards flipped over.  Error alert!")
                        }
                        
                        if (compareArr[0].imageName == compareArr[1].imageName)
                        {
                            //println("You made a match! Yay!")

                            self.card2dArr[compareArr[0].row][compareArr[0].column].active = false
                            self.card2dArr[compareArr[0].row][compareArr[0].column].matched = true
                            self.card2dArr[compareArr[0].row][compareArr[0].column].isFlipped = false
                            let indexPath0 = NSIndexPath(forRow: compareArr[0].column, inSection: compareArr[0].row)
                            
                            self.card2dArr[compareArr[1].row][compareArr[1].column].active = false
                            self.card2dArr[compareArr[1].row][compareArr[1].column].matched = true
                            self.card2dArr[compareArr[1].row][compareArr[1].column].isFlipped = false
                            let indexPath1 = NSIndexPath(forRow: compareArr[1].column, inSection: compareArr[1].row)
                            
                            let cell0 = collectionView.cellForItemAtIndexPath(indexPath0)!
                            let cell1 = collectionView.cellForItemAtIndexPath(indexPath1)!
                            
                            let blankView0 = UIView(frame: CGRect(x: 0, y: 0, width: cell0.backgroundView!.frame.size.width, height: cell0.backgroundView!.frame.size.height))
                            UIView.transitionFromView((cell0.backgroundView)!, toView:blankView0, duration: self.kMatchDisappearDuration, options: UIViewAnimationOptions.TransitionCurlUp,
                                completion:
                                {(Bool) in
                                    (cell0.backgroundView)! = UIView(frame: CGRect(x: 0, y: 0, width: cell0.backgroundView!.frame.size.width, height: cell0.backgroundView!.frame.size.height))
                                    blankView0.removeFromSuperview()
                                }
                            )
                            
                            let blankView1 = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                            UIView.transitionFromView((cell1.backgroundView)!, toView:blankView1, duration: self.kMatchDisappearDuration, options: UIViewAnimationOptions.TransitionCurlUp,
                                completion:
                                {(Bool) in
                                    (cell1.backgroundView)! = UIView(frame: CGRect(x: 0, y: 0, width: cell1.backgroundView!.frame.size.width, height: cell1.backgroundView!.frame.size.height))
                                    blankView1.removeFromSuperview()
                                }
                            )
                            
                            self.startMatchSparkles(frame1:cell0.frame, frame2:cell1.frame)
                            
                            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(self.kMatchDisappearDuration*(1.0/2.0))) * Double(NSEC_PER_SEC)))
                            dispatch_after(dispatchTime, dispatch_get_main_queue(),
                                {
                                    self.stopMatchSparkles()
                                }
                            )
                            
                            // check for all matches
                            if self.allMatched()
                            {
                                self.roundCompleteMethod()
                            }
                        }
                        else
                        {
                            //println("Nope, no match for you.")
                            
                            let indexPath0 = NSIndexPath(forRow: compareArr[0].column, inSection: compareArr[0].row)
                            let cell0 = collectionView.cellForItemAtIndexPath(indexPath0)!
                            let newImgView0 = UIImageView(image: UIImage(named: "CardBack")!)
                            newImgView0.frame = ((cell0.backgroundView)!).frame
                            UIView.transitionFromView((cell0.backgroundView)!, toView:newImgView0, duration: self.kFlipDuration, options: UIViewAnimationOptions.TransitionFlipFromRight, completion:
                                {(Bool) in
                                    (cell0.backgroundView)! = UIImageView(image: UIImage(named: "CardBack")!)
                                    newImgView0.removeFromSuperview()
                                }
                            )
                            self.card2dArr[compareArr[0].row][compareArr[0].column].isFlipped = false
                            
                            let indexPath1 = NSIndexPath(forRow: compareArr[1].column, inSection: compareArr[1].row)
                            let cell1 = collectionView.cellForItemAtIndexPath(indexPath1)!
                            let newImgView1 = UIImageView(image: UIImage(named: "CardBack")!)
                            newImgView1.frame = ((cell1.backgroundView)!).frame
                            UIView.transitionFromView((cell1.backgroundView)!, toView:newImgView1, duration: self.kFlipDuration, options: UIViewAnimationOptions.TransitionFlipFromRight, completion:
                                {(Bool) in
                                    (cell1.backgroundView)! = UIImageView(image: UIImage(named: "CardBack")!)
                                    newImgView1.removeFromSuperview()
                                }
                            )
                            self.card2dArr[compareArr[1].row][compareArr[1].column].isFlipped = false
                        }
                        
                        //println("Card1 row:\(compareArr[0].row) col:\(compareArr[0].column)")
                        //println("Card2 row:\(compareArr[1].row) col:\(compareArr[1].column)")
                        /*var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(self.kMatchDisappearDuration*(1.1))) * Double(NSEC_PER_SEC)))
                        dispatch_after(
                            dispatchTime, dispatch_get_main_queue(),
                            {*/
                                self.flippedCnt = 0
                                //self.collectionView.userInteractionEnabled = true
                                //println("enabled collectionView userinteraction")
                            /*}
                        )*/
                    }
                )
            }
        }
        else
        {
            //println("tried to flip too many flippedCnt=\(self.flippedCnt)")
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
    
    @objc func newGameButtonMethod(sender : THButton, event : UIEvent) {
        // touchupinside must have some built in apple determined finger fudge factor to account for finger fatness so I'll just use what they came up with even though technically the precise press can be somewhat outside the sender's frame and still call this
        collectionView.userInteractionEnabled = false
        // activateCardArr completion of peek reenabled collectionView
        setupCardArr()
        activateCardArr()
        dismissInfo()
    }
    
    func exitButtonMethod(sender : THButton, event : UIEvent) {
        //NSLog("exit button pressed method")
        
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
        app?.animateToViewController(ViewControllerEnum.TitleScreen, srcVCEnum: ViewControllerEnum.CardMatching)
        
        /*var viewCast : UIView = sender as UIView
        var touch : UITouch = event.allTouches()!.first as! UITouch
        var location : CGPoint = touch.locationInView(viewCast)
        
        if (!CGRectContainsPoint(sender.bounds, location)) {
        NSLog("out of bounds")
        } else {
        NSLog("in bounds")
        }*/
    }
    
    func dismissInfo()
    {
        scaleOutRemoveView(titleView, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(completeView, duration: 0.5, delay: 0.0)
        scaleOutRemoveView(newGameButton!, duration: 0.5, delay: 0.25)
        scaleOutRemoveView(exitButton!, duration: 0.5, delay: 0.5)
    }
    
    func initTitleLabels()
    {
        title1Label.text = "Card Match"
        title1Label.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        title1Label.font = UIFont(name: "Super Mario 256", size: 45.0)
        title1Label.font = title1Label.font.fontWithSize(getFontSizeToFitFrameOfLabel(title1Label)-5.0)
        title1Label.frame.size.height = title1Label.font.pointSize*1.3
        title1Label.textAlignment = NSTextAlignment.Center
        title1Label.textColor = UIColor.yellowColor()
        title1Label.strokeSize = (3.0/320.0)*title1Label.frame.size.width
        title1Label.strokeColor = UIColor.blackColor()
        title1Label.shadowOffset = CGSizeMake(title1Label.strokeSize, title1Label.strokeSize)
        title1Label.shadowColor = UIColor.blackColor()
        title1Label.shadowBlur = (1.0/320.0)*title1Label.frame.size.width
        title1Label.layer.anchorPoint = CGPointMake(0.5, 0.5)
        title1Label.layer.shouldRasterize = true
        
        /*title2Label.text = "Match"
        title2Label.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        title2Label.font = UIFont(name: "Super Mario 256", size: 45.0)
        title2Label.font = title2Label.font.fontWithSize(getFontSizeToFitFrameOfLabel(title2Label)-5.0)
        title2Label.frame.size.height = title2Label.font.pointSize*1.3
        title2Label.frame.origin.y += title1Label.frame.size.height
        title2Label.textAlignment = NSTextAlignment.Center
        title2Label.textColor = UIColor.yellowColor()
        title2Label.strokeSize = (3.0/320.0)*title2Label.frame.size.width
        title2Label.strokeColor = UIColor.blackColor()
        title2Label.shadowOffset = CGSizeMake(title2Label.strokeSize, title2Label.strokeSize)
        title2Label.shadowColor = UIColor.blackColor()
        title2Label.shadowBlur = (1.0/320.0)*title2Label.frame.size.width
        title2Label.layer.anchorPoint = CGPointMake(0.5, 0.5)
        title2Label.layer.shouldRasterize = true
        
        titleView = UIView(frame: CGRect(x: 0.0, y: view.frame.size.height*(1.0/4.0), width: view.frame.size.width, height: title1Label.frame.size.height+title2Label.frame.size.height))
        titleView.addSubview(title1Label)
        titleView.addSubview(title2Label)*/
        titleView = UIView(frame: CGRect(x: 0.0, y: view.frame.size.height*(1.0/3.0), width: view.frame.size.width, height: title1Label.frame.size.height))
        titleView.addSubview(title1Label)
    }
    
    func initRoundCompleteLabels()
    {
        completeLabel.text = "Complete!"
        completeLabel.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        completeLabel.font = UIFont(name: "Super Mario 256", size: 45.0)
        completeLabel.font = completeLabel.font.fontWithSize(getFontSizeToFitFrameOfLabel(completeLabel)-5.0)
        completeLabel.frame.size.height = completeLabel.font.pointSize*1.3
        completeLabel.textAlignment = NSTextAlignment.Center
        completeLabel.textColor = UIColor.yellowColor()
        completeLabel.strokeSize = (3.0/320.0)*completeLabel.frame.size.width
        completeLabel.strokeColor = UIColor.blackColor()
        completeLabel.shadowOffset = CGSizeMake(completeLabel.strokeSize, completeLabel.strokeSize)
        completeLabel.shadowColor = UIColor.blackColor()
        completeLabel.shadowBlur = (1.0/320.0)*completeLabel.frame.size.width
        completeLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        completeLabel.layer.shouldRasterize = true
        //completeLabel.backgroundColor = UIColor.redColor()
        //println("completed font size is \(completeLabel.font.pointSize)")
        
        elapsedTimeLabel.text = NSString(format: "Time: %.0f seconds", elapsedTime) as? String
        elapsedTimeLabel.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        elapsedTimeLabel.font = UIFont(name: "Super Mario 256", size: 25.0)
        elapsedTimeLabel.font = elapsedTimeLabel.font.fontWithSize(getFontSizeToFitFrameOfLabel(elapsedTimeLabel)-10.0)
        elapsedTimeLabel.frame.size.height = elapsedTimeLabel.font.pointSize*1.3
        elapsedTimeLabel.frame.origin.y += completeLabel.frame.size.height
        elapsedTimeLabel.textAlignment = NSTextAlignment.Center
        elapsedTimeLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        elapsedTimeLabel.textColor = UIColor.yellowColor()
        elapsedTimeLabel.strokeSize = (1.5/320.0)*elapsedTimeLabel.frame.size.width
        elapsedTimeLabel.strokeColor = UIColor.blackColor()
        elapsedTimeLabel.shadowOffset = CGSizeMake(elapsedTimeLabel.strokeSize, elapsedTimeLabel.strokeSize)
        elapsedTimeLabel.shadowColor = UIColor.blackColor()
        elapsedTimeLabel.shadowBlur = (1.0/320.0)*elapsedTimeLabel.frame.size.width
        elapsedTimeLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        elapsedTimeLabel.layer.shouldRasterize = true
        //elapsedTimeLabel.backgroundColor = UIColor.orangeColor()
        //println("completed elapsed time size is \(elapsedTimeLabel.font.pointSize)")
        
        if (numMoves == 8)
        {
            numMovesLabel.text = NSString(format: "Perfect! %d moves", numMoves) as? String
        }
        else
        {
            numMovesLabel.text = NSString(format: "%d moves         ", numMoves) as? String
        }
        numMovesLabel.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        numMovesLabel.font = UIFont(name: "Super Mario 256", size: 25.0)
        numMovesLabel.font = numMovesLabel.font.fontWithSize(getFontSizeToFitFrameOfLabel(numMovesLabel)-5.0)
        numMovesLabel.frame.size.height = numMovesLabel.font.pointSize*1.3
        numMovesLabel.frame.origin.y += completeLabel.frame.size.height + elapsedTimeLabel.frame.size.height
        numMovesLabel.textAlignment = NSTextAlignment.Center
        numMovesLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        numMovesLabel.textColor = UIColor.yellowColor()
        numMovesLabel.strokeSize = (1.5/320.0)*numMovesLabel.frame.size.width
        numMovesLabel.strokeColor = UIColor.blackColor()
        numMovesLabel.shadowOffset = CGSizeMake(numMovesLabel.strokeSize, numMovesLabel.strokeSize)
        numMovesLabel.shadowColor = UIColor.blackColor()
        numMovesLabel.shadowBlur = (1.0/320.0)*numMovesLabel.frame.size.width
        numMovesLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        numMovesLabel.layer.shouldRasterize = true
        
        completeView = UIView(frame: CGRect(x: 0.0, y: view.frame.size.height*(1.0/4.0), width: view.frame.size.width, height: completeLabel.frame.size.height+elapsedTimeLabel.frame.size.height+numMovesLabel.frame.size.height))
        completeView.addSubview(completeLabel)
        completeView.addSubview(elapsedTimeLabel)
        completeView.addSubview(numMovesLabel)
    }
    
    func titleMethod()
    {
        view.addSubview(newGameButton!)
        view.addSubview(exitButton!)
        bounceInView(newGameButton!, duration:CGFloat(0.5), delay:CGFloat(0.5))
        bounceInView(exitButton!, duration:CGFloat(0.5), delay:CGFloat(0.5))
        
        view.addSubview(titleView)
        bounceInView(titleView!, duration:CGFloat(0.5), delay:CGFloat(0.5))
    }
    
    func roundCompleteMethod() {
        self.view.addSubview(newGameButton!)
        self.view.addSubview(exitButton!)
        bounceInView(newGameButton!, duration:CGFloat(0.5), delay:CGFloat(1.7))
        bounceInView(exitButton!, duration:CGFloat(0.5), delay:CGFloat(1.7))
        
        //println("Complete!")
        let endTime = NSDate();
        let elapsedTime: Double = endTime.timeIntervalSinceDate(self.startTime);
        elapsedTimeLabel.text = NSString(format: "Time: %.0f seconds", elapsedTime) as? String
        //println("Time: \(elapsedTime)")
        numMovesLabel.text = NSString(format: "%d moves         ", numMoves) as? String
        
        view.addSubview(completeView)
        
        let confettiTime = Float(CGFloat(kConfetti4STime/480.0)*CGFloat(self.view.frame.size.height))
        
        spin3BounceView(completeView, duration:CGFloat(confettiTime*0.9))
        
        let confettiEmitterCell : CAEmitterCell = CAEmitterCell()
        let confettiCellUIImage : UIImage = UIImage(named:"ConfettiCell")!
        confettiEmitterCell.contents = confettiCellUIImage.CGImage;
        
        let confettiEmitterLayer = CAEmitterLayer()
        confettiEmitterLayer.emitterPosition = CGPointMake(self.view.frame.origin.x + (self.view.frame.size.width/2), self.view.frame.origin.y - confettiCellUIImage.size.height)
        confettiEmitterLayer.emitterSize = CGSizeMake(self.view.frame.size.width, 0.0)
        confettiEmitterLayer.emitterShape = kCAEmitterLayerLine
        
        confettiEmitterCell.name = "ConfettiCell"
        
        confettiEmitterCell.birthRate = 50
        confettiEmitterCell.lifetime = confettiTime
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
        
        confettiEmitterCell.velocity = CGFloat((200/480.0)*self.view.frame.size.height)
        confettiEmitterCell.velocityRange = 0
        confettiEmitterCell.yAcceleration = CGFloat((150.0/480.0)*self.view.frame.size.height)
        confettiEmitterCell.emissionLongitude = π
        confettiEmitterCell.emissionRange = π/4
        
        confettiEmitterCell.scale = (0.4/320.0)*self.view.frame.size.width
        confettiEmitterCell.scaleSpeed = 0.0
        confettiEmitterCell.scaleRange = 0.1
        
        confettiEmitterLayer.emitterCells = [confettiEmitterCell]
        
        confettiEmitterLayer.beginTime = CACurrentMediaTime()
        view.layer.addSublayer(confettiEmitterLayer)
        
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(confettiTime)) * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
            {
                confettiEmitterLayer.lifetime = 0.0
                
            }
        )
        
        dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64((NSTimeInterval(2*confettiTime)) * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(),
            {
                confettiEmitterLayer.removeFromSuperlayer()
            }
        )
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        //println("DeselectedCell at row:\(indexPath.section) column:\(indexPath.row)")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    deinit {
        print("MemoryGame ViewController deinit")
    }
}
