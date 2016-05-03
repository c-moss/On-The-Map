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
    
    func createSession(username: String, password: String, completion: (result: UdacitySession?, error: NSError?) -> Void) {
        let methodParameters = [String:String]()
        let url = UdacityClient.udacityURLFromParameters(methodParameters, withPathExtension: Methods.Session)
        
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        print("Sending \(body) to \(url)")
        
        sendHTTPRequestWithCallback(url, body: body) { (result, error) in
            guard error == nil else {
                completion(result: nil, error: error)
                return
            }
            
            guard let result = result else {
                completion(result: nil, error: ServiceClient.createError("createSession", error: "Result was nil"))
                return
            }

            UdacitySession.convertDataWithCompletionHandler(result,completion: completion)
        }
        
    }
    

    
//    func sendHTTPRequestWithCallback(URL: NSURL, body: String?=nil, completion: (result: AnyObject?, error: NSError?) -> Void) {
//        let request = NSMutableURLRequest(URL: URL)
//        
//        if let body = body {    // if a body has been supplied, assume that this a POST request
//            request.HTTPMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
//        }
//        
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            guard error == nil else {
//                self.sendError(error!.localizedDescription, completion: completion)
//                return
//            }
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    self.sendError("Your request returned an invalid response! Status code: \(response.statusCode)!", completion: completion)
//                } else if let response = response {
//                    self.sendError("Your request returned an invalid response! Response: \(response)!", completion: completion)
//                } else {
//                    self.sendError("Your request returned an invalid response!", completion: completion)
//                }
//                try! print(NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments))
//                return
//            }
//            
//            guard let data = data else {
//                self.sendError("No data was returned by the request!", completion: completion)
//                return
//            }
//            
//            let parsedResult: AnyObject!
//            
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//            } catch {
//                parsedResult = nil
//                self.sendError("Could not parse the data as JSON: '\(data)'", completion: completion)
//                return
//            }
//            
//            // If the response contains a success key (and not all of them do), make sure that it's true
//            if let success = parsedResult[JSONResponseKeys.foo.bax] as? Bool {
//                guard success == true else {
//                    self.sendError("TMDB API returned an error. See error code and message in \(parsedResult)", completion: completion)
//                    return
//                }
//            }
//            
//            completion(result: parsedResult, error: nil)
//        }
//        
//        task.resume()
//        
//    }
}