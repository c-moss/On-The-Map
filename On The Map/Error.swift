//
//  Error.swift
//  On The Map
//
//  Created by Campbell Moss on 10/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation

class Error: CustomStringConvertible {
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
    var description: String {
        return self.message
    }
}

class HTTPError: Error {
    var code: Int
    
    init(message: String, code: Int) {
        self.code = code
        super.init(message: message)
    }
    
    override var description: String {
        return "\(self.code): \(self.message)"
    }
}

class GeneralError: Error {
    var error: NSError
    init(message: String, error: NSError) {
        self.error = error
        super.init(message: message)
    }
    
    override var description: String {
        return "\(self.error.localizedDescription): \(self.message)"
    }
}