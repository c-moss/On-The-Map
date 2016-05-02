//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Campbell Moss on 2/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey : String = "4e8bdccc3bb63cefbec21f936eca5651"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Session
        static let Session = "/session"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: POST session
        struct PostSession {
            static let Account = "account"
            static let AccountRegistered = "registered"
            static let AccountKey = "key"
            static let Session = "session"
            static let SessionID = "id"
            static let SessionExpiration = "expiration"
        }
    }
    
    enum UdacityClientError: ErrorType {
        case ParsingError
    }
    
}