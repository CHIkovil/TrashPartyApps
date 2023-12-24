//
//  ProgressMapViewController.swift.swift
//  SportQuest
//
//  Created by Никита Бычков on 03.04.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol ProgressMapViewDelegate:NSObjectProtocol {
    func displayRunDistance(distance:Distance?)
    func displayIntervalAnnotation(points:[CLLocationCoordinate2D])
    func displayProgressInfo(text: NSMutableAttributedString)
}
class ProgressMapViewController: UIViewController {
    
    private var customTransitioningDelegate = TransitionDelegate()
    
    var progressMapView:ProgressMapView!
    var progressMapPresenter:ProgressMapPresenter!
    
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
        progressMapPresenter.setViewDelegate(progressMapViewDelegate: self)
        view.frame.size = CGSize(width: 300, height: 300)
        progressMapView = ProgressMapView(frame: view.frame)
        view.addSubview(progressMapView)
        
        progressMapView.exitButton.addTarget(self, action: #selector(exitMap), for: .touchUpInside)
        progressMapView.runUpIntervalButton.addTarget(self, action: #selector(addRunInterval), for: .touchUpInside)
        progressMapView.runDownIntervalButton.addTarget(self, action: #selector(deleteRunInterval), for: .touchUpInside)
        
        progressMapView.runMapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        progressMapPresenter.setRunDistance()
        progressMapPresenter.setIntervalAnnotation(countInterval: Int(self.progressMapView.runIntervalLabel.text!)!)
        progressMapPresenter.setProgressInfo()
    }
    
    //MARK: OBJC
    
    @objc func exitMap() {
        self.dismiss(animated: true)
    }
    
    @objc func addRunInterval() {
        animateIntervalLabel(addValue: 1)
        if Int(progressMapView.runIntervalLabel.text!)! == 9 {
            progressMapView.runUpIntervalButton.isEnabled = false
        }else{
            progressMapView.runDownIntervalButton.isEnabled = true
        }
        progressMapPresenter.setIntervalAnnotation(countInterval: Int(progressMapView.runIntervalLabel.text!)!)
    }
    
    @objc func deleteRunInterval(){
        animateIntervalLabel(addValue: -1)
        if Int(progressMapView.runIntervalLabel.text!)! == 2 {
            progressMapView.runDownIntervalButton.isEnabled = false
        }else{
            progressMapView.runUpIntervalButton.isEnabled = true
        }
        progressMapPresenter.setIntervalAnnotation(countInterval: Int(progressMapView.runIntervalLabel.text!)!)
    }
    
    //MARK: SUPPORT FUNC
    
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}

//MARK: ANIMATION

extension ProgressMapViewController {
    func animateIntervalLabel(addValue: Int) {
        progressMapView.runIntervalLabel.alpha = 0
        UIView.animate(withDuration: 0.5){[weak self] in
            guard let self = self else{return}
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.progressMapView.runIntervalLabel.center.x, y: self.progressMapView.runIntervalLabel.center.y + 20))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.progressMapView.runIntervalLabel.center.x, y: self.progressMapView.runIntervalLabel.center.y))

            self.progressMapView.runIntervalLabel.layer.add(animation, forKey: "position")
            self.progressMapView.runIntervalLabel.text = String(Int(self.progressMapView.runIntervalLabel.text!)! + addValue)
            self.progressMapView.runIntervalLabel.alpha = 1
        }
    }
}

//MARK: DELEGATE

extension ProgressMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let title = annotation.title else {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: title)
        switch annotation.title {
        case "Start":
            annotationView.image =  UIImage(named: "start.png")?.alpha(0.8)
            return annotationView
        case "Finish":
            annotationView.image = UIImage(named: "finish.png")?.alpha(0.8)
            return annotationView
        default:
            annotationView.image = UIImage(named: "point.png")
            return annotationView
    
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = UIColor.yellow
            polyline.lineWidth = 5
            return polyline
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension ProgressMapViewController:ProgressMapViewDelegate {
    
    func displayRunDistance(distance:Distance?) {
        guard let distance = distance else {
            self.dismiss(animated: true)
            return
        }
        
        for (title, location) in [("Start", distance.startCoordinate), ("Finish", distance.endCoordinate )] {
            let point = MKPointAnnotation()
            point.title = title
            point.coordinate = location
            progressMapView.runMapView.addAnnotation(point)
        }
       
        progressMapView.runMapView.addOverlay(distance.polyline)
        progressMapView.runMapView.setRegion(distance.region, animated: true)
    }
    
    func displayIntervalAnnotation(points:[CLLocationCoordinate2D]) {
        for annotation in progressMapView.runMapView.annotations {
            if annotation.title != "Start" && annotation.title != "Finish"{
                progressMapView.runMapView.removeAnnotation(annotation)
            }
        }
        
        for (index,coordinate) in points.enumerated() {
            let point = MKPointAnnotation()
            point.title = String(index)
            point.coordinate = coordinate
            progressMapView.runMapView.addAnnotation(point)
        }
     }
    
    func displayProgressInfo(text: NSMutableAttributedString) {
        progressMapView.runInfoLabel.attributedText = text
    }
}

//MARK: UI EXTENSION

private extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
