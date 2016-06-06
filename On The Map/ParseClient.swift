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
    class func parseURLFromParameters(withPathExtension: String? = nil, parameters: [String:String] = [String:String]()) -> NSURL {
        return super.urlFromParameters(Constants.ApiScheme, host: Constants.ApiHost, path: Constants.ApiPath, parameters: parameters, withPathExtension: withPathExtension)
    }
    
    func getStudentLocations(completion: (result: [StudentInformation]?, error: Error?) -> Void) {
        let methodParameters = ["limit":"100"]
        let url = ParseClient.parseURLFromParameters(Methods.StudentLocation, parameters: methodParameters)
        
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
            
            guard let resultArray = result[ParseClient.JSONResponseKeys.StudentLocation.results] as? [[String:AnyObject]] else {
                completion(result: nil, error: Error(message: "Error parsing getStudentLocations response data: \(result)"))
                return
            }
            
            do {
                var studentLocations = try resultArray.map() {try StudentInformation(data: $0)}
                
                // Sort student locations by descending updated date
                studentLocations = studentLocations.sort({ (s1, s2) -> Bool in
                    return s1.updatedAt!.compare(s2.updatedAt!) == NSComparisonResult.OrderedDescending
                })
                
                completion(result: studentLocations, error: nil)
            } catch {
                completion(result: nil, error: Error(message: "Error parsing getStudentLocations response data: \(result)"))
            }
        }
    }
    
    func postStudentLocation(location: StudentInformation, completion: (result: StudentInformation?, error: Error?) -> Void) {
        let url = ParseClient.parseURLFromParameters(Methods.StudentLocation)
        
        let headers = ["X-Parse-Application-Id":Constants.ApplicationID, "X-Parse-REST-API-Key":Constants.ApiKey]
        
        let body = "{\"uniqueKey\": \"\(location.uniqueKey)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString)\", \"mediaURL\": \"\(location.mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}"
        
        sendHTTPPOSTWithCallback(url, headers: headers, body: body) { (result, error) in
            guard error == nil else {
                completion(result: nil, error: error)
                return
            }
            
            guard let result = result else {
                completion(result: nil, error: Error(message: "Result was nil"))
                return
            }
            
            guard let createdAt = result[ParseClient.JSONResponseKeys.StudentLocation.createdAt] as? String,
                let objectId = result[ParseClient.JSONResponseKeys.StudentLocation.objectId] as? String else {
                completion(result: nil, error: Error(message: "Error parsing postStudentLocation reponse data: \(result)"))
                return
            }
            
            var updatedLocation = location
            
            updatedLocation.createdAtString = createdAt
            updatedLocation.objectId = objectId
            
            completion(result: updatedLocation, error: nil)
        }
    }
    
    func queryStudentLocation(uniqueKey: String, completion: (result: [StudentInformation]?, error: Error?) -> Void) {
        let methodParameters = ["where":"{\"uniqueKey\":\"\(uniqueKey)\"}"]
        
        let url = ParseClient.parseURLFromParameters(Methods.StudentLocation, parameters: methodParameters)
        
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
            
            guard let resultArray = result[ParseClient.JSONResponseKeys.StudentLocation.results] as? [[String:AnyObject]] else {
                completion(result: nil, error: Error(message: "Error parsing queryStudentLocation response data: \(result)"))
                return
            }
            
            do {
                let studentLocations = try resultArray.map() {try StudentInformation(data: $0)}
                completion(result: studentLocations, error: nil)
            } catch {
                completion(result: nil, error: Error(message: "Error parsing queryStudentLocation response data: \(result)"))
            }
        }
    }
    
    func updateStudentLocation(location: StudentInformation, completion: (result: StudentInformation?, error: Error?) -> Void) {
        guard let objectId = location.objectId else {
            print("Error updating student location - supplied StudentInformation object had no objectId")
            completion(result: nil, error: Error(message: "Error updating student location"))
            return
        }
        let url = ParseClient.parseURLFromParameters("\(Methods.StudentLocation)/\(objectId)")
        
        let headers = ["X-Parse-Application-Id":Constants.ApplicationID, "X-Parse-REST-API-Key":Constants.ApiKey]
        
        let body = "{\"uniqueKey\": \"\(location.uniqueKey)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString)\", \"mediaURL\": \"\(location.mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}"
        
        sendHTTPPUTWithCallback(url, headers: headers, body: body) { (result, error) in
            guard error == nil else {
                completion(result: nil, error: error)
                return
            }
            
            guard let result = result else {
                completion(result: nil, error: Error(message: "Result was nil"))
                return
            }
            guard let updatedAt = result[ParseClient.JSONResponseKeys.StudentLocation.updatedAt] as? String else {
                    completion(result: nil, error: Error(message: "Error parsing updateStudentLocation response data: \(result)"))
                    return
            }
            
            var updatedLocation = location
            
            updatedLocation.updatedAtString = updatedAt
            
            completion(result: updatedLocation, error: nil)
        }
    }
}