//
//  AuthorizationViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 30.09.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import TextFieldEffects
import DWAnimatedLabel
import WCLShineButton

protocol AuthorisationViewDelegate:NSObjectProtocol {
    func showUserData(_ data: Login?)
}

class AuthorisationViewController: UIViewController {
    
    var authorisationView:AuthorisationView!
    var authorisationPresenter:AuthorisationPresenter = AuthorisationPresenter(authorisationService: AuthorisationService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorisationPresenter.setViewDelegate(authorisationViewDelegate: self)
        authorisationView = AuthorisationView(frame: view.frame)
        view.addSubview(authorisationView)
        
        authorisationView.authorizationButton.addTarget(self, action: #selector(didPressedAuthorizationButton), for: .allTouchEvents)
        authorisationView.registrationButton.addTarget(self, action: #selector(didPressedRegistrationButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        authorisationPresenter.getUserData()
        authorisationView.applicationTitleLabel.startAnimation(duration: 5, .none)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: OBJC
    
    @objc func didPressedAuthorizationButton() {
        authorisationView.authorizationButton.setClicked(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            SceneDelegate.shared!.rootViewController.switchToTabsScreen()
        }
    }
    
    @objc func didPressedRegistrationButton() {
        SceneDelegate.shared!.rootViewController.switchToRegistrationScreen()
    }
}

//MARK: DELEGATE

extension AuthorisationViewController: AuthorisationViewDelegate{
    func showUserData(_ data: Login?) {
        if let data = data {
            let delay = 10
            
            self.authorisationView.nicknameField.addCharacter(allDelay: delay, value: data.nickname)
            self.authorisationView.passwordField.addCharacter(allDelay: delay, value: data.password)
            
            authorisationView.nicknameField.animateShift(toPoint: authorisationView.nicknameField.center, offset: -20, delay: delay)
            authorisationView.passwordField.animateShift(toPoint: authorisationView.passwordField.center, offset: 20, delay: delay)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat(delay)) {
                self.authorisationView.authorizationButton.isUserInteractionEnabled = true
                self.authorisationView.authorizationButton.animateAttention()
            }
        }else{
            self.authorisationView.registrationButton.isUserInteractionEnabled = true
            self.authorisationView.registrationButton.animateAttention()
        }
    }
}

//MARK: UI EXTENSION

private extension YoshikoTextField{
    func addCharacter(allDelay: Int, value: String) {
        var strValue = value
        let delay = TimeInterval(allDelay / strValue.count)
        
        let timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) {[weak self] timer in
            guard let self = self else{return}
            self.text? += String(strValue.removeFirst())
            if strValue == ""{
                self.activeBorderColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.9)
                timer.invalidate()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
    }
}

//MARK: ANIMATION

private extension UIControl {
    func animateAttention(){
        let animationOne = CABasicAnimation(keyPath: "transform.scale.x")
        animationOne.duration = 0.4
        animationOne.repeatCount = 2
        animationOne.autoreverses = true
        animationOne.fromValue = 1
        animationOne.toValue = 1.15
        
        let animationTwo = CABasicAnimation(keyPath: "transform.scale.y")
        animationTwo.duration = 0.4
        animationTwo.repeatCount = 2
        animationTwo.autoreverses = true
        animationTwo.fromValue = 1
        animationTwo.toValue = 1.15
        
        self.layer.add(animationOne, forKey: "transform.scale.x")
        self.layer.add(animationTwo, forKey: "transform.scale.y")
    }
    
    func animateShift(toPoint: CGPoint, offset: CGFloat, delay: Int) {
        var fromPoint = toPoint
        fromPoint.x += offset
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = NSValue(cgPoint:toPoint)
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.duration = CFTimeInterval(delay)
        
        layer.add(animation, forKey: "position")
    }
}
