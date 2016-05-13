//
//  ParseStudentLocation.swift
//  On The Map
//
//  Created by Campbell Moss on 11/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    var createdAt: NSDate
    var updatedAt: NSDate
    
    init(data: [String:AnyObject]) throws {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S'Z'"
        
        guard let objectId = data[ParseClient.JSONResponseKeys.GetStudentLocation.objectId] as? String,
            let uniqueKey = data[ParseClient.JSONResponseKeys.GetStudentLocation.uniqueKey] as? String,
            let firstName = data[ParseClient.JSONResponseKeys.GetStudentLocation.firstName] as? String,
            let lastName = data[ParseClient.JSONResponseKeys.GetStudentLocation.lastName] as? String,
            let mapString = data[ParseClient.JSONResponseKeys.GetStudentLocation.mapString] as? String,
            let mediaURL = data[ParseClient.JSONResponseKeys.GetStudentLocation.mediaURL] as? String,
            let latitude = data[ParseClient.JSONResponseKeys.GetStudentLocation.latitude] as? Float,
            let longitude = data[ParseClient.JSONResponseKeys.GetStudentLocation.longitude] as? Float,
            let createdAtString = data[ParseClient.JSONResponseKeys.GetStudentLocation.createdAt] as? String,
            let createdAt = dateFormatter.dateFromString(createdAtString),
            let updatedAtString = data[ParseClient.JSONResponseKeys.GetStudentLocation.updatedAt] as? String,
            let updatedAt = dateFormatter.dateFromString(updatedAtString) else {
                throw ParseError.DataParsing
        }
        
        self.init(objectId: objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    init(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, createdAt: NSDate, updatedAt: NSDate) {
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
