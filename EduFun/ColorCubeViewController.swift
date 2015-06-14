//
//  ColorCubeViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ColorCubeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var testView : ColorCubeView = ColorCubeView()
        let UIImg = UIImage(named:"redOnlySmall")!
        testView.inputCGImg = UIImg.CGImage
        testView.frame = self.view.frame
        self.view.addSubview(testView)
    }
}
