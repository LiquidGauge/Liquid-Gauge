//
//  GaugeStyle.swift
//  Liquid-gaugeDemo
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

//MARK: - LiquidView Delegate
@objc protocol LiquidViewDelegate : NSObjectProtocol {
    
    // Return a color depending on the pencent value of the gauge
    optional func liquidView(liquidView: LiquidView, colorForPencent percent:Int) -> UIColor
    
}

//MARK: - LiquidView Datasource
@objc protocol LiquidViewDatasource : NSObjectProtocol {
    
    // Frequency of the liquid's waves
    func waveFrequency() -> Int
  
    // Size of the waves
    func waveAmplitude() -> Int
    
    // Current value of the gauge in percent (%)
    func gaugeValue() -> Int
    
}


