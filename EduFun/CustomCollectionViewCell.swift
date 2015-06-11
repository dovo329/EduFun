//
//  CustomCollectionViewCell.swift
//  CollectionViewTest
//
//  Created by Douglas Voss on 6/10/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var cardView : UIView?
    
    override init(frame: CGRect) {
        self.cardView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height:frame.size.height))
        
        super.init(frame: frame)

        contentView.addSubview(self.cardView!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
