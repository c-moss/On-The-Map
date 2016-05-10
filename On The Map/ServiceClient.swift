//
//  ServiceClient.swift
//  On The Map
//
//  Created by Campbell Moss on 2/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

class ServiceClient : NSObject {
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    class func sendError(error: Error, completion: (result: AnyObject?, error: Error) -> Void) {
        completion(result: nil, error: error)
    }
    
    func sendHTTPRequestWithCallback(URL: NSURL, body: String?=nil, completion: (result: AnyObject?, error: Error?) -> Void) {
        let request = NSMutableURLRequest(URL: URL)
        
        if let body = body {    // if a body has been supplied, assume that this a POST request
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard error == nil else {
                ServiceClient.sendError(GeneralError(message: error!.localizedDescription, error: error!), completion: completion)
                return
            }
            
            guard let response = response as? NSHTTPURLResponse else {
                ServiceClient.sendError(Error(message: "Your request returned an invalid response!"), completion: completion)
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode <= 299 else {
                ServiceClient.sendError(HTTPError(message: "Your request returned a status code other than 2xx!", code: response.statusCode), completion: completion)
                return
            }

            guard let data = data else {
                ServiceClient.sendError(Error(message: "No data was returned by the request!"), completion: completion)
                return
            }
            
            let strippedData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            let parsedResult: AnyObject!

            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(strippedData, options: .AllowFragments)
            } catch {
                parsedResult = nil
                ServiceClient.sendError(Error(message: "Could not parse the data as JSON: \(data)"), completion: completion)
                return
            }
            
            completion(result: parsedResult, error: nil)
        }
        
        task.resume()
        
    }
}