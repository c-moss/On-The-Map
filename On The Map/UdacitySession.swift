//
//  UdacitySession.swift
//  On The Map
//
//  Created by Campbell Moss on 2/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

struct UdacitySession {
    
    struct accountType {
        var registered: Bool
        var key: String
    }
    
    struct sessionType {
        var id: String
        var expiration: NSDate
    }
    
    var account: accountType
    var session: sessionType
    
    //class func convertDataWithCompletionHandler(data: AnyObject, completion: (sessionModel: UdacitySession?, error: Error?) -> Void) {
    init(data: [String:AnyObject]) throws {
        
        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S'Z'"
        
        guard let accountData = data[UdacityClient.JSONResponseKeys.PostSession.Account] as? [String:AnyObject],
            let accountRegistered = accountData[UdacityClient.JSONResponseKeys.PostSession.AccountRegistered] as? Bool,
            let accountKey = accountData[UdacityClient.JSONResponseKeys.PostSession.AccountKey] as? String,
            let sessionData = data[UdacityClient.JSONResponseKeys.PostSession.Session] as? [String:AnyObject],
            let sessionID = sessionData[UdacityClient.JSONResponseKeys.PostSession.SessionID] as? String,
            let sessionExpirationString = sessionData[UdacityClient.JSONResponseKeys.PostSession.SessionExpiration] as? String,
            let sessionExpiration = dateFormatter.dateFromString(sessionExpirationString) else {
                throw ParseError.DataParsing
        }
        
        self.session = UdacitySession.sessionType(id: sessionID, expiration: sessionExpiration)
        self.account = UdacitySession.accountType(registered: accountRegistered, key: accountKey)
    }
}