//
//  LiquidGaugeStyle.swift
//  LiquidGauge
//
//  Created by Thibault Carpentier on 12/12/14.
//  Copyright (c) 2014 thanbeth. All rights reserved.
//

import UIKit

class GaugeStyleAndBehavior: NSObject {
    typealias colorForRange = (color:UIColor!, range:NSRange)
    
    // MARK:Behavior variable
    var frequency:Double = 0.0
    var amplitude:Double = 0.0
    
    // MARK: Style variables
    var colors:[colorForRange]? = nil
    
    init(styleFile:String!, behaviorFile:String!) {
        
    }
    
}