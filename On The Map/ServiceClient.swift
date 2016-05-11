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
    
    class func urlFromParameters(scheme: String, host: String, path: String, parameters: [String:String], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + (withPathExtension ?? "")
        if parameters.count > 0 {
            components.queryItems = [NSURLQueryItem]()
            components.queryItems = parameters.map() { NSURLQueryItem(name: $0, value: $1)}
        }
        
        return components.URL!
    }
    
    func sendHTTPRequestWithCallback(URL: NSURL, body: String?=nil, headers: [String:String]?=nil, completion: (result: AnyObject?, error: Error?) -> Void) {
        let request = NSMutableURLRequest(URL: URL)

        if let headers = headers {
            for header in headers {
                request.addValue(header.1, forHTTPHeaderField: header.0)
            }
        }
        
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

            guard var data = data else {
                ServiceClient.sendError(Error(message: "No data was returned by the request!"), completion: completion)
                return
            }
            
            // Check that the first byte is an opening curly brace - if not, we might be handling a response from the Udacity API, which has a "security feature" that requires us to strip the first 5 bytes from the response
            var firstByte: Character = "{"
            data.getBytes(&firstByte, length: 1)
            if firstByte != "{" {
                data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            }
            
            let parsedResult: AnyObject!

            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                ServiceClient.sendError(Error(message: "Could not parse the data as JSON: \(String(data: data, encoding: NSUTF8StringEncoding))"), completion: completion)
                return
            }
            
            completion(result: parsedResult, error: nil)
        }
        
        task.resume()
        
    }
}