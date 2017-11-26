//
//  MrSkunkMapView.swift
//  EduFun
//
//  Created by Douglas Voss on 7/9/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

let kNumMapsPerRow = 4
let kNumLevels = 7

protocol MrSkunkMapViewDelegate {
    func mapLevelSelected(level: Int)
}

class MrSkunkMapView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    var delegate : MrSkunkMapViewDelegate! = nil
    
    let kMapCellId = "map.cell.id"
    
    var collectionView : UICollectionView!
    var highestCompletedLevelNum : Int!
    
    init(frame: CGRect, highestCompletedLevelNum: Int) {
        super.init(frame: frame)
        // following math based on interCell spacing (and margin) of Cell Width or Height divided by 8
        let numSections : Int = Int(round(CGFloat(kNumLevels)/CGFloat(kNumMapsPerRow)))
        let kCellWidth : CGFloat = frame.size.width*(8.0/((9.0*CGFloat(kNumMapsPerRow)) + 1.0))
        let kCellHeight : CGFloat = frame.size.height*(8.0/((9.0*CGFloat(numSections)) + 1.0))
        let kXMargin : CGFloat = kCellWidth/8.0
        let kYMargin : CGFloat = kCellHeight/8.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kYMargin, left: kXMargin, bottom: kYMargin, right: kXMargin)
        
        layout.itemSize = CGSize(width: kCellWidth, height: kCellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.highestCompletedLevelNum = highestCompletedLevelNum
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), collectionViewLayout: layout)
        print("self.frame=\(self.frame) collectionView.frame=\(collectionView.frame)")
        collectionView.isUserInteractionEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kMapCellId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        
        addSubview(collectionView)
        //collectionView.backgroundColor = UIColor.purpleColor()
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init coder not implemented")
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMapCellId, for: indexPath) as UICollectionViewCell

        // cell is registered so don't need to do this
        /*if cell == nil
        {
            cell = UICollectionViewCell()
        }*/
        
        let totIndex = (indexPath.section*kNumMapsPerRow)+indexPath.row
        let levelNum = totIndex+1
        
        //cell!.backgroundColor = UIColor.greenColor()
        
        if levelNum <= kNumLevels
        {
            cell.backgroundView = UIImageView(image: UIImage(named: "MapBlank"))
            // +1 because current level should be selected via the map
            if levelNum > highestCompletedLevelNum + 1
            {
                let lockView = UIImageView(image: UIImage(named: "Lock")!)
                /*lockView.frame = cell!.frame
                lockView.frame.size.width *= 0.5
                lockView.frame.size.height  *= 0.5
                lockView.frame.origin.x = (cell!.frame.size.width-lockView.frame.size.width)/2.0
                lockView.frame.origin.y = (cell!.frame.size.height-lockView.frame.size.height)/2.0*/
                lockView.frame = makeCenteredRectWithScale(scale: 0.5, ofFrame: cell.frame)
                lockView.frame.origin.x -= lockView.frame.size.width*0.08
                cell.contentView.addSubview(lockView)
            }
            else
            {
                let levelNumLabel = THLabel()
                /*levelNumLabel.frame = cell!.frame
                levelNumLabel.frame.size.width *= 0.8
                levelNumLabel.frame.size.height  *= 0.8
                levelNumLabel.frame.origin.x = (cell!.frame.size.width-levelNumLabel.frame.size.width)/2.0
                levelNumLabel.frame.origin.y = (cell!.frame.size.height-levelNumLabel.frame.size.height)/2.0*/
                levelNumLabel.frame = makeCenteredRectWithScale(scale: 0.7, ofFrame: cell.frame)
                levelNumLabel.frame.origin.x -= levelNumLabel.frame.size.width*0.08 // shift left a bit since map is curled to the left to make it look centered on the curled map
                levelNumLabel.frame.origin.y += levelNumLabel.frame.size.height*0.08 // offset due to space under font due to the way font is made it's vertically top oriented not vertically centered so all the space is at the bottom so get rid of this offset
                levelNumLabel.text = String(format:"%d", totIndex+1)
                //levelNumLabel.text = "15"
                levelNumLabel.font = UIFont(name: "Super Mario 256", size: 25.0)
                levelNumLabel.font = levelNumLabel.font.withSize(getFontSizeToFitFrameOfLabel(label: levelNumLabel)-5.0)
                levelNumLabel.textAlignment = NSTextAlignment.center
                levelNumLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                levelNumLabel.textColor = UIColor.yellow
                levelNumLabel.strokeSize = (1.5/320.0)*levelNumLabel.frame.size.width
                levelNumLabel.strokeColor = UIColor.black
                levelNumLabel.shadowOffset = CGSize(width: levelNumLabel.strokeSize, height: levelNumLabel.strokeSize)
                levelNumLabel.shadowColor = UIColor.black
                levelNumLabel.shadowBlur = (1.0/320.0)*levelNumLabel.frame.size.width
                levelNumLabel.layer.shouldRasterize = true
                
                
                    
                cell.contentView.addSubview(levelNumLabel)
            }
        }
        else
        {
            cell.backgroundView = UIView() // blank view
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kNumMapsPerRow
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        let retVal = Int(round(CGFloat(kNumLevels)/CGFloat(kNumMapsPerRow)))
        return retVal
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let totIndex = (indexPath.section*kNumMapsPerRow) + indexPath.row
        let level = totIndex + 1
        
        // +1 because current level they are on is the highest completed level + 1
        if (level <= highestCompletedLevelNum+1)
        {
            delegate.mapLevelSelected(level: level)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
