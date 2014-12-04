// Playground - noun: a place where people can play

import UIKit

class LiquidView: UIView {

    var timer: NSTimer?
    var tick: Int = 0
    var _amplitude: Float = 10.0
    
//    func initialize() {
//        if ((timer) != nil) {
//            timer!.invalidate()
//        }
//        timer = NSTimer(timeInterval: 0.025, target: self, selector: "update", userInfo: nil, repeats: true)
//        self.setNeedsDisplay()
//    }
//    
//    override init() {
//        super.init()
//        initialize()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initialize()
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func update() {
//        var requiredTickes = 2
//        tick = (tick+1)%requiredTickes
//        _amplitude = Float(arc4random_uniform(20))
//        if (tick == 0) {
//            self.setNeedsDisplay()
//        }
//    }
    
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
    
    func drawWaves(rect: CGRect, context: CGContextRef, colorSpace: CGColorSpaceRef) {
        
        let marginLeft: Float = 0
        let marginRight: Float = 0
        let _density: Float = 5.0
        let _lineWidth: Float = 2.0
        
        let halfHeight: Float = Float(self.bounds.height) / 2.0;
        let width: Float = Float(self.bounds.width) - marginLeft - marginRight;
        let mid: Float = width / 2.0;
        let stepLength = _density / width;
        
        CGContextSetLineWidth(context, CGFloat(_lineWidth))
        var maxAmplitude: Float = halfHeight - Float(2 * _lineWidth)
        var normedAmplitude: Float = _amplitude
        
        
        UIColor.blueColor().colorWithAlphaComponent(0.5).set()

        var curve : CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(curve, nil, CGFloat(marginLeft), CGFloat(halfHeight))
        
        var lastX : CGFloat = 0
        var lastY : CGFloat = self.bounds.height / 2.0
        for (var x:Float = 0;x<width+_density; x+=_density) {
            CGContextMoveToPoint(context, lastX, lastY)
            var scaling: Float = -pow(1/mid*(x-mid),2)+1
            normedAmplitude = 0.1
            
            var y: Float = scaling * maxAmplitude * normedAmplitude * sinf(2.0 * Float(M_PI) * (x / width) * 0.1 + 0.0) + halfHeight
            
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

var liquid = LiquidView(frame: CGRectMake(0, 0, 300, 300))
