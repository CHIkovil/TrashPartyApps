//
//  UIBankPicker.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.12.2021.
//

import Foundation
import UIKit

//MARK: STRING

private enum UICountPickerString:String{
    case animationKey =  "position"
    case buttonImageName = "plus"
}

//MARK: CONSTANTS

private enum UICountPickerConstants{
    static let defTextSize: CGFloat = 28
}

// MARK: DELEGATE

protocol UICountPickerDelegate: AnyObject {
    func didCountValueChanged(_ toValue: Int, _ type: Any)
}

final class UICountPicker: UIView{
    weak var delegate: UICountPickerDelegate?
    var image: UIImage?
    var countType: Any?
    
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
        
        guard let image = image else {return}
        imageView.image = image
    }
    
    //MARK: animateAttention
    func animateAttention(){
        imageView.animateShake()
    }
    
    //MARK: setStorageValue
    func setStorageValue(_ currentValue: Int){
        storageLabel.text = "\(currentValue)"
    }
    
    //MARK: getStorageValue
    func getStorageValue() -> Int?{
        guard let text = storageLabel.text else{return nil}
        return Int(text)
    }
    
    //MARK: PRIVATE
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    
    //MARK: UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .clear
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressImage)))
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressImage)))
        return imageView
    }()
    
    private lazy var storageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppString.fontName.rawValue, size: UICountPickerConstants.defTextSize)
        label.text = "\(0)"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: AppString.fontName.rawValue, size: UICountPickerConstants.defTextSize - 5)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        textField.setLeftPaddingPoints(12)
        textField.backgroundColor = #colorLiteral(red: 0.2277443409, green: 0.227789104, blue: 0.2277384698, alpha: 1)
        textField.alpha = 0
        textField.delegate = self
        textField.textColor = #colorLiteral(red: 0.7371812463, green: 0.737306416, blue: 0.7328566909, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var inputButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: UICountPickerString.buttonImageName.rawValue), for: .normal)
        button.layer.cornerRadius = button.frame.width / 2
        button.alpha = 0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressInputButton)))
        return button
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsImageView() {
        imageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width).multipliedBy(0.55)
            make.height.equalTo(self.snp.height).multipliedBy(0.55)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-12)
        }
    }
    
    private func constraintsStorageLabel() {
        storageLabel.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.21)
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalTo(imageView.snp.centerX)
        }
    }
    
    private func constraintsInputTextField() {
        inputTextField.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.19)
            make.width.equalTo(self.snp.width).multipliedBy(0.55)
            make.centerX.equalTo(storageLabel.snp.centerX).offset(-5)
            make.centerY.equalTo(storageLabel.snp.centerY)
        }
    }
    
    private func constraintsInputButton() {
        inputButton.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.17)
            make.width.equalTo(self.snp.width).multipliedBy(0.17)
            make.centerY.equalTo(inputTextField.snp.centerY)
            make.leading.equalTo(inputTextField.snp.trailing).offset(5)
        }
    }
    
    // MARK: OBJC
    
    @objc func didPressImage() {
        addCountValue(value: 1)
    }
    
    @objc func didLongPressImage() {
        imageView.layer.addPulseAnimation()
        switchInputState(true)
    }
    
    @objc func didPressInputButton() {
        guard let text = inputTextField.text else {return}
        switchInputState(false)
        guard let value = Int(text) else {return}
        addCountValue(value: value)
    }
    
    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        self.addSubview(imageView)
        self.addSubview(storageLabel)
        self.addSubview(inputTextField)
        self.addSubview(inputButton)
        constraintsImageView()
        constraintsStorageLabel()
        constraintsInputTextField()
        constraintsInputButton()
    }
    
    private func makeLayer(){
        let color = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        self.layer.drawBlockLayer(cornerWidth: 25, color: color, borderWidth: nil)
    }
    
    private func addCountValue(value newValue: Int){
        if let number = NumberFormatter().number(from: storageLabel.text!) {
            let oldValue = Int(truncating: number)
            storageLabel.text = "\(oldValue + newValue)"
        }
        
        imageView.animateShake()
        storageLabel.animateDrop()
        
        guard let countType = countType else {
            return
        }
        delegate?.didCountValueChanged(newValue, countType)
    }
    
    private func switchInputState(_ isEnabled: Bool){
        self.storageLabel.alpha = isEnabled ? 0 : 1
        self.inputTextField.isUserInteractionEnabled = isEnabled
        self.inputButton.isUserInteractionEnabled = isEnabled
        self.imageView.isUserInteractionEnabled = !isEnabled
        animateInputState(alpha: isEnabled ? 1 : 0)
        inputTextField.text = ""
    }
}

//MARK: ANIMATION EXTENSION

private extension UICountPicker {
    func animateInputState(alpha: CGFloat){
        UIView.animate(withDuration: 0.1, animations: {[weak self] in
            guard let self = self else{return}
            self.inputTextField.alpha = alpha
        }, completion: { _ in
            self.inputButton.alpha = alpha - 0.1
        })
    }
}

private extension UIView{
    func animateShake(){
        let animation = CABasicAnimation(keyPath: UICountPickerString.animationKey.rawValue)
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 1.5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 1.5, y: self.center.y))
        
        self.layer.add(animation, forKey: UICountPickerString.animationKey.rawValue)
    }
    
    func animateDrop(){
        let animation = CABasicAnimation(keyPath: UICountPickerString.animationKey.rawValue)
        animation.duration = 0.7
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y - 4))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y))
        
        self.layer.add(animation, forKey: UICountPickerString.animationKey.rawValue)
    }
    
}

//MARK: DELEGATE EXTENSION

extension UICountPicker: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let newLength = text.count + string.count - range.length
        return allowedCharacters.isSuperset(of: characterSet) && newLength <= 4
    }
}
