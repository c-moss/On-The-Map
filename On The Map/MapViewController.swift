//
//  MapViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 1/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func reloadData() {
        showErrorAlert(message: "MapViewController.reloadData()")
    }

}

