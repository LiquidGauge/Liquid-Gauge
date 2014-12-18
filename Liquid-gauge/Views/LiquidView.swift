//
//  LiquidView.swift
//  Liquid-gaugeDemo
//
//  Created by Anas Ait Ali on 02/12/14.
//  Copyright (c) 2014 thanbeth. All rights reserved.
//

import UIKit
import CoreMotion

class LiquidView: UIView {
    
    var timer: NSTimer?
    var tick: Int = 0
    var _amplitude: Float = 1.0
    var _frequency: Float = 1.5
    var _phase: Float = 0.0
    let _idleAmplitude: Float = 0.1
    var pourcentage : Float = 50
    
    var label = UILabel(frame: CGRectMake(30, 30, 100, 30))
    
    var motionManager:CMMotionManager = CMMotionManager()
    
    func initialize() {
        
        if ((timer) != nil) {
            timer!.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: "update", userInfo: nil, repeats: true)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.06, target: self, selector: "calcAngleConstant", userInfo: nil, repeats: true)
        //        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        pourcentage = 68
        label.text = "\(pourcentage)%"
        self.addSubview(label)
        self.setNeedsDisplay()
        println("🌺")
        startMotionDetect()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func updateProgress() {
        pourcentage = Float(arc4random_uniform(100))
        label.text = "\(pourcentage)%"
    }
    
    func update() {
        var requiredTickes = 2
        tick = (tick+1)%requiredTickes
        
        _phase += -Float(arc4random_uniform(150))/1000
//        _phase += -0.05
        if (tick == 0) {
            self.setNeedsDisplay()
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        var context : CGContextRef = UIGraphicsGetCurrentContext()
        var colorSpace : CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        
        var background = UIBezierPath(rect: rect)
        UIColor(white: 0.97, alpha: 1).setFill()
        background.fill()
        
        drawWaves(rect, context: context, colorSpace: colorSpace)
        
    }
    
    var accelerometer:CMAccelerometerData? = nil
    
    func startMotionDetect() {
        self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler:{(accelerometerData :     CMAccelerometerData!, error : NSError!) in
           
            self.accelerometer = accelerometerData
            
        })
    }
    
    var constant:Double = 0.0
    
    func calcAngleConstant() {
        if (accelerometer != nil) {
            
            var multiplier = 1.0
            if (accelerometer!.acceleration.x < 0) {
                multiplier = -1.0
            }
            
            constant = abs(accelerometer!.acceleration.y) * 100
            var intConstant = Int(constant)
            constant =  (1 - (Double(intConstant) / 10))  * multiplier
            
            if (Int(round(abs(accelerometer!.acceleration.z))) == 1) {
                constant = 0.0
            }
        }
    }
    
    func drawWaves(rect: CGRect, context: CGContextRef, colorSpace: CGColorSpaceRef) {
        
        
        
        let marginLeft: Float = 0
        let marginRight: Float = 0
        let _density: Float = 5.0
        let _lineWidth: Float = 2.0
        
        let vPosition: Float = Float(self.bounds.height) - (Float(self.bounds.height) * pourcentage / 100.0);
        let width: Float = Float(self.bounds.width) - marginLeft - marginRight;
        let mid: Float = width / 2.0;
        let stepLength = _density / width;
        
        CGContextSetLineWidth(context, CGFloat(_lineWidth))
        var maxAmplitude: Float = vPosition - Float(2 * _lineWidth)
        var normedAmplitude: Float = _amplitude
        
        UIColor.blueColor().colorWithAlphaComponent(0.5).set()
        
        var curve : CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(curve, nil, CGFloat(marginLeft), CGFloat(vPosition))
        
        var lastX : CGFloat = 0
        var lastY : CGFloat = self.bounds.height / 2.0
        
        let midPoint = ((width+_density) / 2)
        
        for (var x:Float = 0;x<width+_density; x+=_density) {
          
            var pute = (Double(midPoint) - Double(x)) * Double(constant)
            
            CGContextMoveToPoint(context, lastX, lastY)
            var scaling: Float = -pow(1/mid*(x-mid),2)+1
            normedAmplitude = 0.05
            
            var y: Float = scaling * maxAmplitude * normedAmplitude * sinf(2.0 * Float(M_PI) * (x / width) * _frequency + _phase) + vPosition + Float(pute)
            
            CGPathAddLineToPoint(curve, nil, CGFloat(x+marginLeft), CGFloat(y))
            let location: CGFloat = CGFloat(x / (width+_density))
            
            CGContextStrokePath(context)
            lastX = CGFloat(x + marginLeft)
            lastY = CGFloat(y)
        }
        CGPathAddLineToPoint(curve, nil, CGFloat(self.bounds.width) - CGFloat(marginRight), CGFloat(self.bounds.height))
        CGPathAddLineToPoint(curve, nil, CGFloat(marginLeft), CGFloat(self.bounds.height))
        CGPathCloseSubpath(curve)
        CGContextAddPath(context, curve)
        CGContextFillPath(context)
    }
   
}

