//
//  ParseClient.swift
//  On The Map
//
//  Created by Campbell Moss on 10/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

class ParseClient : ServiceClient {
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    // create a URL from parameters
    class func parseURLFromParameters(parameters: [String:String], withPathExtension: String? = nil) -> NSURL {
        return super.urlFromParameters(Constants.ApiScheme, host: Constants.ApiHost, path: Constants.ApiPath, parameters: parameters, withPathExtension: withPathExtension)
    }
    
    func getStudentLocations(completion: (result: [StudentInformation]?, error: Error?) -> Void) {
        let methodParameters = ["limit":"100"]
        let url = ParseClient.parseURLFromParameters(methodParameters, withPathExtension: Methods.StudentLocation)
                
        //TODO: tidy up
        //print("Getting \(url)")
        
        let headers = ["X-Parse-Application-Id":Constants.ApplicationID, "X-Parse-REST-API-Key":Constants.ApiKey]
        
        sendHTTPGETWithCallback(url, headers: headers) { (result, error) in
            guard error == nil else {
                completion(result: nil, error: error)
                return
            }
            
            guard let result = result else {
                completion(result: nil, error: Error(message: "Result was nil"))
                return
            }
            
            guard let resultArray = result[ParseClient.JSONResponseKeys.GetStudentLocation.results] as? [[String:AnyObject]] else {
                completion(result: nil, error: Error(message: "Error parsing StudentLocation data"))
                return
            }
            
            do {
                let studentLocations = try resultArray.map() {try StudentInformation(data: $0)}
                completion(result: studentLocations, error: nil)
            } catch {
                completion(result: nil, error: Error(message: "Error parsing StudentLocation data"))
            }
        }
    }
}