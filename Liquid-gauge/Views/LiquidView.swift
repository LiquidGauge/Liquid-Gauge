//
//  LiquidView.swift
//  Liquid-gaugeDemo
//
//  Created by Anas Ait Ali on 02/12/14.
//  Copyright (c) 2014 thanbeth. All rights reserved.
//

import UIKit
import CoreMotion

//MARK: - LiquidView Delegate
@objc protocol LiquidViewDelegate : NSObjectProtocol {
    
    // Return a color depending on the pencent value of the gauge
    optional func liquidView(liquidView: LiquidView, colorForPercent percent:Float) -> UIColor!
    
}

//MARK: - LiquidView Datasource
@objc protocol LiquidViewDatasource : NSObjectProtocol {
    
    // Frequency of the liquid's waves
    optional func waveFrequency(liquidView: LiquidView) -> Float
  
    // Size of the waves
    optional func waveAmplitude(liquidView: LiquidView) -> Float
    
    // Current value of the gauge in percent (%)
    func gaugeValue(liquidView: LiquidView) -> Float
    
}

//MARK: -LiquidView Class
class LiquidView: UIView {

    //MARK: - Variables
    //MARK: - Timers
    // Timer used for update drawing
    var timerRedraw: NSTimer? = nil
    let refreshRedrawInterval:NSTimeInterval = 0.025
    // Update angle constant periodically so unvoluntary shaking is not taken in account
    var timerAccelerometer:NSTimer? = nil
    let refreshUpdateAccelerometerInterval:NSTimeInterval = 0.06

    //MARK: Wave configuration
    // Limit refresh display and drawing, for performance
    var tick: Int = 0
    // Waves amplitude
    var _amplitude:Float = 0.1
    // Waves frequency
    var _frequency:Float = 1.5
    // The phases of the wave.
    var _phase:Float = 0.0
    // The color of the the liquid
    var color:UIColor = UIColor.blueColor()

    //MARK: Waves User controlled values
    // Percentage inside the gauge
    var percent:Float = 50
    // MARK: Motion manager
    lazy var motionManager: CMMotionManager = {
        let motion = CMMotionManager()
        motion.gyroUpdateInterval = 0.1
        return motion
        }()
    // We store the accelerometer data to reuse later
    var accelerometer:CMAccelerometerData? = nil
    // We store the angle constant (This is calculated by the timerAccelerometer callback and used during drawing)
    var angleConstant:Float = 0.0

    //MARK: concurential acces
    let lockQueue = dispatch_queue_create("com.test.accelerometerLock", nil)

    //MARK: - Delegate
    var delegate:LiquidViewDelegate? = nil {
        willSet (value) {
            if (value != nil && value!.respondsToSelector(Selector("liquidView:colorForPercent:"))) {
                delegateRespondTo.liquidViewColorForPercent = true
            }
        }
    }
    
    struct delegateMethodCaching {
        var liquidViewColorForPercent:Bool = false
    }
    var delegateRespondTo:delegateMethodCaching = delegateMethodCaching()

    //MARK: - Datasource
    var datasource:LiquidViewDatasource? = nil {
        willSet (newValue) {
            if (newValue != nil) {
                datasourceRespondTo.waveFrequency = newValue!.respondsToSelector(Selector("waveFrequency:"))
                datasourceRespondTo.waveAmplitude = newValue!.respondsToSelector(Selector("waveAmplitude:"))
                datasourceRespondTo.gagugeValue = newValue!.respondsToSelector(Selector("gaugeValue:"))
            }
        }
    }

    struct datasourceMethodsCaching {
        var waveFrequency:Bool = false
        var waveAmplitude:Bool = false
        var gagugeValue:Bool = false
    }
    var datasourceRespondTo:datasourceMethodsCaching = datasourceMethodsCaching()
    
