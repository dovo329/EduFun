//
//  MemoryGameViewController.swift
//  CollectionViewTest
//
//  Created by Douglas Voss on 6/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class MemoryGameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let numRows : Int = 2
    let numColumns : Int = 2
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(bgImgView)
      
        self.bgImgView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let viewsDictionary = ["bg": self.bgImgView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bg]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bg]|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
        
        /*self.view.addConstraint(
            NSLayoutConstraint(
                item: self.bgImgView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0));
        
        self.view.addConstraint(
            NSLayoutConstraint(
                item: self.bgImgView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0));
        
        self.view.addConstraint(
            NSLayoutConstraint(
                item: self.bgImgView,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Left,
                multiplier: 1.0,
                constant: 0.0));
        
        self.view.addConstraint(
            NSLayoutConstraint(
                item: self.bgImgView,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Right,
                multiplier: 1.0,
                constant: 0.0));*/
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kCardMinMargin, left: kCardMinMargin, bottom: kCardMinMargin, right: kCardMinMargin)
        var aspectRatio : CGFloat = cardImg.size.width/cardImg.size.height
        var width : CGFloat = (CGFloat(self.view.frame.size.width)-(CGFloat(numColumns+1)*kCardMinMargin))/CGFloat(numColumns)
        var height : CGFloat = width/aspectRatio
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = kCardMinMargin
        layout.minimumLineSpacing = kCardMinMargin

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
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
            self.card2dArr.append(columnArr)
        }
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView!)
        self.collectionViewConstraints()
    }

    func collectionViewConstraints() {
        collectionView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        let topConstraint =
        NSLayoutConstraint(
            item: self.collectionView!,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.topLayoutGuide,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0);
        self.view.addConstraint(topConstraint);
        
        let bottomConstraint =
        NSLayoutConstraint(
            item: self.collectionView!,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0);
        self.view.addConstraint(bottomConstraint);
        
        let leftConstraint =
        NSLayoutConstraint(
            item: self.collectionView!,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0.0);
        self.view.addConstraint(leftConstraint);
        
        let rightConstraint =
        NSLayoutConstraint(
            item: self.collectionView!,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0.0);
        self.view.addConstraint(rightConstraint);
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
        
        var card : Card = self.card2dArr[indexPath.section][indexPath.row]

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
                    UIView.transitionFromView((cell!.backgroundView)!, toView:newImgView!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
                    ((cell!.backgroundView)!) = newImgView!
                    card2dArr[indexPath.section][indexPath.row].isFlipped = true
                } else {
                    fatalError("tried to flip a card that was already flipped")
                }
                
                if (flippedCnt >= 2)
                {
                    var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.1 * Double(NSEC_PER_SEC)))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(),
                        {
                            var compareArr = [Card]()
                            // check for match if 2 cards have been flipped over
                            println("checkForMatch called")
                            
                            
                            // find all flipped over cards and add them to an array
                            for var row=0; row<self.card2dArr.count; row++
                            {
                                for var column=0; column<self.card2dArr[row].count; column++
                                {
                                    if self.card2dArr[row][column].isFlipped
                                    {
                                        compareArr.append(self.card2dArr[row][column])
                                        println("true isFlipped row=\(row) column=\(column)")
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
                                println("You made a match! Yay!")
                                
                                self.card2dArr[compareArr[0].row][compareArr[0].column].matched = true
                                self.card2dArr[compareArr[0].row][compareArr[0].column].isFlipped = false
                                var indexPath0 = NSIndexPath(forRow: compareArr[0].column, inSection: compareArr[0].row)
                                var cell0 = collectionView.cellForItemAtIndexPath(indexPath0)
                                var blankView0 = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                                UIView.transitionFromView((cell0!.backgroundView)!, toView:blankView0, duration: 1, options: UIViewAnimationOptions.TransitionCurlUp, completion: nil)
                                
                                self.card2dArr[compareArr[1].row][compareArr[1].column].matched = true
                                self.card2dArr[compareArr[1].row][compareArr[1].column].isFlipped = false
                                var indexPath1 = NSIndexPath(forRow: compareArr[1].column, inSection: compareArr[1].row)
                                var cell1 = collectionView.cellForItemAtIndexPath(indexPath1)
                                var blankView1 = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                                UIView.transitionFromView((cell1!.backgroundView)!, toView:blankView1, duration: 1, options: UIViewAnimationOptions.TransitionCurlUp, completion: nil)
                                
                                // check for all matches
                                if self.allMatched()
                                {
                                    println("Complete!")
                                    let endTime = NSDate();
                                    let elapsedTime: Double = endTime.timeIntervalSinceDate(self.startTime);
                                    println("Elapsed time: \(elapsedTime) seconds");
                                }
                            } else {
                                println("Nope, no match for you.")
                                
                                var indexPath0 = NSIndexPath(forRow: compareArr[0].column, inSection: compareArr[0].row)
                                var cell0 = collectionView.cellForItemAtIndexPath(indexPath0)
                                var newImgView0 = UIImageView(image: UIImage(named: "CardBack")!)
                                newImgView0.frame = ((cell0!.backgroundView)!).frame
                                UIView.transitionFromView((cell0!.backgroundView)!, toView:newImgView0, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
                                ((cell0!.backgroundView)!) = newImgView0
                                self.card2dArr[compareArr[0].row][compareArr[0].column].isFlipped = false
                                
                                var indexPath1 = NSIndexPath(forRow: compareArr[1].column, inSection: compareArr[1].row)
                                var cell1 = collectionView.cellForItemAtIndexPath(indexPath1)
                                var newImgView1 = UIImageView(image: UIImage(named: "CardBack")!)
                                newImgView1.frame = ((cell1!.backgroundView)!).frame
                                UIView.transitionFromView((cell1!.backgroundView)!, toView:newImgView1, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
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
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        //println("DeselectedCell at row:\(indexPath.section) column:\(indexPath.row)")
    }
}
