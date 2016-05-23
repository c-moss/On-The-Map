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
    class func udacityURLFromParameters(withPathExtension: String? = nil, parameters: [String:String] = [String:String]()) -> NSURL {
        return super.urlFromParameters(Constants.ApiScheme, host: Constants.ApiHost, path: Constants.ApiPath, parameters: parameters, withPathExtension: withPathExtension)
    }
    
    func createSession(username: String, password: String, completion: (result: UdacitySession?, error: Error?) -> Void) {
        let url = UdacityClient.udacityURLFromParameters(Methods.Session)
        
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        //TODO: tidy up
        //print("Sending \(body) to \(url)")
        
        sendHTTPPOSTWithCallback(url, body: body) { (result, error) in
            guard error == nil else {
                completion(result: nil, error: error)
                return
            }
            
            guard let resultDict = result as? [String:AnyObject] else {
                completion(result: nil, error: Error(message: "Result was nil"))
                return
            }
            
            do {
                let session = try UdacitySession(data: resultDict)
                completion(result: session, error: nil)
            } catch {
                completion(result: nil, error: Error(message: "Error parsing Udacity session data \(resultDict)"))
            }
        }
    }
    
    func deleteSession(completion: (result: UdacitySession?, error: Error?) -> Void) {
        var headers = [String:String]()

        let url = UdacityClient.udacityURLFromParameters(Methods.Session)
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        sendHTTPDELETEWithCallback(url, headers: headers) { (result, error) in
            guard error == nil else {
                completion(result: nil, error: error)
                return
            }
            
            //We don't really care what the result was, as long as we didn't get an error
            completion(result: nil, error: nil)
        }
    }
}