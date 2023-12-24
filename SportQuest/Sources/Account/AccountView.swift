//
//  AccountView.swift
//  SportQuest
//
//  Created by Никита Бычков on 14.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import Charts

class AccountView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.addSubview(backgroundImageView)
        self.addSubview(skillsChartView)
        
        self.addSubview(backgroundUserImageView)
        self.addSubview(userImageView)
        
        self.addSubview(levelLabel)
        self.addSubview(lineLevelLabel)
        self.addSubview(lineCompleteAchieveLabel)
        self.addSubview(achievePointsLabel)
        self.addSubview(setupDistanceLabel)
        self.addSubview(setupDistanceTextField)
        
        self.addSubview(achieveButton)
        self.addSubview(logOutButton)
        self.addSubview(changeNormDistanceButton)
        
        createConstraintsBackgroundImageView()
        createConstraintsSkillsChartView()
        
        createConstraintsBackgroundUserImageView()
        createConstraintsUserImageView()
        
        createConstraintsLevelLabel()
        createConstraintsLineLevelLabel()
        createConstraintsLineCompleteAchieveLabel()
        createConstraintsAchievePointsLabel()
        createConstraintsSetupDistanceLabel()
        
        createConstraintsSetupDistanceTextField()
        
        createConstraintsAchieveButton()
        createConstraintsLogOutButton()
        createConstraintsChangeNormDistanceButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    lazy var skillsChartView: RadarChartView = {
        let chart = RadarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .clear
        chart.chartDescription?.enabled = false
        chart.webLineWidth = 1
        chart.innerWebLineWidth = 1
        chart.webColor = .white
        chart.innerWebColor = .white
        chart.webAlpha = 1
        
        chart.legend.enabled = false
        chart.legend.horizontalAlignment = .center
        chart.legend.verticalAlignment = .top
        chart.legend.orientation = .horizontal
        
        chart.xAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        chart.xAxis.xOffset = 0
        chart.xAxis.yOffset = 0
        chart.xAxis.labelTextColor = .white
        chart.yAxis.labelFont = .systemFont(ofSize: 14, weight: .light)
        chart.yAxis.labelCount = 3
        chart.yAxis.axisMinimum = 0
        chart.yAxis.drawLabelsEnabled = false
        
        chart.noDataText = "Not data"
        chart.noDataFont = UIFont(name: "TrebuchetMS", size: 18)!
        chart.noDataTextColor = .white
        chart.yAxis.labelTextColor = .white
        chart.alpha = 1
        return chart
    }()
    
    lazy var backgroundUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 90
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.loadGif(name: "infinitely")
        imageView.alpha = 0.9
        return imageView
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadGif(name: "master")
        imageView.alpha = 0.7
        return imageView
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "blackhole.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.alpha = 0.25
        return imageView
    }()
    
    lazy var setupDistanceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 15
        textField.isEnabled = false
        return textField
    }()
    
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lvl 0"
        label.font = UIFont(name: "Chalkduster", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.clear.cgColor
        label.alpha = 0.9
        return label
    }()
    
    lazy var lineCompleteAchieveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.alpha = 0.8
        return label
    }()
    
    lazy var lineLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = #colorLiteral(red: 0.2251939178, green: 0.2391367555, blue: 0.2651286721, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.alpha = 1
        return label
    }()
    
    lazy var achievePointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Chalkduster", size: 13)
        label.textAlignment = .center
        label.text = "+0"
        label.textColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.clear.cgColor
        label.alpha = 0.8
        return label
    }()
    
    lazy var setupDistanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Distance(m)"
        label.font = UIFont(name: "Chalkduster", size: 15)
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.clear.cgColor
        return label
    }()
    
    lazy var achieveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"wreath.png"), for: .normal)
        button.alpha = 0.85
        return button
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"logout.png"), for: .normal)
        button.alpha = 0.8
        return button
    }()
    
    lazy var changeNormDistanceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.isEnabled = false
        button.setImage(UIImage(named:"lock.png"), for: .normal)
        button.alpha = 0.85
        return button
    }()
    
    // MARK: CONSTRAINTS

    func createConstraintsSkillsChartView() {
        skillsChartView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 0).isActive = true
        skillsChartView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor).isActive = true
        skillsChartView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 300).isActive = true
        skillsChartView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    func createConstraintsBackgroundImageView() {
        backgroundImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: -50).isActive = true
        backgroundImageView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        backgroundImageView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -250).isActive = true
        backgroundImageView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  250).isActive = true
    }
    
    func createConstraintsBackgroundUserImageView() {
        backgroundUserImageView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        backgroundUserImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        backgroundUserImageView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 180).isActive = true
        backgroundUserImageView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    func createConstraintsUserImageView() {
        userImageView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 150).isActive = true
        userImageView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 180).isActive = true
        userImageView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }

    func createConstraintsSetupDistanceTextField() {
        setupDistanceTextField.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: changeNormDistanceButton.centerYAnchor).isActive = true
        setupDistanceTextField.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: changeNormDistanceButton.leadingAnchor, constant: -15).isActive = true
        setupDistanceTextField.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func createConstraintsLevelLabel() {
        levelLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: lineLevelLabel.leadingAnchor,constant: -10).isActive = true
        levelLabel.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: lineLevelLabel.centerYAnchor).isActive = true
    }
    
    func createConstraintsLineCompleteAchieveLabel() {
        lineCompleteAchieveLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: lineLevelLabel.leadingAnchor).isActive = true
        lineCompleteAchieveLabel.safeAreaLayoutGuide.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        lineCompleteAchieveLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: lineLevelLabel.topAnchor).isActive = true
        lineCompleteAchieveLabel.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: lineLevelLabel.bottomAnchor).isActive = true
    }
    
    func createConstraintsLineLevelLabel() {
        lineLevelLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: skillsChartView.bottomAnchor, constant: -30).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: skillsChartView.centerXAnchor).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func createConstraintsAchievePointsLabel() {
        achievePointsLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: lineLevelLabel.bottomAnchor, constant: 5).isActive = true
        achievePointsLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: lineLevelLabel.leadingAnchor,constant: 5).isActive = true
    }
    
    func createConstraintsSetupDistanceLabel() {
        setupDistanceLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: setupDistanceTextField.leadingAnchor,constant:  -10).isActive = true
        setupDistanceLabel.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: setupDistanceTextField.centerYAnchor).isActive = true
    }
    
    func createConstraintsAchieveButton() {
        achieveButton.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: lineLevelLabel.centerYAnchor).isActive = true
        achieveButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: lineLevelLabel.trailingAnchor, constant: 10).isActive = true
        achieveButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 60).isActive = true
        achieveButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func createConstraintsLogOutButton() {
        logOutButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
        logOutButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        logOutButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logOutButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func createConstraintsChangeNormDistanceButton() {
        changeNormDistanceButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: achieveButton.bottomAnchor, constant: 30).isActive = true
        changeNormDistanceButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: achieveButton.centerXAnchor).isActive = true
        changeNormDistanceButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
        changeNormDistanceButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
