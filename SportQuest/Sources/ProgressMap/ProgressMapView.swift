//
//  ProgressMapView.swift
//  SportQuest
//
//  Created by Никита Бычков on 22.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import MapKit



class ProgressMapView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(runMapView)
        self.addSubview(runInfoLabel)
        self.addSubview(exitButton)
        self.addSubview(runIntervalLabel)
        self.addSubview(runUpIntervalButton)
        self.addSubview(runDownIntervalButton)
        
        createConstraintsRunMapView()
        createConstraintsRunInfoLabel()
        createConstraintsExitButton()
        createConstraintsRunIntervalLabel()
        createConstraintsRunUpIntervalButton()
        createConstraintsRunDownIntervalButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    lazy var runMapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 45
        view.overrideUserInterfaceStyle = .dark
        view.alpha = 0.9
        return view
    }()
    
    lazy var runInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.clear.cgColor
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    lazy var runIntervalLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2"
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"cancel.png"), for: .normal)
        button.alpha = 0.9
        return button
    }()
    
    lazy var runUpIntervalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0 , width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"plus.png"), for: .normal)
        button.alpha = 0.9
        return button
    }()
    
    lazy var runDownIntervalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0 , width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.isEnabled = false
        button.setImage(UIImage(named:"remove.png"), for: .normal)
        button.alpha = 0.9
        return button
    }()
    
    // MARK: CONSTRAINTS
    
    func createConstraintsRunMapView() {
        runMapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        runMapView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        runMapView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        runMapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func createConstraintsRunInfoLabel() {
        runInfoLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        runInfoLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        runInfoLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 150).isActive = true
        runInfoLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func createConstraintsRunIntervalLabel() {
        runIntervalLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runUpIntervalButton.leadingAnchor).isActive = true
        runIntervalLabel.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: runUpIntervalButton.centerYAnchor).isActive = true
        runIntervalLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 20).isActive = true
        runIntervalLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func createConstraintsExitButton() {
        exitButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func createConstraintsRunUpIntervalButton() {
        runUpIntervalButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runDownIntervalButton.leadingAnchor,constant: -5).isActive = true
        runUpIntervalButton.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: runDownIntervalButton.centerYAnchor).isActive = true
        runUpIntervalButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30).isActive = true
        runUpIntervalButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func createConstraintsRunDownIntervalButton() {
        runDownIntervalButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: exitButton.bottomAnchor,constant: 30).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: exitButton.centerXAnchor).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
