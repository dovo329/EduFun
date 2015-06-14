//
//  ColorCubeViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ColorCubeViewController: UIViewController {

    var testView : ColorCubeView = ColorCubeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let UIImg = UIImage(named:"TestColorShape")!
        testView.inputCGImg = UIImg.CGImage
        testView.toggle = false
        testView.frame = self.view.frame
        self.view.addSubview(testView)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        NSLog("toggle")
        self.testView.toggle = !self.testView.toggle
        self.testView.setNeedsDisplay()
    }
}
