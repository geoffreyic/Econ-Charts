//
//  Chart.swift
//  Economic Charts
//
//  Created by Geoffrey_Ching on 7/31/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import CoreData

class Chart: NSManagedObject{
    
    @NSManaged var frequency: String?
    @NSManaged var frequency_short: String?
    @NSManaged var id: String?
    @NSManaged var notes: String?
    @NSManaged var seasonal_adjustment: String?
    @NSManaged var seasonal_adjustment_short: String?
    @NSManaged var title: String?
    @NSManaged var units: String?
    @NSManaged var units_short: String?
    @NSManaged var image_data: NSData?
    
    convenience init(context : NSManagedObjectContext, baseSeries: Series, imageData: NSData){
        
        if let ent = NSEntityDescription.entityForName("Chart", inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            
            self.frequency = baseSeries.frequency
            self.frequency_short = baseSeries.frequency_short
            self.id = baseSeries.id
            self.notes = baseSeries.notes
            self.seasonal_adjustment = baseSeries.seasonal_adjustment
            self.seasonal_adjustment_short = baseSeries.seasonal_adjustment_short
            self.title = baseSeries.title
            self.units = baseSeries.units
            self.units_short = baseSeries.units_short
            self.image_data = imageData
        }else{
            fatalError("Unable to find Entity name!")
        }
    }
}