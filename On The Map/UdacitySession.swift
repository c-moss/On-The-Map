//
//  UdacitySession.swift
//  On The Map
//
//  Created by Campbell Moss on 2/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

class UdacitySession : NSObject {
    
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
    

    init(account: accountType, session: sessionType) {
        self.account = account
        self.session = session
        super.init()
    }

    
    class func convertDataWithCompletionHandler(data: AnyObject, completion: (sessionModel: UdacitySession?, error: Error?) -> Void) {
        let session: sessionType
        let account: accountType
        
        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S'Z'"
        
        if let accountData = data[UdacityClient.JSONResponseKeys.PostSession.Account] as? [String:AnyObject],
            let accountRegistered = accountData[UdacityClient.JSONResponseKeys.PostSession.AccountRegistered] as? Bool,
            let accountKey = accountData[UdacityClient.JSONResponseKeys.PostSession.AccountKey] as? String {
                account = UdacitySession.accountType(registered: accountRegistered, key: accountKey)
        } else {
            completion(sessionModel: nil, error: Error(message: "Error parsing account data"))
            return
        }
        
        if let sessionData = data[UdacityClient.JSONResponseKeys.PostSession.Session] as? [String:AnyObject],
            let sessionID = sessionData[UdacityClient.JSONResponseKeys.PostSession.SessionID] as? String,
            let sessionExpirationString = sessionData[UdacityClient.JSONResponseKeys.PostSession.SessionExpiration] as? String,
            let sessionExpiration = dateFormatter.dateFromString(sessionExpirationString) {
                session = UdacitySession.sessionType(id: sessionID, expiration: sessionExpiration)
        } else {
            completion(sessionModel: nil, error: Error(message: "Error parsing session data"))
            return
        }
        
        completion(sessionModel: UdacitySession(account: account, session: session), error: nil)
    }
}