    //MARK: - Methods
    //MARK: - Life cycle
    func initialize() {
        // Starting accelerometer detection
//        startMotionDetect() // We should let the user start motion dectection when he needs to -> save battery

        // Redo timers
        invalidateTimer(&timerRedraw)
        invalidateTimer(&timerAccelerometer)
        timerRedraw = NSTimer.scheduledTimerWithTimeInterval(refreshRedrawInterval, target: self, selector: "updateDrawing", userInfo: nil, repeats: true)
        timerAccelerometer = NSTimer.scheduledTimerWithTimeInterval(refreshUpdateAccelerometerInterval, target: self, selector: "calcAngleConstant", userInfo: nil, repeats: true)

        self.setNeedsDisplay()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    //MARK: - Drawing
    func updateDrawing() {
        let requiredTickes = 4
        tick = (tick+1)%requiredTickes
        
        _phase += -Float(arc4random_uniform(150))/1000
        if (tick == 0) {
            self.setNeedsDisplay()
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context : CGContextRef = UIGraphicsGetCurrentContext()
        let colorSpace : CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let background = UIBezierPath(rect: rect)

        UIColor(white: 0.97, alpha: 1).setFill()
        background.fill()
        
        drawWaves(rect, context: context, colorSpace: colorSpace)
    }
    

    func drawWaves(rect: CGRect, context: CGContextRef, colorSpace: CGColorSpaceRef) {
        // Drawing constants
        let marginLeft: Float = 0
        let marginRight: Float = 0
        let _density: Float = 5.0
        let _lineWidth: Float = 2.0

        
        if (self.datasource != nil) {
            self.percent = datasource!.gaugeValue(self)
            if (self.datasourceRespondTo.waveFrequency) {
                self._frequency = self.datasource!.waveFrequency!(self)
            }
            if (self.datasourceRespondTo.waveAmplitude) {
                self._amplitude = self.datasource!.waveAmplitude!(self)
            }
            
        }
        
        // constant calculated according to drawing constant (For future more scalable use)
        let vPosition: Float = Float(self.bounds.height) - (Float(self.bounds.height) * percent / 100.0);
        let width: Float = Float(self.bounds.width) - marginLeft - marginRight;
        let mid: Float = width / 2.0;
        let stepLength = _density / width;

        CGContextSetLineWidth(context, CGFloat(_lineWidth))
        let maxAmplitude: Float = vPosition - Float(2 * _lineWidth)
        let normedAmplitude: Float = _amplitude

        if (self.delegate != nil && self.delegateRespondTo.liquidViewColorForPercent) {
            self.color = (delegate!.liquidView!(self, colorForPercent: percent))
        }
        
        color.colorWithAlphaComponent(0.5).set()

        let curve : CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(curve, nil, CGFloat(marginLeft), CGFloat(vPosition))

        var lastX : CGFloat = 0
        var lastY : CGFloat = self.bounds.height / 2.0

        let midPoint = ((width+_density) / 2)

        for (var x:Float = 0;x<width+_density; x+=_density) {

            let currentPointYOffset = (Float(midPoint) - Float(x)) * Float(angleConstant)

            CGContextMoveToPoint(context, lastX, lastY)
            let scaling: Float = -pow(1/mid*(x-mid),2)+1

            let y: Float = scaling * maxAmplitude * normedAmplitude * sinf(2.0 * Float(M_PI) * (x / width) * _frequency + _phase) + vPosition + Float(currentPointYOffset)

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


    // MARK: - Accelerometer methods
    func startMotionDetect() {
        self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler:{(accelerometerData:CMAccelerometerData!, error:NSError!) in
            dispatch_sync(self.lockQueue) {
                self.accelerometer = accelerometerData
            }
        })
    }
    
    func stopMotionDetect() {
        self.motionManager.stopGyroUpdates()
    }
    
    //MARK: - Utils
    func calcAngleConstant() {
        dispatch_sync(lockQueue) {
            if (self.accelerometer != nil) {
                var multiplier:Float = 1.0
                if (self.accelerometer!.acceleration.x < 0) {
                    multiplier = -1.0
                }

                self.angleConstant = Float(abs(self.accelerometer!.acceleration.y)) * Float(100.0)
                var intConstant = Int(self.angleConstant)
                self.angleConstant =  (1 - (Float(intConstant) / 100))  * multiplier

                // If device is parralel to the ground, cancel the rotation
                if (Int(round(abs(self.accelerometer!.acceleration.z))) == 1) {
                    self.angleConstant = 0.0
                }
            }
        }
    }
    
    
    func invalidateTimer(inout timer:NSTimer?) -> Bool {
        var success:Bool = false

        if (timer != nil && timer!.valid == true) {
            timer!.invalidate(); timer = nil
            success = true
        }
        return success
    }
}

