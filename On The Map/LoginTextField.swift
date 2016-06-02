//
//  LoginTextField.swift
//  On The Map
//
//  Created by Campbell Moss on 2/06/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

//We have to subclass textfield to set padding :(
class LoginTextField: UITextField {
    
//    required init?(coder aDecoder: NSCoder){
//        super.init(coder: aDecoder)
//    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8, bounds.size.width - 20, bounds.size.height - 16);
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds);
    }
}
