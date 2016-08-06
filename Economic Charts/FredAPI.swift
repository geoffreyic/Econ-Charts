//
//  FredAPI.swift
//  Economic Charts
//
//  Created by Geoffrey_Ching on 7/26/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import Foundation

class FredAPI{
    
    static var instance = FredAPI()
    
    func seriesSearch(searchString: String, completionHandler: (result: AnyObject!)->(), errorHandler: (errorMessage:String)->()){
        
        
        let searchString2 = searchString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        var urlString = "https://api.stlouisfed.org/fred/series/search?"
        
        urlString = urlString.stringByAppendingString("search_text=")
        urlString = urlString.stringByAppendingString(searchString2!)
        
        urlString = urlString.stringByAppendingString("&api_key=")
        urlString = urlString.stringByAppendingString(FredConstants.apiKey)
        
        urlString = urlString.stringByAppendingString("&file_type=json")
        
        urlString = urlString.stringByAppendingString("&limit=20")
        
        print(urlString)
        
        
        performBaseRequest(urlString, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    func series(seriesId: String, completionHandler: (result: AnyObject!)->(), errorHandler: (errorMessage:String)->()){
        
        
        let seriesId2 = seriesId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        var urlString = "https://api.stlouisfed.org/fred/series/series?"
        
        urlString = urlString.stringByAppendingString("series_id=")
        urlString = urlString.stringByAppendingString(seriesId2!)
        
        urlString = urlString.stringByAppendingString("&api_key=")
        urlString = urlString.stringByAppendingString(FredConstants.apiKey)
        
        urlString = urlString.stringByAppendingString("&file_type=json")
        
        print(urlString)
        
        
        performBaseRequest(urlString, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    func seriesObservations(seriesId: String, completionHandler: (result: AnyObject!)->(), errorHandler: (errorMessage:String)->()){
        
        let seriesId2 = seriesId.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        var urlString = "https://api.stlouisfed.org/fred/series/observations?"
        
        urlString = urlString.stringByAppendingString("series_id=")
        urlString = urlString.stringByAppendingString(seriesId2!)
        
        urlString = urlString.stringByAppendingString("&api_key=")
        urlString = urlString.stringByAppendingString(FredConstants.apiKey)
        
        urlString = urlString.stringByAppendingString("&file_type=json")
        
        print(urlString)
        
        performBaseRequest(urlString, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    
    private func performBaseRequest(urlString: String, completionHandler: (result: AnyObject!)->(), errorHandler: (errorMessage:String)->()){
        
        print(urlString)
        
        
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = .ReloadIgnoringLocalCacheData
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            
            guard (error == nil) else {
                errorHandler(errorMessage: "There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                errorHandler(errorMessage: "Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                errorHandler(errorMessage: "No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                errorHandler(errorMessage: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            completionHandler(result: parsedResult)
            
        }
        
        task.resume()
        
    }
    
    
}