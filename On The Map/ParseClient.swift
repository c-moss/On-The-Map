//
//  ParseClient.swift
//  On The Map
//
//  Created by Campbell Moss on 10/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

class ParseClient : ServiceClient {
    
    // create a URL from parameters
    class func parseURLFromParameters(parameters: [String:String], withPathExtension: String? = nil) -> NSURL {
        return super.urlFromParameters(Constants.ApiScheme, host: Constants.ApiHost, path: Constants.ApiPath, parameters: parameters, withPathExtension: withPathExtension)
    }
}