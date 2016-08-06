//
//  Series.swift
//  Economic Charts
//
//  Created by Geoffrey_Ching on 7/31/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//


class Series{
    
    var frequency:String!
    var frequency_short:String!
    var id:String!
//    var last_updated:String!
    var notes:String?
//    var observation_end:String!
//    var observation_start:String!
//    var popularity:Int!
    var seasonal_adjustment:String!
    var seasonal_adjustment_short:String!
    var title:String!
    var units:String!
    var units_short:String!
    
    init(frequency: String,
                     frequency_short:String,
                     id: String,
//                     last_updated: String,
                     notes: String?,
//                     observation_end: String,
//                     observation_start: String,
//                     popularity: Int,
                     seasonal_adjustment: String,
                     seasonal_adjustment_short: String,
                     title: String,
                     units: String,
                     units_short: String){
        
        self.frequency = frequency
        self.frequency_short = frequency_short
        self.id = id
//        self.last_updated = last_updated
        self.notes = notes
//        self.observation_end = observation_end
//        self.observation_start = observation_start
//        self.popularity = popularity
        self.seasonal_adjustment = seasonal_adjustment
        self.seasonal_adjustment_short = seasonal_adjustment_short
        self.title = title
        self.units = units
        self.units_short = units_short
        
    }
    
    init(chart: Chart){
        
        self.frequency = chart.frequency
        self.frequency_short = chart.frequency_short
        self.id = chart.id
        self.notes = chart.notes
        self.seasonal_adjustment = chart.seasonal_adjustment
        self.seasonal_adjustment_short = chart.seasonal_adjustment_short
        self.title = chart.title
        self.units = chart.units
        self.units_short = chart.units_short
    }
    
}