//
//  SavedViewController.swift
//  Economic Charts
//
//  Created by Geoffrey_Ching on 7/29/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit
import CoreData

class  SavedViewController: BaseViewController {
    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    var fetchedResultsController:NSFetchedResultsController!
    var stack:CoreDataStack!
    var selectedChart:Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        stack = delegate.stack
        
        
        
        // Create a fetchrequest
        let fr = NSFetchRequest(entityName: "Chart")
        fr.sortDescriptors = []

        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch let e as NSError{
            print("Error while fetching photos \n\(e)\n\(fetchedResultsController)")
        }
    }
    
    
    @IBAction func editAction(sender: AnyObject) {
        if(tableView.editing){
            tableView.editing = false
            editButton.title = "Edit"
            
        }else{
            tableView.editing = true
            editButton.title = "Cancel"
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SavedToChart"){
            let vc = segue.destinationViewController as! SavedChartViewController
            
            vc.chart = selectedChart
        }
    }
    
}

extension SavedViewController: NSFetchedResultsControllerDelegate{
    
    
    /// from https://github.com/udacity/ios-nd-persistence/blob/master/CoolNotes/13-CoreDataAndConcurrency/CoolNotes/CoreDataTableViewController.swift
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        let set = NSIndexSet(index: sectionIndex)
        
        switch (type){
            case .Insert:
                tableView.insertSections(set, withRowAnimation: .Fade)
            
            case .Delete:
                tableView.deleteSections(set, withRowAnimation: .Fade)
            
            default:
                break
        }
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type){
            
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
            case .Update:
                tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}

extension SavedViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let obj = fetchedResultsController.objectAtIndexPath(indexPath)
        
        let chart = obj as! Chart
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath)
        
        
        cell.imageView?.image = UIImage(data: chart.image_data!)
        cell.textLabel?.text = chart.title
        cell.detailTextLabel?.text = chart.frequency_short! + ", " + chart.units_short! + ", " + chart.seasonal_adjustment_short!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedChart = fetchedResultsController.objectAtIndexPath(indexPath) as! Chart
        
        performSegueWithIdentifier("SavedToChart", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete){
            fetchedResultsController.managedObjectContext.deleteObject(fetchedResultsController.objectAtIndexPath(indexPath) as! Chart)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let ns = fetchedResultsController{
            print(ns.sections!.count)
            return ns.sections!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fc = fetchedResultsController{
            print("number objects: ")
            print(fc.sections![section].numberOfObjects)
            return fc.sections![section].numberOfObjects;
        }else{
            return 0
        }
    }
}