//
//  UIWakeUpTextField.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import SnapKit

//MARK: STRING

private enum UIWakeUpTextFieldString: String {
    case titleLabelText = "Password"
    case lineLayerName = "line"
}

//MARK: CONSTANTS

private enum UIWakeUpTextFieldConstants{
    static let defTextSize: CGFloat = 13.5
    static let lineWidth: CGFloat = 2
}

// MARK: DELEGATE

protocol UIWakeUpTextFieldDelegate: AnyObject {
    func didEndedEnterAnimation()
}


final class UIWakeUpTextField: UIView {
    
    weak var delegate: UIWakeUpTextFieldDelegate?
    
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
    
    // MARK: showInputField
    func showInputField(){
        let lineLayer = drawLineLayer(color: #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1))
        lineLayer.addActivationAnimation()
        self.layer.addSublayer(lineLayer)
        animateInputField()
    }
    
    //MARK: PRIVATE
    private var lineStartPoint:CGPoint {CGPoint(x: 15, y: self.frame.height + 5)}
    private var lineEndPoint:CGPoint {CGPoint(x: self.frame.width - 15, y: self.frame.height + 5)}
    private var textFieldWidth: CGFloat {self.frame.width}
    private var textFieldHeight: CGFloat {self.frame.height}
    
    //MARK:  UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppString.fontName.rawValue, size: UIWakeUpTextFieldConstants.defTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = UIWakeUpTextFieldString.titleLabelText.rawValue
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: AppString.fontName.rawValue, size: UIWakeUpTextFieldConstants.defTextSize + 10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = #colorLiteral(red: 0.9386559129, green: 0.9388130307, blue: 0.9386352301, alpha: 1)
        textField.textColor = .black
        textField.tintColor = .clear
        textField.isUserInteractionEnabled = false
        textField.alpha = 0
        textField.setLeftPaddingPoints(12)
        textField.layer.cornerRadius = 15
        textField.isSecureTextEntry = true
        textField.textAlignment = .center
        return textField
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsTitleLabel(){
        titleLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height).multipliedBy(0.4)
            make.centerX.equalTo(textField.snp.centerX)
            make.bottom.equalTo(textField.snp.bottom)
        }
    }
    
    private func constraintsTextField(){
        textField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height).multipliedBy(0.5)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        self.addSubview(titleLabel)
        self.addSubview(textField)
        
        constraintsTitleLabel()
        constraintsTextField()
    }
    
    private func makeLayer(){
        self.showLine()
    }
    
    private func showLine(){
        if self.layer.sublayers?.contains(where: {$0.name == UIWakeUpTextFieldString.lineLayerName.rawValue}) == true{
            return
        }
        let lineLayer = drawLineLayer(color: .lightGray)
        self.layer.addSublayer(lineLayer)
    }
    
    //MARK: DRAW
    
    private func drawLineLayer(color: UIColor) -> CAShapeLayer{
        
        let path = UIBezierPath()
        path.move(to: lineStartPoint)
        path.addLine(to: lineEndPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = UIWakeUpTextFieldConstants.lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.name = UIWakeUpTextFieldString.lineLayerName.rawValue
        
        return shapeLayer
    }
}

//MARK: EXTENSION
private extension String {
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

//MARK: ANIMATION EXTENSION

private extension UIWakeUpTextField {
    func animateInputField(){
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            guard let self = self else{return}
            self.titleLabel.transform.ty = -abs(self.textField.frame.height)
        },completion: {_ in
            UIView.animate(withDuration: 0.5, animations: {[weak self] in
                guard let self = self else{return}
                self.textField.alpha = 1
            }, completion: { _ in
                self.displayPassword(allDelay: 10, value: String.random(length: 7))
            })
        })
    }
    
    func displayPassword(allDelay: Int, value: String) {
        var strValue = value
        let delay = TimeInterval(allDelay / strValue.count)
        
        let timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) {[weak self] timer in
            guard let self = self else{return}
            self.textField.text? += String(strValue.removeFirst())
            if strValue == ""{
                self.delegate?.didEndedEnterAnimation()
                timer.invalidate()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
}
