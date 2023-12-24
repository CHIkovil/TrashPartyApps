//
//  UINormPicker.swift
//  iTobacWorker
//
//  Created by Nikolas on 10.01.2022.
//

import Foundation
import UIKit

//MARK: CONSTANTS

private enum UINormPickerConstants{
    static let defTextSize: CGFloat = 28
}

// MARK: DELEGATE

protocol UINormPickerDelegate: AnyObject {
    func didNormValueChanged(_ toValue: Int, _ type: Any)
}

final class UINormPicker: UIView{
    weak var delegate: UINormPickerDelegate?
    var normType: Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeLayer()
    }    
    
    // MARK: addTextFieldTarget
    func addTextFieldTarget(target: Any?, action: Selector, event: UIControl.Event){
        inputTextField.addTarget(target, action: action, for: event)
    }
    
    // MARK: setNormValue
    func setNormValue(_ newValue: Int){
        inputTextField.text = "\(newValue)"
    }
    
    //MARK: PRIVATE
    
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    
    //MARK: UI
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: AppString.fontName.rawValue, size: UINormPickerConstants.defTextSize - 5)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = #colorLiteral(red: 0.2277443409, green: 0.227789104, blue: 0.2277384698, alpha: 1)
        textField.delegate = self
        textField.textColor = #colorLiteral(red: 0, green: 0.7445449233, blue: 0.0140819503, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.tintColor = .clear
        textField.textAlignment = .center
        textField.text = "0"
        return textField
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsInputTextField() {
        inputTextField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.height.equalTo(self.snp.height).multipliedBy(0.55)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    // MARK: OBJC
    
    @objc func didNormChanged() {
        guard let normType = normType, let normValue = Int(inputTextField.text!) else {
            return
        }
        delegate?.didNormValueChanged(normValue, normType)
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        self.addSubview(inputTextField)
        constraintsInputTextField()
        
        inputTextField.addTarget(self, action:  #selector(didNormChanged), for: .editingChanged)
    }
    
    private func makeLayer() {
        let color = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        self.layer.drawBlockLayer(cornerWidth: 15,color: color, borderWidth: nil)
    }
}

//MARK: DELEGATE EXTENSION

extension UINormPicker: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let newLength = text.count + string.count - range.length
        return allowedCharacters.isSuperset(of: characterSet) && newLength <= 4
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "0"){
            textField.text = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if (textField.text == ""){
                textField.text = "0"
                textField.resignFirstResponder()
            }
        }
    }
}
