//
//  AuthorizationViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import UIKit
import Dispatch

class AuthorizationViewController: UIViewController
{
    var authorizationView: AuthorizationView!
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup()
    {
        authorizationView = AuthorizationView()
        
        
    }
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view = authorizationView
        
        authorizationView.appLabel.delegate = self
        authorizationView.passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authorizationView.appLabel.showAbbreviation()
    }
}

//MARK: DELEGATE EXTENSION

extension AuthorizationViewController: UIAbbreviationDelegate{
    func didEndedPresentAnimation() {
        authorizationView.appLabel.showSmoke()
        authorizationView.showInputBoard()
    }
}

extension AuthorizationViewController: UIWakeUpTextFieldDelegate {
    func didEndedEnterAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let nextViewController = WorkTabBarController()
            nextViewController.modalTransitionStyle = .coverVertical
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated: true)
        }
    }
}

