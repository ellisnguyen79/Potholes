//
//  point.swift
//  cpe190
//
//  Created by Ellis Nguyen on 3/7/18.
//  Copyright © 2018 Ellis Nguyen. All rights reserved.
//

import Foundation
import MapKit


class point: NSObject, MKAnnotation{
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    let value: Int
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.value = 0
        
        super.init()
    }
    
    
    init(title: String, coordinate: CLLocationCoordinate2D,value: Int) {
        self.title = title
        self.coordinate = coordinate
        self.value = value
        
        super.init()
    }
    
}
    

