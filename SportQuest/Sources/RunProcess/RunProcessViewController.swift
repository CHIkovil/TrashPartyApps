//
//  RunProcessViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 01.12.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import CoreLocation
import SwiftGifOrigin
import CoreData
import Dispatch


protocol RunProcessViewDelegate: NSObjectProtocol {
    func startTargetMode(data: Target?)
    func displayRunTime(data: (hours:Int,minutes:Int,seconds:Int))
    func completedRunRegion(data: MKCoordinateRegion?)
    func completedRun()
    
    func completedStageTargetMode(data: (coordinates: [CLLocationCoordinate2D], result: Bool))
    func displayNewPointTargetMode(data: CLLocationCoordinate2D)
    func displayLocationOnMap(data: (coordinate: CLLocationCoordinate2D,title: String))
    func displayNewDistance(data: (coordinates: [CLLocationCoordinate2D], formatDistance: String))
}
class RunProcessViewController: UIViewController {
    
    private var customTransitioningDelegate = TransitionDelegate()
    
    var runProcessView:RunProcessView!
    var runProcessPresenter:RunProcessPresenter!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runProcessPresenter.setViewDelegate(runProcessViewDelegate: self)
        view.frame.size = CGSize(width: 300, height: 300)
        runProcessView = RunProcessView(frame: view.frame)
        view.addSubview(runProcessView)
        
        runProcessView.stopRunButton.addTarget(self, action: #selector(stopRun), for: .touchUpInside)
        
        runProcessView.runLocationManager.delegate = self
        runProcessView.runMapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        runProcessView.runLocationManager.startUpdatingLocation()
        runProcessView.runLocationManager.startUpdatingHeading()
        runProcessView.runLocationManager.requestWhenInUseAuthorization()
        runProcessPresenter.setTargetMode()
        runProcessPresenter.startTimer()
    }
    
    //MARK: OBJC
    
    @objc func stopRun() {
        runProcessView.displayLoader()
        runProcessView.runLocationManager.stopUpdatingLocation()
        runProcessView.runLocationManager.stopUpdatingHeading()
        
        runProcessPresenter.stopTimer()
        runProcessPresenter.setRunRegion()
    }
    
    //MARK: SUPPORT FUNC
    
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}

//MARK: DELEGATE

extension RunProcessViewController:RunProcessViewDelegate {
    
    func startTargetMode(data: Target?) {
        guard let target = data else{return}
        let point = MKPointAnnotation()
        point.title = "PointStage"
        point.coordinate = target.points[0].coordinate
        runProcessView.runMapView.addAnnotation(point)
        
        let polyline = MKPolyline(coordinates: target.coordinates, count: target.coordinates.count)
        polyline.title = "TargetDistance"
        runProcessView.runMapView.addOverlay(polyline)
        
        for (title, location) in [("Start", target.coordinates[0]), ("Finish", target.coordinates[target.coordinates.count - 1])] {
            let point = MKPointAnnotation()
            point.title = title
            point.coordinate = location
            runProcessView.runMapView.addAnnotation(point)
        }
    }
    
    func displayRunTime(data:(hours:Int,minutes:Int,seconds:Int)) {
        runProcessView.runTimerLabel.text = String(format:"%02i:%02i:%02i", data.hours, data.minutes, data.seconds)
    }
    
    func completedRunRegion(data: MKCoordinateRegion?) {
        guard let data = data else {
            self.completedRun()
            return
        }
        
        runProcessPresenter.setSnapshotRegion(region: data, size: runProcessView.runMapView.frame.size)
    }
    
    func completedRun(){
        self.dismiss(animated: true)
    }
    
    func completedStageTargetMode(data: (coordinates: [CLLocationCoordinate2D], result: Bool)){
        let polyline = MKPolyline(coordinates: data.coordinates, count: data.coordinates.count)
        if data.result{
            polyline.title = "TargetStageTrue"
        } else{
            polyline.title = "TargetStageFalse"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.runProcessView.runMapView.addOverlay(polyline)
        }
    }
    
    func displayNewPointTargetMode(data: CLLocationCoordinate2D){
        let point = MKPointAnnotation()
        point.title = "PointStage"
        point.coordinate = data
        runProcessView.runMapView.addAnnotation(point)
    }
    
    func displayLocationOnMap(data:(coordinate: CLLocationCoordinate2D,title: String)) {
        for annotation in runProcessView.runMapView.annotations {
            if annotation.title != "Start" && annotation.title != "Finish" && annotation.title != "PointStage"{
                runProcessView.runMapView.removeAnnotation(annotation)
            }
        }
        let point = MKPointAnnotation()
        point.title = data.title
        point.coordinate = data.coordinate
        runProcessView.runMapView.addAnnotation(point)
        let viewRegion = MKCoordinateRegion(center: data.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        runProcessView.runMapView.setRegion(viewRegion, animated: true)
    }
    
    func displayNewDistance(data: (coordinates: [CLLocationCoordinate2D], formatDistance: String)){
        let polyline = MKPolyline(coordinates: data.coordinates, count: 2)
        runProcessView.runMapView.addOverlay(polyline)
        runProcessView.runDistanceLabel.text = data.formatDistance
    }
}

extension RunProcessViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
        switch annotation.title {
        case "Start":
            annotationView.image = UIImage(named: "start.png")
            return annotationView
        case "Finish":
            annotationView.image = UIImage(named: "finish.png")
            return annotationView
        case "PointStage":
            annotationView.image = UIImage(named: "point.png")
            return annotationView
        default:
            
            annotationView.image = UIImage(named: "miniBlackhole.png")
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let polyline = MKPolylineRenderer(overlay: overlay)
            
            switch overlay.title {
            case "TargetStageTrue":
                polyline.strokeColor = UIColor.green
            case "TargetStageFalse":
                polyline.strokeColor = UIColor.red
            case "TargetDistance":
                polyline.strokeColor = UIColor.white
            default:
                polyline.strokeColor = UIColor.yellow
            }
            
            polyline.lineWidth = 3
            return polyline
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}

extension RunProcessViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else{
            return
        }
        
        runProcessPresenter.checkStageTargetMode(coordinate: coordinate, formatTime: runProcessView.runTimerLabel.text!)
        runProcessPresenter.addNewCoordinate(coordinate: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        runProcessView.runMapView.camera.heading = newHeading.magneticHeading
        runProcessView.runMapView.setCamera(runProcessView.runMapView.camera, animated: true)
    }
}
