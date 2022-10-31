//
//  AuthorizationView.swift
//  SportQuest
//
//  Created by Никита Бычков on 18.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DWAnimatedLabel
import WCLShineButton


class AuthorisationView: UIView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backgroundImageView)
        self.addSubview(nicknameField)
        self.addSubview(passwordField)
        self.addSubview(applicationTitleLabel)
        self.addSubview(authorizationButton)
        self.addSubview(registrationButton)
        
        createConstraintsBackgroundImageView()
        createConstraintsNicknameField()
        createConstraintsPasswordField()
        createConstraintsApplicationTitleLabel()
        createConstraintsAuthorizationButton()
        createConstraintsRegistrationButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadGif(name: "running")
        return imageView
    }()
    
    lazy var applicationTitleLabel: DWAnimatedLabel = {
        let label = DWAnimatedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SportQuest"
        label.font = UIFont(name: "Chalkduster", size: 55)
        label.textColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        label.alpha = 0.9
        label.textAlignment = .center
        label.animationType = .shine
        return label
    }()

    lazy var nicknameField: YoshikoTextField = {
        let textField = YoshikoTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Nickname"
        textField.placeholderColor = .white
        textField.placeholderFontScale = 1.2
        textField.activeBackgroundColor = .white
        textField.activeBorderColor = .white
        textField.inactiveBorderColor = .black
        textField.borderSize = 0.5
        textField.textColor = .black
        textField.tintColor = .clear
        textField.alpha = 0.85
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    lazy var passwordField: YoshikoTextField = {
        let textField = YoshikoTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.placeholderColor = .white
        textField.placeholderFontScale = 1.2
        textField.activeBackgroundColor = .white
        textField.activeBorderColor = .white
        textField.inactiveBorderColor = .black
        textField.borderSize = 0.5
        textField.textColor = .black
        textField.tintColor = .clear
        textField.alpha = 0.85
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    lazy var authorizationButton: WCLShineButton = {
        var param = WCLShineParams()
        param.animDuration = 1.3
        param.shineCount = 10
        param.shineSize = 18
        param.bigShineColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        param.smallShineColor = .lightGray
        let button = WCLShineButton(frame: .init(x: 0, y: 0, width: 85, height: 85), params: param)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.image = .custom(UIImage(named: "seal.png")!)
        button.color = .lightGray
        button.fillColor = .lightGray
        button.setClicked(false)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var registrationButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Registration", for: .normal)
        button.titleLabel?.font = UIFont(name: "Chalkduster", size: 12)
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: CONSTRAINTS
    
    func createConstraintsBackgroundImageView() {
        backgroundImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -250).isActive = true
        backgroundImageView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  250).isActive = true
    }

    func createConstraintsApplicationTitleLabel() {
        applicationTitleLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        applicationTitleLabel.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nicknameField.topAnchor).isActive = true
    }
    
    func createConstraintsNicknameField() {
        nicknameField.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nicknameField.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -60).isActive = true
        nicknameField.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 145).isActive = true
        nicknameField.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsPasswordField() {
        passwordField.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        passwordField.safeAreaLayoutGuide.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 5).isActive = true
        passwordField.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 145).isActive = true
        passwordField.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsAuthorizationButton() {
        authorizationButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        authorizationButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 20).isActive = true
        authorizationButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 85).isActive = true
        authorizationButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 85).isActive = true
    }
    
    func createConstraintsRegistrationButton() {
        registrationButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        registrationButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12).isActive = true
        registrationButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 100).isActive = true
        registrationButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
