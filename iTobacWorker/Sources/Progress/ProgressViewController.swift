//
//  ProgressViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 07.12.2021.
//

import UIKit

// MARK: DELEGATE

protocol ProgressViewDelegate: AnyObject{
    func showUserData(_ data: UserData)
    func showUpdatedGraph(_ data: GraphData)
}

class ProgressViewController: UIViewController
{
    var imagePicker: ImagePicker!
    var progressView: ProgressView!
    var progressDelegate: (ProgressStoreDelegate & ProgressRecalculateDelegate)!
    
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
        self.progressView = ProgressView()
        self.progressDelegate = ProgressPresenter(delegate: self)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.progressView.moneyBankPicker.delegate = self
        self.progressView.cigaretteBankPicker.delegate = self
        self.progressView.moneyNormPicker.delegate = self
        self.progressView.cigaretteNormPicker.delegate = self
        
        progressView.userImageView.addButtonGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressAddPhotoButton)))
        progressView.moneyGraphButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressMoneyGraphButton)))
        progressView.cigaretteGraphButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressCigaretteGraphButton)))
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view = progressView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.moneyBankPicker.animateAttention()
        progressView.cigaretteBankPicker.animateAttention()
        progressDelegate.loadUserData()
        progressView.showBlocks()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.saveUserData()
    }
    
    // MARK: OBJC
    
    @objc func didPressAddPhotoButton() {
        progressView.userImageView.animateImagePulse()
        self.imagePicker.present()
    }
    
    @objc func didPressMoneyGraphButton() {
        progressView.switchGraphs(nil, .money)
    }
    
    @objc func didPressCigaretteGraphButton() {
        progressView.switchGraphs(nil, .cigarette)
    }
    
    //MARK: SUPPORT FUNC
    
    private func switchRecalculateGraphData(_ newValue: Int, progressType: Any, graphType: GraphType) {
        
        switch progressType {
        case ProgressType.money:
            guard let currentGraphSetups = progressView.moneyGraphView.getCurrentGraphSetups() else {return}
            guard let graphSetup = currentGraphSetups[graphType.rawValue] else {return}
            progressDelegate.recalculateGraphData(newValue: newValue, GraphData(setup: graphSetup, progressType: .money, graphType: graphType))
        case ProgressType.cigarette:
            guard let currentGraphSetups = progressView.cigaretteGraphView.getCurrentGraphSetups() else {return}
            guard let countGraphSetup = currentGraphSetups[graphType.rawValue]  else {return}
            progressDelegate.recalculateGraphData(newValue: newValue, GraphData(setup: countGraphSetup, progressType: .cigarette, graphType: graphType))
        default:
            return
        }
    }
    
    private func saveUserData(){
        guard let imageData = progressView.userImageView.getImageData(),
              let moneyBank = progressView.moneyBankPicker.getStorageValue(),
              let cigaretteBank = progressView.cigaretteBankPicker.getStorageValue(),
              let moneyGraphSetups = progressView.moneyGraphView.getCurrentGraphSetups(),
              let cigaretteGraphSetup = progressView.cigaretteGraphView.getCurrentGraphSetups() else{return}
              
        guard let moneyCountPoints = moneyGraphSetups[GraphType.count.rawValue]?.points ,
              let moneyNormPoints = moneyGraphSetups[GraphType.norm.rawValue]?.points,
              let cigarettCountPoints = cigaretteGraphSetup[GraphType.count.rawValue]?.points,
              let cigarettNormPoints = cigaretteGraphSetup[GraphType.norm.rawValue]?.points else{return}
                
        let moneyProgress = NSProgressData(bank: moneyBank, count: moneyCountPoints, norm: moneyNormPoints)
        let cigaretteProgress = NSProgressData(bank: cigaretteBank, count: cigarettCountPoints, norm: cigarettNormPoints)
        
        progressDelegate.saveUserData(UserData(image: imageData, moneyProgress: moneyProgress, cigaretteProgress: cigaretteProgress, dates: nil))
    }
}

//MARK: DELEGATE EXTENSION

extension ProgressViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        progressView.userImageView.setImage(image: image)
    }
}

extension ProgressViewController: ProgressViewDelegate {
    func showUpdatedGraph(_ data: GraphData) {
        switch data.progressType {
        case .money:
            progressView.moneyGraphView.updateGraph(data.setup)
        case .cigarette:
            progressView.cigaretteGraphView.updateGraph(data.setup)
        }
    }
    
    func showUserData(_ data: UserData) {
        if let imageData = data.image as Data? {
            if let image = UIImage(data: imageData){
                progressView.userImageView.setImage(image: image)
            }
        }
        
        progressView.moneyBankPicker.setStorageValue(data.moneyProgress.bank)
        progressView.cigaretteBankPicker.setStorageValue(data.cigaretteProgress.bank)
        progressView.moneyNormPicker.setNormValue(data.moneyProgress.norm.lastPositive ?? 0)
        progressView.cigaretteNormPicker.setNormValue(data.cigaretteProgress.norm.lastPositive ?? 0)
        

        progressView.switchGraphs([GraphSetup(points: data.moneyProgress.count, color: UIColor(white: 0.8, alpha: 0.9), annotation: GraphType.count.rawValue), GraphSetup(points: data.moneyProgress.norm, color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: GraphType.norm.rawValue)], .money)
        
        progressView.cigaretteGraphView.setGraphs([GraphSetup(points: data.cigaretteProgress.count, color: UIColor(white: 0.8, alpha: 0.9), annotation: GraphType.count.rawValue), GraphSetup(points: data.cigaretteProgress.norm, color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: GraphType.norm.rawValue)])
        
    }
}

extension ProgressViewController: UICountPickerDelegate {
    func didCountValueChanged(_ newValue: Int, _ type: Any) {
        switchRecalculateGraphData(newValue, progressType: type, graphType: .count)
    }
}

extension ProgressViewController: UINormPickerDelegate {
    func didNormValueChanged(_ newValue: Int, _ type: Any) {
        switchRecalculateGraphData(newValue, progressType: type, graphType: .norm)
    }
}

private extension Array where Element == Int  {
    var lastPositive: Element? {
        for number in reversed() {
             if number > 0 {
                 return number
             }
         }
         return nil
     }
}
