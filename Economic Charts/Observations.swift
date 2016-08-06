//
//  Observations.swift
//  Economic Charts
//
//  Created by Geoffrey_Ching on 7/31/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//



class Observations{
    
    var units: String
    var count: Int
    var observations:[Observation]
    
    init(units: String, count: Int, observations: [Observation]){
        self.units = units
        self.count = count
        self.observations = observations
    }
}