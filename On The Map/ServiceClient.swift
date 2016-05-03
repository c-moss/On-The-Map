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
    
    class func createError(domain: String, error: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : error]
        return NSError(domain: domain, code: 1, userInfo: userInfo)
    }
    
    class func sendError(error: String, completion: (result: AnyObject?, error: NSError?) -> Void) {
        completion(result: nil, error: createError("ServiceClient", error: error))
    }
    
    func sendHTTPRequestWithCallback(URL: NSURL, body: String?=nil, completion: (result: AnyObject?, error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: URL)
        
        if let body = body {    // if a body has been supplied, assume that this a POST request
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard error == nil else {
                ServiceClient.sendError(error!.localizedDescription, completion: completion)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    ServiceClient.sendError("Your request returned an invalid response! Status code: \(response.statusCode)!", completion: completion)
                } else if let response = response {
                    ServiceClient.sendError("Your request returned an invalid response! Response: \(response)!", completion: completion)
                } else {
                    ServiceClient.sendError("Your request returned an invalid response!", completion: completion)
                }
                return
            }

            guard let data = data else {
                ServiceClient.sendError("No data was returned by the request!", completion: completion)
                return
            }
            
            let strippedData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            let parsedResult: AnyObject!

            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(strippedData, options: .AllowFragments)
            } catch {
                parsedResult = nil
                ServiceClient.sendError("Could not parse the data as JSON: \(data)", completion: completion)
                return
            }
            
            completion(result: parsedResult, error: nil)
        }
        
        task.resume()
        
    }
}