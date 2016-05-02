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

    
    class func convertDataWithCompletionHandler(data: [String:AnyObject], completion: (result: UdacitySession?, error: NSError?) -> Void) {
        let session: sessionType
        let account: accountType
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "2015-05-10T16:48:30.760460Z"
        "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z.'S"
        if let accountData = data[UdacityClient.JSONResponseKeys.PostSession.Account] as? [String:AnyObject],
            let accountRegistered = accountData[UdacityClient.JSONResponseKeys.PostSession.AccountRegistered] as? Bool,
            let accountKey = accountData[UdacityClient.JSONResponseKeys.PostSession.AccountKey] as? String {
                account = UdacitySession.accountType(registered: accountRegistered, key: accountKey)
        } else {
            completion(result: nil, error: ServiceClient.createError("UdacitySession.convertDataWithCompletionHandler", error: "Error parsing account data"))
            return
        }
        
        if let sessionData = data[UdacityClient.JSONResponseKeys.PostSession.Session] as? [String:AnyObject],
            let sessionID = sessionData[UdacityClient.JSONResponseKeys.PostSession.SessionID] as? String,
            let sessionExpirationString = sessionData[UdacityClient.JSONResponseKeys.PostSession.SessionExpiration] as? String,
            let sessionExpiration = dateFormatter.dateFromString(sessionExpirationString) {
                session = UdacitySession.sessionType(id: sessionID, expiration: sessionExpiration)
        } else {
            completion(result: nil, error: ServiceClient.createError("UdacitySession.convertDataWithCompletionHandler", error: "Error parsing session data"))
            return
        }
        
        completion(result: UdacitySession(account: account, session: session), error: nil)
    }
}