//
//  ViewController.swift
//  CircleDemo
//
//  Created by mr.zhou on 2018/10/3.
//  Copyright © 2018 mr.zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var offset: CGFloat! = 0.0
    var link: CADisplayLink!
    var label: UILabel!
    let center = CGPoint(x: 175, y: 300)
    let outOffset = CGFloat((Double.pi / 2.0) / 100 * 5)
    let inOffset = CGFloat((Double.pi / 2.0) / 70 * 5)
    var layer: TestLayer!
    var layer1: TestLayer!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        layer = TestLayer(from: CGFloat(Double.pi * 3.0 / 2.0), end: CGFloat(Double.pi * 3.0 / 2.0), center: center, color: .red)
        view.layer.addSublayer(layer)
        layer.grow(clockwise: true, angle: CGFloat(Double.pi * 4.0 / 2.0))
        
    }
    
    
    @IBAction func animate(_ sender: Any) {

        layer1 = TestLayer(from: CGFloat(Double.pi * 3.0 / 2.0) , end: CGFloat(Double.pi * 3.0 / 2.0), center: center, color: .yellow)
        view.layer.addSublayer(layer1)
//        layer1.moveAnimate(closewise: false, angle: CGFloat(Double.pi))
        layer1.grow(clockwise: false, angle: CGFloat(Double.pi))
        layer.shrink(closewise: false, angle: CGFloat(Double.pi))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let layer2 = TestLayer(from: CGFloat(Double.pi * 3.0 / 2.0) , end: CGFloat(Double.pi * 3.0 / 2.0), center: self.center, color: .blue)
            let angle = CGFloat(Double.pi * 3.0 / 7.0)
            self.view.layer.addSublayer(layer2)
            layer2.grow(clockwise: false, angle: angle)
            
            self.layer1.moveAnimate(closewise: false, angle: angle)
            self.layer.shrink(closewise: false, angle: angle)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let layer3 = TestLayer(from: CGFloat(Double.pi * 3.0 / 2.0) , end: CGFloat(Double.pi * 3.0 / 2.0), center: self.center, color: .blue)
                let angle = CGFloat(Double.pi * 4.0 / 7.0)
                self.view.layer.addSublayer(layer3)
                layer3.grow(clockwise: false, angle: angle)
                layer2.moveAnimate(closewise: false, angle: angle)
                self.layer1.shrink(closewise: false, angle: angle/2.0)
                self.layer1.moveAnimate(closewise: false, angle: angle/2.0)
                self.layer.shrink(closewise: false, angle: angle/2.0)
            }
            

        }

    }
}

