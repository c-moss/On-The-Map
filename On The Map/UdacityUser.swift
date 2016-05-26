//
//  UdacityUser.swift
//  On The Map
//
//  Created by Campbell Moss on 23/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

struct UdacityUser {
    
    var firstName: String
    var lastName: String
    
    init(data: [String:AnyObject]) throws {
        guard let user = data[UdacityClient.JSONResponseKeys.User.user] as? [String:AnyObject],
            let firstName = user[UdacityClient.JSONResponseKeys.User.firstName] as? String,
            let lastName = user[UdacityClient.JSONResponseKeys.User.lastName] as? String else {
                throw ParseError.DataParsing
        }
        
        self.init(firstName: firstName, lastName: lastName)
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}
