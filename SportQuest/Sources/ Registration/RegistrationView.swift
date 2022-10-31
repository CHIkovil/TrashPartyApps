//
//  RegistrationView.swift
//  SportQuest
//
//  Created by Никита Бычков on 20.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

class RegistrationView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backgroundImageView)
        self.addSubview(userImageView)
        self.addSubview(raceField)
        self.addSubview(nicknameField)
        self.addSubview(passwordField)
        self.addSubview(normDistanceField)
        self.addSubview(exitButton)
        self.addSubview(saveButton)
        
        raceField.inputView = racePickerView
        
        createConstraintsBackgroundImageView()
        createConstraintsUserImageView()
        createConstraintsRaceField()
        createConstraintsNicknameField()
        createConstraintsPasswordField()
        createConstraintsNormDistanceField()
        createConstraintsExitButton()
        createConstraintsSaveButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    lazy var racePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = #colorLiteral(red: 0.1217345223, green: 0.1212972179, blue: 0.1344326437, alpha: 1)
        pickerView.setValue(UIColor.white, forKey: "textColor")
        pickerView.frame = CGRect(x: 0, y: 0, width: 320, height: 150);
        return pickerView
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadGif(name: "character")
        return imageView
    }()
    
    lazy var userImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "blackhole.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.alpha = 0.7
        imageView.backgroundColor = .white
        return imageView
    }()
    
    lazy var raceField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Race"
        textField.placeholderColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        textField.placeholderFontScale = 0.8
        textField.borderActiveColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        textField.borderInactiveColor = .lightGray
        textField.textColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        textField.tintColor = .clear
        textField.alpha = 0.9
        return textField
    }()
    
    lazy var nicknameField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Nickname"
        textField.placeholderColor = .white
        textField.placeholderFontScale = 0.8
        textField.borderActiveColor = .white
        textField.borderInactiveColor = .lightGray
        textField.textColor = .white
        textField.tintColor = .white
        textField.alpha = 0.9
        return textField
    }()
    
    lazy var passwordField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Password"
        textField.placeholderColor = .white
        textField.placeholderFontScale = 0.8
        textField.borderActiveColor = .white
        textField.borderInactiveColor = .lightGray
        textField.textColor = .white
        textField.tintColor = .white
        textField.alpha = 0.9
        return textField
    }()
    
    lazy var normDistanceField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Chalkduster", size: 20)
        textField.placeholder = "Distance(m)"
        textField.placeholderColor = .white
        textField.placeholderFontScale = 0.8
        textField.borderActiveColor = .white
        textField.borderInactiveColor = .lightGray
        textField.textColor = .white
        textField.tintColor = .white
        textField.alpha = 0.9
        return textField
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"cancel.png"), for: .normal)
        button.alpha = 0.9
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.isEnabled = false
        button.setImage(UIImage(named:"disk.png"), for: .normal)
        button.alpha = 1
        return button
    }()
    
    // MARK: CONSTRAINTS
    
    func createConstraintsBackgroundImageView() {
        backgroundImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -250).isActive = true
        backgroundImageView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  250).isActive = true
    }
    
    func createConstraintsUserImageView() {
        userImageView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userImageView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 175).isActive = true
        userImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 137).isActive = true
        
    }
    
    func createConstraintsRaceField() {
        raceField.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        raceField.safeAreaLayoutGuide.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 15).isActive = true
        raceField.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 145).isActive = true
        raceField.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsNicknameField() {
        nicknameField.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nicknameField.safeAreaLayoutGuide.topAnchor.constraint(equalTo: raceField.bottomAnchor, constant: 5).isActive = true
        nicknameField.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 145).isActive = true
        nicknameField.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsPasswordField() {
        passwordField.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        passwordField.safeAreaLayoutGuide.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 5).isActive = true
        passwordField.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 145).isActive = true
        passwordField.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
    
    func createConstraintsNormDistanceField() {
        normDistanceField.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        normDistanceField.safeAreaLayoutGuide.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 5).isActive = true
        normDistanceField.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 145).isActive = true
        normDistanceField.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 65).isActive =  true
    }
 
    func createConstraintsExitButton() {
        exitButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 70).isActive = true
        exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
        exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func createConstraintsSaveButton() {
        saveButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: normDistanceField.bottomAnchor, constant: 30).isActive = true
        saveButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        saveButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 80).isActive = true
        saveButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}
