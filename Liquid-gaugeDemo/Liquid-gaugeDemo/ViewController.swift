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
    @IBOutlet weak var maskTwo: UIImageView!
    
    @IBAction func noMaskTouch(sender: AnyObject) {
        maskOne.alpha = 0.0
        maskTwo.alpha = 0.0
    }
    
    @IBAction func maskOneTouch(sender: AnyObject) {
        maskOne.alpha = 1.0
        maskTwo.alpha = 0.0
    }
    
    @IBAction func maskTwoTouch(sender: AnyObject) {
        maskOne.alpha = 0.0
        maskTwo.alpha = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liquidView.delegate = self
        liquidView.datasource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        liquidView.startMotionDetect()
    }
    
    override func viewDidDisappear(animated: Bool) {
        liquidView.stopMotionDetect()
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
    
    func numberOfWaves(liquidView: LiquidView) -> Int {
        return 2
    }
    
    //MARK: - LiquidView Delegate
    func liquidView(liquidView: LiquidView, colorForPercent percent: Float) -> UIColor! {
        
        var res = UIColor(red: 128/255, green: 180/255, blue: 43/255, alpha: 1.0)
        
        if (percent > 70.0) {
            res = UIColor(red: 203/255, green: 38/255, blue: 38/255, alpha: 1.0)
        } else if (percent > 40.0) {
            res = UIColor(red: 238/255, green: 133/255, blue: 29/255, alpha: 1.0)
        }
        
        return res
    }
    

}

