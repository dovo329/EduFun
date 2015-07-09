//
//  MrSkunkMapView.swift
//  EduFun
//
//  Created by Douglas Voss on 7/9/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

let kNumMapsPerRow = 4
let kNumLevels = 3

class MrSkunkMapView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    let kMapCellId = "map.cell.id"
    
    var collectionView : UICollectionView!
    var highestCompletedLevelNum : Int!
    
    init(frame: CGRect, highestCompletedLevelNum: Int) {
        super.init(frame: frame)
        let kCellWidth : CGFloat = frame.size.width*(8.0/37.0)
        let kCellHeight : CGFloat = frame.size.height*(8.0/37.0)
        let kXMargin : CGFloat = kCellWidth/8.0
        let kYMargin : CGFloat = kCellHeight/8.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kYMargin, left: kXMargin, bottom: kYMargin, right: kXMargin)
        
        layout.itemSize = CGSize(width: kCellWidth, height: kCellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.highestCompletedLevelNum = highestCompletedLevelNum
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.userInteractionEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: kMapCellId)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.scrollEnabled = false
        
        addSubview(collectionView)
    }
    
    required convenience init(coder: NSCoder) {
        fatalError("init coder not implemented")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(kMapCellId, forIndexPath: indexPath) as? UICollectionViewCell

        // cell is registered so don't need to do this
        /*if cell == nil
        {
            cell = UICollectionViewCell()
        }*/
        
        var totIndex = (indexPath.section*kNumMapsPerRow)+indexPath.row
        
        if totIndex < kNumLevels
        {
            cell!.backgroundView = UIImageView(image: UIImage(named: "MapBlank"))
            if totIndex > highestCompletedLevelNum
            {
                var lockView = UIImageView(image: UIImage(named: "Lock")!)
                lockView.frame = cell!.frame
                lockView.frame.size.width *= 0.5
                lockView.frame.size.height  *= 0.5
                lockView.frame.origin.x = (cell!.frame.size.width-lockView.frame.size.width)/2.0
                lockView.frame.origin.y = (cell!.frame.size.height-lockView.frame.size.height)/2.0
                cell!.contentView.addSubview(lockView)
            }
            else
            {
                var levelNumLabel = THLabel()
                levelNumLabel.frame = cell!.frame
                levelNumLabel.frame.size.width *= 0.8
                levelNumLabel.frame.size.height  *= 0.8
                levelNumLabel.frame.origin.x = (cell!.frame.size.width-levelNumLabel.frame.size.width)/2.0
                levelNumLabel.frame.origin.y = (cell!.frame.size.height-levelNumLabel.frame.size.height)/2.0
                levelNumLabel.frame.origin.y += levelNumLabel.frame.size.height*0.07 // offset due to space under font due to the way font is made it's vertically top oriented not vertically centered so all the space is at the bottom so get rid of this offset
                levelNumLabel.text = String(format:"%d", totIndex)
                //levelNumLabel.text = "15"
                levelNumLabel.font = UIFont(name: "Super Mario 256", size: 25.0)
                levelNumLabel.font = levelNumLabel.font.fontWithSize(getFontSizeToFitFrameOfLabel(levelNumLabel)-5.0)
                levelNumLabel.textAlignment = NSTextAlignment.Center
                levelNumLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
                levelNumLabel.textColor = UIColor.yellowColor()
                levelNumLabel.strokeSize = (1.5/320.0)*levelNumLabel.frame.size.width
                levelNumLabel.strokeColor = UIColor.blackColor()
                levelNumLabel.shadowOffset = CGSizeMake(levelNumLabel.strokeSize, levelNumLabel.strokeSize)
                levelNumLabel.shadowColor = UIColor.blackColor()
                levelNumLabel.shadowBlur = (1.0/320.0)*levelNumLabel.frame.size.width
                levelNumLabel.layer.shouldRasterize = true
                
                
                    
                cell!.contentView.addSubview(levelNumLabel)
            }
        }
        else
        {
            cell!.backgroundView = UIView() // blank view
        }
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kNumMapsPerRow
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Int(round(CGFloat(kNumLevels)/CGFloat(kNumMapsPerRow)))
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
