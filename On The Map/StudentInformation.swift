//
//  ParseStudentLocation.swift
//  On The Map
//
//  Created by Campbell Moss on 11/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    static var dateFormatter: NSDateFormatter {
        get {
            let df = NSDateFormatter()
            df.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S'Z'"
            return df
        }
    }
    
    var objectId: String?
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: NSDate?
    var createdAtString: String? {
        get {
            return (createdAt != nil) ? StudentInformation.dateFormatter.stringFromDate(createdAt!) : nil
        }
        
        set(newDate) {
            createdAt = (newDate != nil) ? StudentInformation.dateFormatter.dateFromString(newDate!) : nil
        }
    }
    var updatedAt: NSDate?
    var updatedAtString: String? {
        get {
            return (updatedAt != nil) ? StudentInformation.dateFormatter.stringFromDate(updatedAt!) : nil
        }
        
        set(newDate) {
            updatedAt = (newDate != nil) ? StudentInformation.dateFormatter.dateFromString(newDate!) : nil
        }
    }
    
    init(data: [String:AnyObject]) throws {
        
        
        guard let objectId = data[ParseClient.JSONResponseKeys.StudentLocation.objectId] as? String,
            let uniqueKey = data[ParseClient.JSONResponseKeys.StudentLocation.uniqueKey] as? String,
            let firstName = data[ParseClient.JSONResponseKeys.StudentLocation.firstName] as? String,
            let lastName = data[ParseClient.JSONResponseKeys.StudentLocation.lastName] as? String,
            let mapString = data[ParseClient.JSONResponseKeys.StudentLocation.mapString] as? String,
            let mediaURL = data[ParseClient.JSONResponseKeys.StudentLocation.mediaURL] as? String,
            let latitude = data[ParseClient.JSONResponseKeys.StudentLocation.latitude] as? Double,
            let longitude = data[ParseClient.JSONResponseKeys.StudentLocation.longitude] as? Double,
            let createdAtString = data[ParseClient.JSONResponseKeys.StudentLocation.createdAt] as? String,
            let createdAt = StudentInformation.dateFormatter.dateFromString(createdAtString),
            let updatedAtString = data[ParseClient.JSONResponseKeys.StudentLocation.updatedAt] as? String,
            let updatedAt = StudentInformation.dateFormatter.dateFromString(updatedAtString) else {
                throw ParseError.DataParsing
        }
        
        self.init(objectId: objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    init(objectId: String?, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, createdAt: NSDate?=nil, updatedAt: NSDate?=nil) {
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
