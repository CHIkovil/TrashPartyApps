//
//  MainViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 16.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import  UIKit

class MainViewController: UIViewController {
    
    private var current: UIViewController
    
    init() {
        self.current = AuthorisationViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func switchToAuthorizationScreen() {
        let authorizationViewController = AuthorisationViewController()
        animateDismissTransition(to: authorizationViewController)
    }
    
    func switchToTabsScreen() {
        let tabsViewController = TabsViewController()
        animateFadeTransition(to: tabsViewController)
    }
    
    func switchToRegistrationScreen() {
        let registrationViewController = RegistrationViewController()
        animateFadeTransition(to: registrationViewController)
    }
}

extension MainViewController{
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        
        transition(from: current, to: new, duration:0.5, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.5, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
}
