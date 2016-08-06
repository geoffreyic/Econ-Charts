//
//  SearchViewController.swift
//  Economic Charts
//
//  Created by Geoffrey_Ching on 7/27/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController{
    
    @IBOutlet var tableView: UITableView!
    
    
    var data:[Series] = []
    
    var selectedSeries:Series? = nil
    
    var indicator:UIActivityIndicatorView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 60, 60))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        self.view.addSubview(indicator)
        
    }
    
    
    func seriesSearchError(errorMessage: String){
        goToMainThread(){
            self.displayErrorAlert(errorMessage)
        }
    }
    

    
    
    func seriesSearchComplete(result: AnyObject!){
        
        //print(result)
        
        
        guard let seriesArr = result["seriess"] as? [AnyObject] else{
            displayErrorAlert("could not parse json")
            return
        }
        
        var dataNew:[Series] = []
        
        for obj in seriesArr{
            
            guard let obj = obj as? [String:AnyObject] else{
                displayErrorAlert("error parsing json object")
                print("error parsing json")
                continue
            }
            
            let frequency = obj["frequency"] as! String
            let frequency_short = obj["frequency_short"] as! String
            let id = obj["id"] as! String
//            let last_updated = obj["last_updated"] as! String
            let notes = obj["notes"] as? String
//            let observation_end = obj["observation_end"] as! String
//            let popularity = obj["popularity"] as! Int
//            let observation_start = obj["observation_start"] as! String
            let seasonal_adjustment = obj["seasonal_adjustment"] as! String
            let seasonal_adjustment_short = obj["seasonal_adjustment_short"] as! String
            let title = obj["title"] as! String
            let units = obj["units"] as! String
            let units_short = obj["units_short"] as! String
            
            let series:Series = Series(frequency: frequency,
                                       frequency_short: frequency_short,
                                       id: id,
//                                       last_updated: last_updated,
                                       notes: notes,
//                                       observation_end: observation_end,
//                                       observation_start: observation_start,
//                                       popularity: popularity,
                                       seasonal_adjustment: seasonal_adjustment,
                                       seasonal_adjustment_short: seasonal_adjustment_short,
                                       title: title,
                                       units: units,
                                       units_short: units_short)
            
            
            dataNew.append(series)
        }
        
        print("search finishing")
        
        data = dataNew
        
        goToMainThread(){
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SearchToSeries"){
            let vc = segue.destinationViewController as! SeriesViewController
            
            vc.series = selectedSeries
        }
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedSeries = data[indexPath.row]
        
        performSegueWithIdentifier("SearchToSeries", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
        
        let dataRow = data[indexPath.row]
        
        print(dataRow)
        
        print(dataRow.title)
        cell.textLabel!.text = dataRow.title
        cell.detailTextLabel!.text = dataRow.frequency_short + ", " + dataRow.units_short + ", " + dataRow.seasonal_adjustment_short
        
        return cell
    }
    
}


extension SearchViewController: UISearchBarDelegate{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // search for text
        
        if(searchText.characters.count <= 1){
            data = []
            tableView.reloadData()
            return
        }
        
        indicator.startAnimating()
        
        FredAPI.instance.seriesSearch(searchText, completionHandler: seriesSearchComplete, errorHandler: seriesSearchError)
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        data = []
        searchBar.text = ""
        tableView.reloadData()
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}