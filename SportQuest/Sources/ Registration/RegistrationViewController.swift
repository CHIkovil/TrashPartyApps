//
//  RegistrationViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 04.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import TextFieldEffects

class RegistrationViewController: UIViewController {
    
    var registrationView:RegistrationView!
    var registrationPresenter:RegistrationPresenter = RegistrationPresenter(registrationService: RegistrationService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationView = RegistrationView(frame: view.frame)
        view.addSubview(registrationView)
        
        registrationView.exitButton.addTarget(self, action: #selector(didPressedExitButton), for: .touchUpInside)
        registrationView.saveButton.addTarget(self, action: #selector(didPressedSaveButton), for: .touchUpInside)
        registrationView.raceField.addTarget(self, action: #selector(didPressedRaceField), for: .touchDown)
    
        registrationView.racePickerView.delegate = self
        registrationView.racePickerView.dataSource = self
        registrationView.raceField.delegate = self
        registrationView.nicknameField.delegate = self
        registrationView.passwordField.delegate = self
        registrationView.normDistanceField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: OBJC
    
    @objc func didPressedExitButton() {
        SceneDelegate.shared?.rootViewController.switchToAuthorizationScreen()
    }
    
    @objc func didPressedSaveButton() {
        registrationPresenter.saveUserData(data: User(race: registrationView.raceField.text!, nickname: registrationView.nicknameField.text!, normDistance: Int(registrationView.normDistanceField.text!)!, password: registrationView.passwordField.text!))
        SceneDelegate.shared?.rootViewController.switchToAuthorizationScreen()
    }
    
    @objc func didPressedRaceField(){
        if (registrationView.raceField.text!.isEmpty){
            registrationView.userImageView.image = UIImage(named: "\(Race.allCases[0].rawValue.lowercased()).png")
            registrationView.raceField.text = Race.allCases[0].rawValue
        }
    }
}

//MARK: DELEGATE

extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Race.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Race.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        registrationView.raceField.text = Race.allCases[row].rawValue
        registrationView.userImageView.image = UIImage(named: "\(Race.allCases[row].rawValue.lowercased()).png")
        registrationView.raceField.resignFirstResponder()
    }
}

extension RegistrationViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if [registrationView.raceField.text!, registrationView.nicknameField.text!, registrationView.normDistanceField.text!, registrationView.passwordField.text!].allSatisfy({
            !$0.isEmpty}){
            registrationView.saveButton.isEnabled = true
        }
        switch textField.placeholder {
        case "Distance(m)":
            let invalidCharacters =
            CharacterSet(charactersIn: "0123456789").inverted
            return (string.rangeOfCharacter(from: invalidCharacters) == nil)
        case "Race":
            return false
        default:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
    }
}

