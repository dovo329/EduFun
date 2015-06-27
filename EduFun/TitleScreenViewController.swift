//
//  TitleScreenViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/26/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit
import QuartzCore

class TitleScreenViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{

    var titleLabel : THLabel!
    let kNumRows : Int = 2
    let kNumColumns : Int = 2
    let kCellReuseId : String = "title.screen.cell.reuse.id"
    var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundGradient()
        setupTitleLabel()
        setupCollectionView()
    }

    func setupBackgroundGradient()
    {
        var bgGradLayer = CAGradientLayer()
        bgGradLayer.frame = view.bounds
        bgGradLayer.colors = [
            cgColorForRed(255.0, green:255.0, blue:255.0),
            cgColorForRed(255.0, green:224.0, blue:224.0),
            cgColorForRed(255.0, green:216.0, blue:173.0),
            cgColorForRed(255.0, green:255.0, blue:167.0),
            cgColorForRed(152.0, green:255.0, blue:152.0),
            cgColorForRed(162.0, green:255.0, blue:255.0)
        ]
        bgGradLayer.startPoint = CGPoint(x:0.0, y:0.0)
        bgGradLayer.endPoint = CGPoint(x:0.0, y:1.0)
        bgGradLayer.shouldRasterize = true
        view.layer.addSublayer(bgGradLayer)
    }
    
    func setupTitleLabel()
    {
        titleLabel = THLabel()
        titleLabel.text = "Kids Fun!"
        titleLabel.frame = CGRect(x: 0.0, y: 20.0, width: view.frame.size.width, height: view.frame.size.height)
        //titleLabel.font = UIFont(name: "Super Mario 256", size: 300.0)
        titleLabel.font = UIFont(name: "Super Mario 256", size: 45.0)
        titleLabel.font = titleLabel.font.fontWithSize(getFontSizeToFitFrameOfLabel(titleLabel)-6.0)
        //titleLabel.frame.origin.y -= titleLabel.font.pointSize
        println("titleLabel.font.pointSize=\(titleLabel.font.pointSize)")
        titleLabel.frame.size.height = titleLabel.font.pointSize*1.3
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.yellowColor()
        titleLabel.strokeSize = (3.0/320.0)*titleLabel.frame.size.width
        titleLabel.strokeColor = UIColor.blackColor()
        titleLabel.shadowOffset = CGSizeMake(titleLabel.strokeSize, titleLabel.strokeSize)
        titleLabel.shadowColor = UIColor.blackColor()
        titleLabel.shadowBlur = (1.0/320.0)*titleLabel.frame.size.width
        titleLabel.layer.shouldRasterize = true
        titleLabel.layer.anchorPoint = CGPointMake(0.5, 0.5)
        view.addSubview(titleLabel)
        
        bounceInView(titleLabel, duration: 0.5, delay: 0.0)
        
        /*UIView.animateWithDuration(NSTimeInterval(3.0), delay: NSTimeInterval(0.0),
            usingSpringWithDamping: CGFloat(0.4),
            initialSpringVelocity: CGFloat(0.0),
            options: nil,
            animations:
            {(_) -> (Void) in
                self.titleLabel.frame.origin.y = 20.0
            },
            completion:
            {(_) -> (Void) in
                
            }
        )*/
    }
    
    func setupCollectionView()
    {
        let kXMargin : CGFloat = view.frame.size.width*(1/16.0)
        let kYMargin : CGFloat = (view.frame.size.height-(titleLabel.frame.size.height+20.0))*(1/16.0)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kYMargin, left: kXMargin, bottom: 0, right: kXMargin)
        let width = (13.0/32.0)*view.frame.size.width
        let height = (13.0/32.0)*(view.frame.size.height-(titleLabel.frame.size.height+20.0))
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: CGRectMake(0, (titleLabel.frame.size.height+20.0), view.frame.size.width, view.frame.size.height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellReuseId)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.scrollEnabled = false
        
        view.addSubview(collectionView)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundView!.alpha = 0.5
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundView!.alpha = 1.0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kNumColumns
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return kNumRows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuseId, forIndexPath: indexPath) as! UICollectionViewCell
        
        if (indexPath.row == 0) {
            cell.backgroundView = UIImageView(image: UIImage(named: "cardMatchScreenshot")!)
        } else {
            cell.backgroundView = UIImageView(image: UIImage(named: "coloringBookScreenshot")!)
        }
        
        var scale = (view.frame.size.width/320.0)
        
        cell.layer.borderWidth = 4.0*scale
        cell.layer.borderColor = cgColorForRed(70.0, green: 120.0, blue: 255.0)
        cell.layer.cornerRadius = 10.0*scale
        cell.layer.masksToBounds = true
        //cell.layer.shadowColor = UIColor.blackColor().CGColor
        //cell.layer.shadowRadius = 4.0*scale
        //cell.layer.shadowOpacity = 1.0
        //cell.layer.shadowOffset = CGSizeMake(4.0*scale, 4.0*scale)
        
        return cell as UICollectionViewCell
    }
}
