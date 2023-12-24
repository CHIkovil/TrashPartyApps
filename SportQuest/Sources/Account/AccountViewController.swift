//
//  AccountViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView
import Charts

protocol AccountViewDelegate:NSObjectProtocol {
    func displayChartData(data: RadarChartData)
    func displayProgressData(data: UserProgress)
}

class AccountViewController: UIViewController, TabItem {
    
    var accountView:AccountView!
    private let accountPresenter = AccountPresenter(accountService: AccountService())
    
    var tabImage: UIImage? {
      return UIImage(named: "account.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountPresenter.setViewDelegate(accountViewDelegate: self)
        accountView = AccountView(frame: view.frame)
        view.addSubview(accountView!)
        
        accountView.achieveButton.addTarget(self, action: #selector(showAchieve), for: .touchUpInside)
        accountView.logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        accountView.changeNormDistanceButton.addTarget(self, action: #selector(changeNormDistance), for: .touchUpInside)
        
        accountView.setupDistanceTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        accountPresenter.setUserData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: OBJC
    
    @objc func showAchieve(){
        let viewController = AchieveViewController()
        self.present(viewController, animated: true)
    }
    
    @objc func logOut(){
        SceneDelegate.shared?.rootViewController.switchToAuthorizationScreen()
    }
    
    @objc func changeNormDistance(){
        do{
            accountPresenter.updateNormDistance(data: Int(accountView.setupDistanceTextField.text!)!)
            accountView.changeNormDistanceButton.isEnabled = false
            accountView.setupDistanceTextField.resignFirstResponder()
        }
    }
}

//MARK: DELEGATE

extension AccountViewController: AccountViewDelegate{
    
    func displayProgressData(data: UserProgress) {
        accountView.userImageView.image = UIImage(named: data.user.race.lowercased())
        
        accountView.levelLabel.text = "Lvl \((data.achievesStore / 100) + 1)"
        accountView.achievePointsLabel.text = "+ \(data.achievesStore)"
        accountView.lineCompleteAchieveLabel.safeAreaLayoutGuide.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(data.achievesStore)).isActive = true
        accountView.lineCompleteAchieveLabel.layoutIfNeeded()
        
        accountView.setupDistanceTextField.isEnabled = true
        accountView.setupDistanceTextField.text = String(data.user.normDistance)
    }
    
    func displayChartData(data: RadarChartData) {
        accountView.skillsChartView.xAxis.valueFormatter = self
        accountView.skillsChartView.data = data
        accountView.skillsChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
}

extension AccountViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters =
            CharacterSet(charactersIn: "0123456789").inverted
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        return (string.rangeOfCharacter(from: invalidCharacters) == nil) && newLength <= 7
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
       if accountPresenter.getNormDistance() != textField.text!{
           accountView.changeNormDistanceButton.isEnabled = true
       }else{
           accountView.changeNormDistanceButton.isEnabled = false
       }
    }
}

//MARK: FORMATTER

extension AccountViewController:IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return SkillsName.allCases[Int(value) % SkillsName.allCases.count].rawValue
    }
}
