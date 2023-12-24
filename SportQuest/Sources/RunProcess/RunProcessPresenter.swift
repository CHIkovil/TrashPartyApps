//
//  RunProcessPresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 24.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class RunProcessPresenter {
    private let runProcessService:RunProcessService
    weak private var runProcessViewDelegate : RunProcessViewDelegate?
    
    init(runProcessService:RunProcessService){
        self.runProcessService = runProcessService
        runProcessService.process.save = {[weak self] data in
            guard let self = self else {return}
            self.saveRunData(regionImage: data)
        }
    }
    
    func setViewDelegate(runProcessViewDelegate:RunProcessViewDelegate?){
        self.runProcessViewDelegate = runProcessViewDelegate
    }
    
    func setTargetMode() {
        runProcessService.getTarget {[weak self] data in
            guard let self = self else{return}
            self.runProcessViewDelegate?.startTargetMode(data: data)
        }
    }
    
    func startTimer() {
        runProcessService.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] tempTimer in
            guard let self = self else { return }
            self.runProcessService.process.time += 1
            let data = self.secondsToHoursMinutesSeconds(seconds: self.runProcessService.process.time)
            self.runProcessViewDelegate?.displayRunTime(data: data)
        }
        
    }
    
    func stopTimer() {
        runProcessService.timer!.invalidate()
        runProcessService.timer = nil
    }
    
    func setRunRegion() {
        runProcessService.getTarget {[weak self] target in
            guard let self = self else{return}
            if runProcessService.process.distance < 100{
                self.runProcessViewDelegate?.completedRunRegion(data: nil)
            }
            let coordinates:[CLLocationCoordinate2D]!
            if target != nil && target?.numStage == nil {
                coordinates = target?.coordinates
            }else{
                coordinates = self.runProcessService.process.coordinates
            }
            let runLatitude = coordinates.map {$0.latitude}
            let runLongitude = coordinates.map {$0.longitude}

            let minLatitude = runLatitude.min()!
            let minLongitude = runLongitude.min()!
            let maxLatitude = runLatitude.max()!
            let maxLongitude = runLongitude.max()!

            let c1 = CLLocation(latitude: minLatitude, longitude: minLongitude)

            let c2 = CLLocation(latitude: maxLatitude, longitude: maxLongitude)

            let zoom = c1.distance(from: c2)

            let location = CLLocationCoordinate2D(latitude: (maxLatitude+minLatitude)*0.5, longitude: (maxLongitude+minLongitude)*0.5)
            let region = MKCoordinateRegion(center: location, latitudinalMeters: zoom + 100, longitudinalMeters: zoom + 100)
            self.runProcessViewDelegate?.completedRunRegion(data: region)
        }
    }
    
    func setSnapshotRegion(region: MKCoordinateRegion, size: CGSize) {
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = size
        options.scale = UIScreen.main.scale
        options.traitCollection = .init(userInterfaceStyle: .dark)
        
        let snapshotter = MKMapSnapshotter(options: options)
        
        snapshotter.start {[weak self] snapshot, error in
            guard let snapshot = snapshot, let self = self else{return}
            let image = self.drawLineToImage(snapshot: snapshot, size: size)
            let resizeImage = image.resize(newSize: CGSize(width: 40, height: 40))
            self.runProcessService.process.regionImage = resizeImage.pngData()
        }
    }
    
    func saveRunData(regionImage: Data) {
        runProcessService.getTarget {[weak self] target in
            guard let self = self else{return}
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "RunData", in: context)
            let newRunData = NSManagedObject(entity: entity!, insertInto: context)
            
            let process = self.runProcessService.process!
            
            let coordinates:[CLLocationCoordinate2D]!
            if target != nil && target?.numStage == nil {
                coordinates = target?.coordinates
            }else{
                coordinates = process.coordinates
            }
            
            let formatCoordinates: String = coordinates.map {String($0.latitude) + " " + String($0.longitude)}.joined(separator: ",")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let currentDate = dateFormatter.string(from: Date())
            
            newRunData.setValue(formatCoordinates, forKey: "coordinates")
            newRunData.setValue(process.time, forKey: "time")
            newRunData.setValue(process.distance, forKey: "distance")
            newRunData.setValue(currentDate, forKey: "date")
            newRunData.setValue(regionImage, forKey: "regionImage")
          
            do{
                try context.save()
                if let transfer = runProcessService.transfer {
                    transfer(Transfer(time: process.time, distance: process.distance, coordinates: formatCoordinates, currentDate: currentDate, regionImage: regionImage))
                }
            }catch{
                print(error.localizedDescription)
            }
            self.runProcessViewDelegate?.completedRun()
        }

    }
        
    func checkStageTargetMode(coordinate: CLLocationCoordinate2D, formatTime: String) {
        runProcessService.getTarget {[weak self] data in
            guard let target = data, let self = self, let numStage = data?.numStage else {
                return
            }
            let to = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let from = CLLocation(latitude: target.points[numStage].coordinate.latitude, longitude: target.points[numStage].coordinate.longitude)
            let distanceBeforeStage = from.distance(from: to)
            
            if distanceBeforeStage <= 5 {
                if runProcessService.getSeconds(data: formatTime) < target.points[numStage].time {
                    runProcessService.target?.result.append(true)
                }else{
                    runProcessService.target?.result.append(false)
                }
                self.runProcessViewDelegate?.completedStageTargetMode(data: (target.stages[numStage],(runProcessService.target?.result.last)!))
                
                if (runProcessService.target?.result.count)! < target.points.count{
                    runProcessService.target?.numStage? += 1
                    self.runProcessViewDelegate?.displayNewPointTargetMode(data: target.points[numStage + 1].coordinate)
                }else{
                    runProcessService.target?.numStage = nil
                }
            
            }
        }
    }
    
    func addNewCoordinate(coordinate: CLLocationCoordinate2D) {
        runProcessService.process.coordinates.append(coordinate)
        self.runProcessViewDelegate?.displayLocationOnMap(data: (coordinate, "Warrior"))
        
        let coordinates = runProcessService.process.coordinates
        if coordinates.count > 1{
            let to = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let from = CLLocation(latitude: coordinates[coordinates.count - 2].latitude, longitude: coordinates[coordinates.count - 2].longitude)
            let newDistance = from.distance(from: to)
            runProcessService.process.distance += Int(newDistance)
            
            let distance = runProcessService.process.distance
            let formatDistance: String!
            if newDistance / 1000 >= 1.0 {
                 formatDistance = String(distance / 1000) + "km" + " " + String(distance % 1000) + "m"
            }
            else{
                formatDistance = String(distance) + "m"
            }
            
            let coordinatesNewDistance = [coordinates[coordinates.count - 2], coordinates.last!]
            
            self.runProcessViewDelegate?.displayNewDistance(data: (coordinatesNewDistance, formatDistance))
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func drawLineToImage(snapshot: MKMapSnapshotter.Snapshot , size: CGSize) -> UIImage {
        let image = snapshot.image

        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        image.draw(at: CGPoint.zero)

        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(6.0)
        
        switch runProcessService.target {
        case let target?:
            if target.result.count == target.points.count {
                context!.move(to: snapshot.point(for: target.stages[0][0]))
                for (number, stage) in target.stages.enumerated(){
                    if target.result[number]{
                        context!.setStrokeColor(UIColor.green.cgColor)
                    }else{
                        context!.setStrokeColor(UIColor.red.cgColor)
                    }
                    for i in 0..<stage.count {
                        context!.addLine(to: snapshot.point(for: stage[i]))
                        context!.move(to: snapshot.point(for: stage[i]))
                    }
                }
            }else {
                fallthrough
            }
        default:
            let coordinates = runProcessService.process.coordinates
            context!.setStrokeColor(UIColor.yellow.cgColor)
            
            context!.move(to: snapshot.point(for: coordinates[0]))
            for i in 0..<coordinates.count {
                context!.addLine(to: snapshot.point(for: coordinates[i]))
                context!.move(to: snapshot.point(for: coordinates[i]))
            }
        }

        context!.strokePath()

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return resultImage!
    }
}

//MARK: SUPPORT EXCENSION

extension UIImage {
    func resize(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { [weak self] _ in
            guard let self = self else{return}
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }

        return image.withRenderingMode(self.renderingMode)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
