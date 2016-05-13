//
//  Model.swift
//  On The Map
//
//  Created by Campbell Moss on 14/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

class Model : NSObject {
    
    // MARK: Shared Instance
    class func sharedInstance() -> Model {
        struct Singleton {
            static var sharedInstance = Model()
        }
        return Singleton.sharedInstance
    }
    
    var sessionData:UdacitySession?
    var studentInformationData: [StudentInformation]?
    
    override init() {
        super.init()
    }
}