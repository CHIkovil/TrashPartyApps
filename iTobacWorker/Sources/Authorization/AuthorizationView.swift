//
//  AuthorizationView.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import SnapKit

//MARK: CONSTANTS

private enum AuthorizationViewConstants {
    static let boardViewSide: CGFloat = 300
    static let titleAppLabelHeight: CGFloat = 70
    static let loginTextFieldWidth: CGFloat = 200
    static let loginTextFieldHeight: CGFloat = 100
}

class AuthorizationView: UIView{
    
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
    }
    
    //MARK: UI
    
    lazy var boardView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1220629886, green: 0.1255925298, blue: 0.1454096735, alpha: 1)
        view.alpha = 0
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 4
        view.layer.borderColor = #colorLiteral(red: 0.08958115429, green: 0.08975156397, blue: 0.09752175957, alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var appLabel: UIAbbreviationLabel = {
        let label = UIAbbreviationLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UIWakeUpTextField = {
        let textField = UIWakeUpTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: CONSTRAINTS
    
    func constraintsBoardView() {
        boardView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(AuthorizationViewConstants.boardViewSide)
            make.height.equalTo(AuthorizationViewConstants.boardViewSide)
            make.center.equalTo(self.snp.center)
        }
    }
    
    func constraintsTitleAppLabel() {
        appLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(AuthorizationViewConstants.boardViewSide)
            make.height.equalTo(AuthorizationViewConstants.titleAppLabelHeight)
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func constraintsPasswordTextField() {
        passwordTextField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(AuthorizationViewConstants.loginTextFieldWidth)
            make.height.equalTo(AuthorizationViewConstants.loginTextFieldHeight)
            make.bottom.equalTo(self.snp.centerY).offset(15)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        boardView.addSubview(passwordTextField)
        self.addSubview(boardView)
        self.addSubview(appLabel)
        
        constraintsBoardView()
        constraintsTitleAppLabel()
        constraintsPasswordTextField()
    }
}

//MARK: ANIMATION EXTENSION
extension AuthorizationView {
    func showInputBoard(){
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let self = self else{return}
            self.appLabel.transform.ty = -113
        }, completion: { [weak self] _ in
            guard let self = self else{return}
            UIView.animate(withDuration: 0.5,animations: {[weak self] in
                guard let self = self else{return}
                self.boardView.alpha = 1
                self.passwordTextField.showInputField()
            },completion: {[weak self] _ in
                guard let self = self else{return}
                self.appLabel.showSmoke()
            })
        })
    }
}


