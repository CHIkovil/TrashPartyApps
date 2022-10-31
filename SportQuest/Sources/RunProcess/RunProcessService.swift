//
//  RunProcessService.swift
//  SportQuest
//
//  Created by Никита Бычков on 24.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import MapKit

class RunProcessService {
    var target: Target?
    var process: Process!
    var transfer: ((Transfer) -> ())?
    var timer: Timer?
    
    init(data: Mode?) {
        target = parseTargetData(data: data)
        self.process = Process(time: 0, coordinates: [], distance: 0, save: nil)
    }
    
    func parseTargetData(data: Mode?) -> Target? {
        guard let data = data else{
            return nil
        }
        let coordinates: [CLLocationCoordinate2D] = data.coordinates!.split(separator: ",").map {data in
            let point = data.split(separator: " ")
            let latitude = Double(point[0])
            let longitude = Double(point[1])
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
        
        let countInterval = Int(data.countInterval!)!
        let timeInterval = getSeconds(data: data.time!) / countInterval
        var stages = coordinates.chunked(into: coordinates.count / countInterval)
        if countInterval != stages.count{
            let last = stages[stages.count - 1]
            stages.remove(at: stages.count - 1)
            stages[stages.count - 1] += last
        }
        let points: [(CLLocationCoordinate2D, Int)] = stages.enumerated().map {index,stage in
            return (stage[stage.count - 1], timeInterval * (index + 1))
        }
        return Target(coordinates: coordinates, stages: stages, points: points, result: [], numStage: 0)
        
    }
        
    func getTarget(callback:(Target?) -> Void) {
        callback(target)
    }
    
    //MARK: SUPPORT FUNC
    
    func getSeconds(data: String) -> Int{
        let dropString = data.split(separator: ":")
        return Int(dropString[0])! * 3600 + Int(dropString[1])! * 60 + Int(dropString[2])!
    }
}


