//
//  SeriesViewController.swift
//  Economic Charts
//
//  Created by Geoffrey_Ching on 7/31/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit
import Charts

class SeriesViewController: BaseViewController, ChartViewDelegate{
    
    var series:Series!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var seriesDataStackView: UIStackView!
    @IBOutlet weak var chartDataLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var seasonalAdjustmentLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    
    var stack:CoreDataStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = series.title
        frequencyLabel.text = series.frequency
        seasonalAdjustmentLabel.text = series.seasonal_adjustment
        unitsLabel.text = series.units
        if(series.notes != nil){
            notesLabel.text = series.notes!
        }
        
        
        FredAPI.instance.seriesObservations(series.id, completionHandler: seriesObservationsComplete, errorHandler: seriesObservationsError)
        
        
        lineChartView.delegate = self
        lineChartView.descriptionText = ""
        lineChartView.gridBackgroundColor = UIColor.darkGrayColor()
        lineChartView.noDataText = ""
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        
        // Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        stack = delegate.stack
        
        
        
    }
 
    func seriesObservationsError(errorMessage: String){
        goToMainThread(){
            self.displayErrorAlert(errorMessage)
        }
    }
    
    func seriesObservationsComplete(result: AnyObject!){
        
        guard let result2 = result as? [String:AnyObject] else{
            displayErrorAlert("could not parse json")
            return
        }
        
        guard let units = result2["units"] as? String,
        let count = result2["count"] as? Int,
        let observationsRaw = result2["observations"] as? [[String: AnyObject]] else{
                
                displayErrorAlert("could not extract properties")
                return
        }
        
        var observations:[Observation] = []
        
        for obj in observationsRaw{
            
            guard let date = obj["date"] as? String,
                let value = obj["value"] as? String else{
                    continue
            }
            
            guard let valueDbl = Double(value) else{
                continue
            }
            
            observations.append(Observation(date: date, value: valueDbl))
            
        }
        
        
        let resultObservations:Observations = Observations(units: units, count: count, observations: observations)
        
        chartObservations(resultObservations)
        
        goToMainThread(){
            self.chartDataLoadingIndicator.stopAnimating()
        }
        
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        let img:UIImage = lineChartView.getChartImage(transparent: false)!
        
        //let imgView:UIImageView = UIImageView(image: img)
        
        //seriesDataStackView.addArrangedSubview(imgView)
        
        
        let aVC = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        
        aVC.completionWithItemsHandler = {activityType, completed, returnedItems, activityError in
            if(completed){
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(aVC, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        
        let img:UIImage = lineChartView.getChartImage(transparent: false)!
        
        let pngRepresentation = UIImagePNGRepresentation(img)
        
        if pngRepresentation == nil{
            print("png data empty error")
        }
        
        let imgData:NSData = NSData(data: pngRepresentation!)
        
        let _:Chart = Chart(context: stack.context, baseSeries: series, imageData: imgData)
        
        stack.save()
        
        
        let alertController = UIAlertController(title: "Chart Saved", message: "The chart has been saved", preferredStyle: UIAlertControllerStyle.Alert)
            
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK pressed for chart saved message ")
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func chartObservations(obs: Observations){
        var xVals:[String] = [String]()
        var yVals:[ChartDataEntry] = [ChartDataEntry]()
        
        
        var count = 0
        
        for observation in obs.observations{
            xVals.append(observation.date)
            
            yVals.append(ChartDataEntry(value: observation.value, xIndex: count))
            
            count += 1
        }
        
        let label:String = series.title + ": " + series.frequency_short + ", " + series.seasonal_adjustment_short + " (" + series.units_short + ")"
        
        let dataSet:LineChartDataSet = LineChartDataSet(yVals: yVals, label: label)
        
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.lineWidth = 5
        dataSet.lineCapType = .Round
        dataSet.setColor(Options.instance.getLineColor())
        
        
        
        let lineChartData = LineChartData(xVals: xVals, dataSet: dataSet)
        
        goToMainThread(){
            self.lineChartView.data
                = lineChartData
        }
    }
    
}
