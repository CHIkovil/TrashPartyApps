//
//  ProgressMapModels.swift
//  SportQuest
//
//  Created by Nikolas on 08.02.2022.
//  Copyright © 2022 Никита Бычков. All rights reserved.
//

import Foundation
import MapKit

enum ProgressMapModels {
    struct Progress {
        let coordinates: [CLLocationCoordinate2D]
        let info: NSMutableAttributedString
    }
    struct Distance {
        let polyline:MKPolyline
        let region:MKCoordinateRegion
        let startCoordinate: CLLocationCoordinate2D
        let endCoordinate: CLLocationCoordinate2D
    }
}

typealias Progress = ProgressMapModels.Progress
typealias Distance = ProgressMapModels.Distance
