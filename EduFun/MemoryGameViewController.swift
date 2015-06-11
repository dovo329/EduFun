//
//  MemoryGameViewController.swift
//  CollectionViewTest
//
//  Created by Douglas Voss on 6/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class MemoryGameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let numRows : Int = 3
    let numColumns : Int = 3
    let imageNameArr : [String] = ["BearCard", "CarCard", "FlowerCard", "IceCreamCard","RainbowCard", "StarCard"]
    let kCardMinMargin : CGFloat = 5.0
    var collectionView: UICollectionView?
    let cardImg : UIImage = UIImage(named: "IceCreamCard")!
    let bgImgView : UIImageView = UIImageView(image: UIImage(named: "SkyGrassBackground"))
    var card2dArr = Array<Array<Card>>()
    let kCellReuseId : String = "cell.reuse.id"
    
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

                var iterationCnt = 0
                var imageName : String
                // select an imageName that hasn't been used twice yet
                do {
                    imageName = imageNameArr[Int(arc4random_uniform(UInt32(imageNameArr.count)))]
                    iterationCnt++
                    if (iterationCnt > 100)
                    {
                        fatalError("Failed to find another card to use after 100 random tries")
                    }
                } while cardCountDict[imageName] >= 2
                
                card.imageName = imageName
                cardCountDict[card.imageName!]!++
                println("cardCountDict[\(card.imageName)]==\(cardCountDict[card.imageName!]!)")
                    
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
        
        println("storedCell at row:\(indexPath.section) column:\(indexPath.row) isFlipped:\(card.isFlipped) imageNames:\(card.imageName)")

        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        var card : Card = card2dArr[indexPath.section][indexPath.row]
        println("selectedCell at row:\(indexPath.section) column:\(indexPath.row) isFlipped:\(card.isFlipped)")
        
        var newImgView : UIImageView?
        if (card.isFlipped)
        {
            newImgView = UIImageView(image: UIImage(named: "CardBack")!)
        } else {
            newImgView = UIImageView(image: UIImage(named: card.imageName!)!)
        }
        newImgView!.frame = ((cell!.backgroundView)!).frame
        UIView.transitionFromView((cell!.backgroundView)!, toView:newImgView!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        ((cell!.backgroundView)!) = newImgView!
        card.isFlipped = !card.isFlipped
        card2dArr[indexPath.section][indexPath.row] = card
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("DeselectedCell at row:\(indexPath.section) column:\(indexPath.row)")
    }
}
