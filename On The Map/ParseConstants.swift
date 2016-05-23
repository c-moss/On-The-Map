//
//  ParseConstants.swift
//  On The Map
//
//  Created by Campbell Moss on 10/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: Application ID
        static let ApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: API Key
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: StudentLocation
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: StudentLocation
        struct StudentLocation {
            static let results : String = "results"
            static let objectId : String = "objectId"
            static let uniqueKey : String = "uniqueKey"
            static let firstName : String = "firstName"
            static let lastName : String = "lastName"
            static let mapString : String = "mapString"
            static let mediaURL : String = "mediaURL"
            static let latitude : String = "latitude"
            static let longitude : String = "longitude"
            static let createdAt : String = "createdAt"
            static let updatedAt : String = "updatedAt"
            static let ACL : String = "ACL"
        }
    }
}