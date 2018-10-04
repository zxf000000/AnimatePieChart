//
//  TestLayer.swift
//  CircleDemo
//
//  Created by mr.zhou on 2018/10/3.
//  Copyright © 2018 mr.zhou. All rights reserved.
//

import UIKit

class TestLayer: CAShapeLayer {
    var from: CGFloat!
    var end: CGFloat!
    let center: CGPoint!
    let color: UIColor!
    private var growEnd: CGFloat!
    private var animateAngle: CGFloat!
    private var closewise: Bool!
    private var growOffset: CGFloat!
    
    private var moveEnd: CGFloat!
    private var moveOffset: CGFloat!
    
    private var shrinkEnd: CGFloat!
    private var shrinkOffset: CGFloat!
    private var isAdd: Bool!
    
    let label1: UILabel!
    private var growLink: CADisplayLink?
    private var moveLink: CADisplayLink?
    private var shrinkLink: CADisplayLink?

    let outOffset = CGFloat((Double.pi / 2.0) / 100.0 * 5.0)
    let inOffset = CGFloat((Double.pi / 2.0) / 70.0 * 5.0)
    let time = 60.0
    init(from: CGFloat, end: CGFloat, center: CGPoint, color: UIColor) {

        self.from = from
        self.end = end
        self.center = center
        self.color = color
        self.growEnd = 0.0
        self.animateAngle = 0.0
        self.closewise = false
        self.label1 = UILabel()
        self.growOffset = 0.0
        self.moveEnd = 0.0
        self.moveOffset = 0.0
        self.shrinkEnd = 0.0
        self.shrinkOffset = 0.0
        self.isAdd = false
        super.init()
        setupLayer()

    }
    
    func setupLayer() {

        if end - from < inOffset * 2 {
            end += CGFloat(Double.pi / 180.0) + inOffset * 2
            self.isAdd = true
        }
        
        self.path = xf_path(With: from, end: end).cgPath
        self.lineWidth = 10
        self.fillColor = color.cgColor
        self.lineCap = .round
        self.lineJoin = .round
        self.strokeColor = color.cgColor
        
        label1.textAlignment = .center
        label1.text = "test";
        label1.center = labelCenter(from: from, end: end)
        label1.textColor = UIColor.black
        label1.bounds = CGRect(x: 0, y: 0, width: 50, height: 15)
        label1.layer.backgroundColor = UIColor.white.cgColor
        addSublayer(label1.layer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func grow(clockwise: Bool, angle: CGFloat) {
        
        self.closewise = clockwise
        self.growEnd = angle

        if (isAdd ) {
            isAdd = false
            end -= inOffset * 2 + CGFloat(Double.pi / 180.0)
            
        }
        growLink = CADisplayLink(target: self, selector: #selector(growAnimate))
        growLink!.add(to: .current, forMode: .common)
        

    }
    
    func moveAnimate(closewise: Bool, angle: CGFloat) {
        self.closewise = closewise
        self.moveEnd = angle
        moveLink = CADisplayLink(target: self, selector: #selector(moveAnimation))
        moveLink!.add(to: .current, forMode: .common)
    }
    
    func shrink(closewise: Bool, angle: CGFloat) {
        self.closewise = closewise
        self.shrinkEnd = angle
        shrinkLink = CADisplayLink(target: self, selector: #selector(shrinkAnimation))
        shrinkLink!.add(to: .current, forMode: .common)
    }
    
    @objc private func shrinkAnimation() {
        if shrinkOffset >= shrinkEnd - shrinkEnd / CGFloat(time) {
            shrinkOffset = shrinkEnd
        } else {
            shrinkOffset += shrinkEnd / CGFloat(time)
        }
        var from1: CGFloat! = from
        var end1: CGFloat! = end
        if closewise {
            from1 += shrinkOffset
        } else {
            end1 -= shrinkOffset
        }
        self.path = xf_path(With: from1, end: end1).cgPath
        label1.textAlignment = .center
        label1.text = "test";
        label1.center = labelCenter(from: from1, end: end1)
        label1.textColor = UIColor.white
        label1.bounds = CGRect(x: 0, y: 0, width: 50, height: 15)
        label1.layer.backgroundColor = UIColor.white.cgColor

        if shrinkOffset >= shrinkEnd {
            shrinkLink?.remove(from: .current, forMode: .common)
            shrinkEnd = 0.0
            shrinkOffset = 0.0
            from = from1
            end = end1
        }
}
    
    @objc private func moveAnimation() {
        
        if moveOffset >= moveEnd - self.moveEnd / CGFloat(time)  {
            moveOffset = moveEnd
        } else {
            moveOffset += self.moveEnd / CGFloat(time)
        }
        
        var from1: CGFloat! = from
        var end1: CGFloat! = end
        
        if closewise {
            end1 += moveOffset
            from1 += moveOffset
        } else {
            end1 -= moveOffset
            from1 -= moveOffset
        }

        self.path = xf_path(With: from1, end: end1).cgPath
        label1.textAlignment = .center
        label1.text = "test";
        label1.center = labelCenter(from: from1, end: end1)
        label1.textColor = UIColor.white
        label1.bounds = CGRect(x: 0, y: 0, width: 50, height: 15)
        label1.layer.backgroundColor = UIColor.white.cgColor
        if moveOffset >= moveEnd {
            moveLink?.remove(from: .current, forMode: .common)
            moveEnd = 0.0
            moveOffset = 0.0
            from = from1
            end = end1
        }

    }
    
    @objc private func growAnimate() {
        if growOffset >= growEnd - self.growEnd / CGFloat(time) {
            growOffset = growEnd
        } else {
            growOffset += self.growEnd / CGFloat(time)
        }

        var from1: CGFloat! = from
        var end1: CGFloat! =  end

        if closewise {
            end1 += growOffset
        } else {
            from1 -= growOffset
        }

        if end1 - from1 < 0.25 {
            if closewise {
                end1 = from1 + 0.25
            } else {
                from1 = end1 - 0.25
            }
        }
        self.path = xf_path(With: from1, end: end1).cgPath
        label1.textAlignment = .center
        label1.text = "test";
        label1.center = labelCenter(from: from1, end: end1)
        label1.textColor = UIColor.white
        label1.bounds = CGRect(x: 0, y: 0, width: 50, height: 15)
        label1.layer.backgroundColor = UIColor.white.cgColor
        if growOffset >= growEnd - self.growEnd / CGFloat(time) {
            growLink?.remove(from: .current, forMode: .common)
            growEnd = 0.0
            growOffset = 0.0
            from = from1
            end = end1
        }
    }
    
    private func xf_path(With from: CGFloat, end: CGFloat) -> UIBezierPath! {

        let outPath1 = UIBezierPath(arcCenter: center, radius: 100 , startAngle:from + outOffset, endAngle:end - outOffset  , clockwise: true)
        outPath1.addArc(withCenter: center, radius: 70 , startAngle: end - inOffset, endAngle: from + inOffset, clockwise: false)
        outPath1.close()
        return outPath1
    }
    
    private func labelCenter(from: CGFloat, end: CGFloat) -> CGPoint {
        let temp = (end - from)/2.0
        let angle = from  + temp
        let x2 = 85.0*cos(angle)
        let y2 = 85.0*sin(angle)
        
        return CGPoint(x: center.x+CGFloat(x2), y: center.y+CGFloat(y2))
    }
    
}
