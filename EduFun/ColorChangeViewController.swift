//
//  ColorChangeViewController.swift
//  EduFun
//
//  Created by Douglas Voss on 6/13/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

import UIKit

class ColorChangeViewController: UIViewController {
    var redImg : UIImageView = UIImageView(image: UIImage(named: "redOnlySmall"))
    var blueImg : UIImageView = UIImageView(image: UIImage(named: "blueOnlySmall"))
    
    var toggle : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //var testView = ColoringView(frame:self.view.frame)
        //self.view.addSubview(testView)
        var testView = OBShapedView(frame: self.view.frame)
        self.view.addSubview(testView)
    }
        //var testButton : OBShapedButton = OBShapedButton(frame:self.view.frame)
        //testButton.setImage(UIImage(named:"redOnlySmall"), forState: .Normal)
        //testButton.setImage(UIImage(named:"blueOnlySmall"), forState: .Highlighted)
        
        //self.view.addSubview(testButton)
    //}
        /*redImg.frame = self.view.frame
        redImg.image = redImg.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        blueImg.frame = self.view.frame
        blueImg.image = blueImg.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        self.view.addSubview(redImg)
        self.view.addSubview(blueImg)
    }*/

    /*override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        NSLog("touchesEnded called")
        if (toggle)
        {
            redImg.tintColor = UIColor.yellowColor()
            //blueImg.tintColor = UIColor.brownColor()
        } else {
            redImg.tintColor = UIColor.purpleColor()
            //blueImg.tintColor = UIColor.orangeColor()
        }
        toggle = !toggle
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
