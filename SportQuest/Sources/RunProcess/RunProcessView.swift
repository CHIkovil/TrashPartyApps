//
//  RunProcessView.swift
//  SportQuest
//
//  Created by Никита Бычков on 24.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class RunProcessView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 45
        self.backgroundColor = .white
        self.addSubview(backgroundImageView)
        self.addSubview(runMapView)
        self.addSubview(runTimerLabel)
        self.addSubview(runDistanceLabel)
        self.addSubview(stopRunButton)
        
        createConstraintsBackgroundImageView()
        createConstraintsRunMapView()
        createConstraintsRunTimerLabel()
        createConstraintsRunDistanceLabel()
        createConstraintsStopRunButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    lazy var runLocationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        return locationManager
    }()
    
    lazy var loadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadGif(name: "fire")
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadGif(name: "step")
        imageView.layer.cornerRadius = 45
        imageView.layer.masksToBounds = true
        imageView.alpha = 0.9
        return imageView
    }()
    
    lazy var runMapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 45
        view.overrideUserInterfaceStyle = .dark
        view.alpha = 0.95
        return view
    }()
    
    lazy var runTimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00:00"
        label.font = UIFont(name: label.font.fontName, size: 32)
        label.textColor = .white
        return label
    }()
    
    lazy var runDistanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: label.font.fontName, size: 20)
        label.text = "0m"
        label.textColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        return label
    }()
    
    lazy var stopRunButton: UIButton = {
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: 60, height: 60))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"prize.png"), for: .normal)
        button.alpha = 0.7
        return button
    }()
    
    //MARK: CONSTRAINTS

    func createConstraintsRunMapView() {
        runMapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        runMapView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        runMapView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        runMapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func createConstraintsBackgroundImageView() {
        backgroundImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    func createConstraintsRunTimerLabel() {
        runTimerLabel.topAnchor.constraint(equalTo: runMapView.bottomAnchor, constant: 10).isActive = true
        runTimerLabel.centerXAnchor.constraint(equalTo:  self.centerXAnchor).isActive = true
        runTimerLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        runTimerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func createConstraintsRunDistanceLabel() {
        runDistanceLabel.topAnchor.constraint(equalTo: runTimerLabel.bottomAnchor).isActive = true
        runDistanceLabel.centerXAnchor.constraint(equalTo:  runTimerLabel.centerXAnchor).isActive = true
        runDistanceLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        runDistanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    

    func createConstraintsStopRunButton() {
        stopRunButton.leadingAnchor.constraint(equalTo: runTimerLabel.trailingAnchor, constant: 10).isActive = true
        stopRunButton.topAnchor.constraint(equalTo: runMapView.bottomAnchor,constant: 20).isActive = true
        stopRunButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        stopRunButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    //MARK: SUPPROT FUNC
    
    func displayLoader() {
        self.addSubview(loadImageView)
        loadImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        loadImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        loadImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        loadImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
