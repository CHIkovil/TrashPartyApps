//
//  AchieveViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 01.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin

class AchieveViewController: UIViewController {
    
    private var customTransitioningDelegate = TransitionDelegate()
    
    var achieveView:AchieveView!
    private let achievePresenter = AchievePresenter(achieveService: AchieveService())
    
    //MARK: init
     override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
         configure()
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame.size = CGSize(width: 300, height: 300)
        achieveView = AchieveView(frame: view.frame)
        view.addSubview(achieveView!)
        
        achieveView.exitButton.addTarget(self, action: #selector(exitAchieve), for: .touchUpInside)
        
        achieveView.achieveCollectionView.delegate = self
        achieveView.achieveCollectionView.dataSource = self
    }
    
    //MARK: OBJC
    
    @objc func exitAchieve(){
        self.dismiss(animated: true)
    }
    
    //MARK: SUPPORT FUNC
    
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}

//MARK: DELEGATE

extension AchieveViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = achievePresenter.getCollectionData()
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.clipsToBounds = true
        
        let data = achievePresenter.getCollectionData()
        
        let gif = UIImageView(frame: CGRect(x: 20, y: 10, width: 120, height: 120))
        gif.layer.cornerRadius = gif.frame.size.width / 2
        gif.layer.masksToBounds = true
        gif.loadGif(name: data[indexPath.row].gif)
        gif.alpha = 0.9
        cell.contentView.addSubview(gif)
        
        if let _ = UserDefaults.standard.string(forKey: data[indexPath.row].gif) {
            let mask = UIImageView(frame: CGRect(x: 20, y: 10, width: 120, height: 120))
            mask.image = UIImage(named: "completed.png")
            mask.layer.cornerRadius = mask.frame.size.width / 2
            mask.clipsToBounds = true
            mask.layer.masksToBounds = true
            mask.layer.borderColor = UIColor.clear.cgColor
            mask.alpha = 0.6
            cell.contentView.addSubview(mask)
        }
        
        let text = UILabel(frame: CGRect(x: 20, y: 120, width: 100, height: 50))
        text.textColor = .yellow
        text.font = UIFont(name: "Chalkduster", size: 14)
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.layer.borderColor = UIColor.clear.cgColor
        text.text = data[indexPath.row].text
        cell.contentView.addSubview(text)
        
        return cell
    }
    
}

extension AchieveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
