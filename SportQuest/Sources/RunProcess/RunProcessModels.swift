//
//  RunProcessModels.swift
//  SportQuest
//
//  Created by Nikolas on 08.02.2022.
//  Copyright © 2022 Никита Бычков. All rights reserved.
//

import Foundation
import MapKit
import Dispatch

enum RunProcessModels {
    struct Target {
        let coordinates: [CLLocationCoordinate2D]
        let stages: [[CLLocationCoordinate2D]]
        let points: [(coordinate:CLLocationCoordinate2D, time:Int)]
        var result: [Bool]
        var numStage: Int?
        
    }
    
    struct Process {
        var time:Int
        var coordinates: [CLLocationCoordinate2D]
        var distance: Int
        var regionImage: Data? {
            get{return nil}
            set{
                guard let newValue = newValue, let save = save else{return}
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    save(newValue)
                }
            }
        }
        var save: ((Data) -> Void)?
    }
    
    struct Transfer {
        let time: Int
        let distance: Int
        let coordinates:String
        let currentDate:String
        let regionImage: Data
    }
}

typealias Transfers = [RunProcessModels.Transfer]
typealias Transfer = RunProcessModels.Transfer
typealias Target = RunProcessModels.Target
typealias Process = RunProcessModels.Process
