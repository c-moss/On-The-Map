//
//  StudentAllocation.swift
//  On The Map
//
//  Created by Campbell Moss on 31/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import Foundation
import MapKit

// subclass of MKPointAnnotation that represents a student location
class StudentAnnotation: MKPointAnnotation {
    
    var student: StudentInformation
    
    init(student: StudentInformation) {
        self.student = student
        super.init()
        
        let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
        
        self.title = "\(student.firstName) \(student.lastName)"
        self.subtitle = student.mediaURL

        self.coordinate = coordinate
    }
}