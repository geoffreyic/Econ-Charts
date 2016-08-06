//
//  ChartOptionsViewController.swift
//  Econ Charts
//
//  Created by Geoffrey_Ching on 8/6/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit
import QuartzCore

class ChartOptionsViewController: BaseViewController{
    @IBOutlet weak var lineColorPicker: UIPickerView!
    @IBOutlet weak var outerStackView: UIView!
    
    
    var lineColorPickerData: [String] = [String]()
    
    override func viewDidLoad() {
        lineColorPickerData = ["Black", "Green", "Red", "Blue"]
        
        outerStackView.layer.borderWidth = 1
        outerStackView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let currentColor:String = Options.instance.getLineColorString()!
        
        
        let index = lineColorPickerData.indexOf(currentColor)
        
        if(index != nil){
            lineColorPicker.selectRow(index!, inComponent: 0, animated: false)
        }
        
    }
    
}

extension ChartOptionsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lineColorPickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lineColorPickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected:String = lineColorPickerData[row]
        
        print(selected)
        
        Options.instance.saveLineColor(selected)
    }
}