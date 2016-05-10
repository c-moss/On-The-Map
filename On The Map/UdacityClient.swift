//
//  UdacityClient.swift
//  On The Map
//
//  Created by Campbell Moss on 2/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

class UdacityClient : ServiceClient {
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    // create a URL from parameters
    class func udacityURLFromParameters(parameters: [String:String], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        if parameters.count > 0 {
            components.queryItems = [NSURLQueryItem]()
            components.queryItems = parameters.map() { NSURLQueryItem(name: $0, value: $1)}
        }
        
        return components.URL!
    }
    
    func createSession(username: String, password: String, completion: (result: UdacitySession?, error: Error?) -> Void) {
        let methodParameters = [String:String]()
        let url = UdacityClient.udacityURLFromParameters(methodParameters, withPathExtension: Methods.Session)
        
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        //TODO: tidy up
        //print("Sending \(body) to \(url)")
        
        sendHTTPRequestWithCallback(url, body: body) { (result, error) in
            guard error == nil else {
                completion(result: nil, error: error)
                return
            }
            
            guard let result = result else {
                completion(result: nil, error: Error(message: "Result was nil"))
                return
            }

            UdacitySession.convertDataWithCompletionHandler(result,completion: completion)
        }
    }
}