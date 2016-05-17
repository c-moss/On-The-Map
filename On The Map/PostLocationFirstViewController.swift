//
//  PostLocationFirstViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 17/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

class PostLocationFirstViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var findButton: UIButton!
    
    @IBOutlet weak var locationPlaceholder: UILabel!
    
    @IBOutlet weak var locationTextView: UITextView!
    
    override func viewWillAppear(animated: Bool) {
        findButton.layer.cornerRadius = 10
    }
    
    //MARK: fake placeholder for UITextView
    func textViewDidBeginEditing(textView: UITextView) {
        locationPlaceholder.hidden = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        locationPlaceholder.hidden = textView.hasText()
    }

}
