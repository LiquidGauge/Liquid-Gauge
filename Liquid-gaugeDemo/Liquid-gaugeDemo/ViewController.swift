//
//  ViewController.swift
//  Liquid-gaugeDemo
//
//  Created by Anas Ait Ali on 02/12/14.
//  Copyright (c) 2014 thanbeth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LiquidViewDelegate, LiquidViewDatasource {
    
    @IBOutlet weak var liquidView: LiquidView!
    @IBOutlet weak var textValue: UILabel!
    @IBAction func valueChanged(sender: AnyObject) {
        var slider = sender as UISlider
        gaugeValue = round(slider.value * 100)
        textValue.text = "\(gaugeValue) %"
    }
    
    var gaugeValue:Float = 50.0
    
    @IBOutlet weak var maskOne: UIImageView!
    
    @IBAction func noMaskTouch(sender: AnyObject) {
        maskOne.alpha = 0.0
    }
    
    @IBAction func maskOneTouch(sender: AnyObject) {
        maskOne.alpha = 1.0
    }
    
    @IBAction func maskTwoTouch(sender: AnyObject) {
        maskOne.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liquidView.delegate = self
        liquidView.datasource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - LiquidView Datasource
    func waveFrequency(liquidView: LiquidView) -> Float {
        return 1.5
    }
    
    func waveAmplitude(liquidView: LiquidView) -> Float {
        return 0.1
    }
    
    func gaugeValue(liquidView: LiquidView) -> Float {
        return gaugeValue
    }
    
    //MARK: - LiquidView Delegate
    func liquidView(liquidView: LiquidView, colorForPercent percent: Float) -> UIColor! {
        
        var res = UIColor.greenColor()
        
        if (percent > 70.0) {
            res = UIColor.redColor()
        } else if (percent > 40.0) {
            res = UIColor.orangeColor()
        }
        
        return res
    }
    

}

