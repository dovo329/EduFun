//
//  MemoryGameViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/9/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

let kCardMargin: CGFloat = 15.0
let kCardWidthToScreen: CGFloat = (1.0/6.0)
let kCardHeightToScreen: CGFloat = (1.0/4.0)

let bgImg: UIImage = UIImage(named: "SkyGrassBackground")!

let imgNameArr: Array = ["BearCard", "StarCard", "FlowerCard", "IceCreamCard", "RainbowCard"]

let cardBackImg : UIImage = UIImage(named: "CardBack")!
let bearImg : UIImage = UIImage(named: "BearCard")!
let starImg : UIImage = UIImage(named: "StarCard")!
let flowerImg : UIImage = UIImage(named: "FlowerCard")!
let iceCreamImg : UIImage = UIImage(named: "IceCreamCard")!
let rainbowImg : UIImage = UIImage(named: "RainbowCard")!

class MemoryGameViewController: UIViewController {
    var bgImgView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImgView = UIImageView(image: bgImg)
        self.view.addSubview(bgImgView!)
        
        var cardWidth  : CGFloat = self.view.frame.size.width / 7.0
        var cardAspectRatio : CGFloat = cardBackImg.size.width/cardBackImg.size.height
        var cardHeight : CGFloat = cardWidth/cardAspectRatio
        
        var NumColumns = 5
        var NumRows = 3
        var card2dArr = Array<Array<Card>>()
        
        for row in 0...(NumRows-1) {
            var columnArray = Array<Card>()
            for column in 0...(NumColumns-1) {
                var randInput : UInt32 = UInt32(imgNameArr.count-1)
                var randIndex : UInt32 = arc4random_uniform(randInput)
                var imgNameStr : String = imgNameArr[Int(randIndex)]
                var randIsFlipped : UInt32 = arc4random_uniform(2)
                var randIsFlippedBool : Bool
                if (randIsFlipped != 0) { randIsFlippedBool = true } else {randIsFlippedBool = false }
                
                var newCard : Card = Card(imgName:imgNameStr, isFlippedBool:randIsFlippedBool, row:CGFloat(row), column:CGFloat(column), width:cardWidth, height:cardHeight)
                
                columnArray.append(newCard)
                
                newCard.addTarget(self, action:"buttonMethod:", forControlEvents: .TouchUpInside)
            }
            card2dArr.append(columnArray)
        }
        
        for nrow in 0...(card2dArr.count-1) {
            for ncolumn in 0...(card2dArr[nrow].count-1) {
                self.view.addSubview(card2dArr[nrow][ncolumn])
            }
        }
        
        self.bgImgViewConstraints()
    }

    func Array2dDemo2 () {
        var NumColumns = 5
        var NumRows = 3
        var array = Array<Array<Int>>()
        var value = 1
        
        for row in 1...NumRows {
            var columnArray = Array<Int>()
            for column in 1...NumColumns {
                columnArray.append(value++)
            }
            array.append(columnArray)
        }
        
        println("array \(array)")
    }
    
    func Array2dDemo () {
        var array = Array(count:3, repeatedValue:Array(count:3, repeatedValue:Double()))
        
        array[0][0] = 1
        array[1][0] = 2
        array[2][0] = 3
        array[0][1] = 4
        array[1][1] = 5
        array[2][1] = 6
        array[0][2] = 7
        array[1][2] = 8
        array[2][2] = 9
        
        for column in 0...2 {
            for row in 0...2 {
            println("column: \(column) row: \(row) value:\(array[column][row])")
            }
        }
    }
    
    func buttonMethod(sender: UIButton!) {
        var card : Card = (sender as? Card)!
        println("button was pressed with row: \(card.row) column: \(card.column)")
        card.isFlipped = !card.isFlipped
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bgImgViewConstraints () {
        self.bgImgView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let topConstraint =
        NSLayoutConstraint(
            item: self.bgImgView!,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.topLayoutGuide,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0);
        self.view.addConstraint(topConstraint);
        
        let bottomConstraint =
        NSLayoutConstraint(
            item: self.bgImgView!,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0);
        self.view.addConstraint(bottomConstraint);
        
        let leftConstraint =
        NSLayoutConstraint(
            item: self.bgImgView!,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Left,
            multiplier: 1.0,
            constant: 0.0);
        self.view.addConstraint(leftConstraint);
        
        let rightConstraint =
        NSLayoutConstraint(
            item: self.bgImgView!,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .Right,
            multiplier: 1.0,
            constant: 0.0);
        self.view.addConstraint(rightConstraint);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
