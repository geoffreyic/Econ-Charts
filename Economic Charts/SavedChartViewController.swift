//
//  SavedChartViewController.swift
//  Econ Charts
//
//  Created by Geoffrey_Ching on 8/6/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class SavedChartViewController: BaseViewController{
    
    var chart:Chart!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        imageView.image = UIImage(data: chart.image_data!)
    }
    
    
    @IBAction func currentSeriesAction(sender: AnyObject) {
        performSegueWithIdentifier("ChartToSeries", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ChartToSeries"){
            let vc = segue.destinationViewController as! SeriesViewController
            
            vc.series = Series(chart: chart)
        }
    }
}