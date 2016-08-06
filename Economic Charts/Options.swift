//
//  Options.swift
//  Econ Charts
//
//  Created by Geoffrey_Ching on 8/6/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class Options{
    static var instance = Options()
    
    
    func initializeDefaults(){
        NSUserDefaults.standardUserDefaults().setObject("UIDeviceWhiteColorSpace 0 1", forKey: "chartLineColor")
        
    }
    
    func saveLineColor(color: String){
        
        NSUserDefaults.standardUserDefaults().setObject(color, forKey: "chartLineColor")
    }
    
    func getLineColor()-> UIColor{
        let colorString = NSUserDefaults.standardUserDefaults().stringForKey("chartLineColor")
        
        if(colorString == "Blue"){
            return UIColor.blueColor()
        }else if(colorString == "Red"){
            return UIColor.redColor()
        }else if(colorString == "Green"){
            return UIColor.greenColor()
        }else{
            return UIColor.blackColor()
        }
    }
    
    func getLineColorString()-> String?{
        let colorString = NSUserDefaults.standardUserDefaults().stringForKey("chartLineColor")
        
        return colorString
    }
    
    
}