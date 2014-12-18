//
//  ViewController.swift
//  Liquid-gaugeDemo
//
//  Created by Anas Ait Ali on 02/12/14.
//  Copyright (c) 2014 thanbeth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var liquidView: LiquidView!
    @IBOutlet weak var textValue: UILabel!
    @IBAction func valueChanged(sender: AnyObject) {
        var slider = sender as UISlider
        liquidView.percentage = round(slider.value * 100)
        textValue.text = "\(liquidView.percentage) %"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

