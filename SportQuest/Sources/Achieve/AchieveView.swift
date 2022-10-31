//
//  AchieveView.swift
//  SportQuest
//
//  Created by Никита Бычков on 17.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit

class AchieveView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 45
        self.backgroundColor = #colorLiteral(red: 0.2314966023, green: 0.2339388728, blue: 0.2992851734, alpha: 1)
        achieveCollectionView.backgroundView = backgroundImageView
        self.addSubview(achieveCollectionView)
        self.addSubview(exitButton)
        
        createConstraintsBackgroundImageView()
        createConstraintsAchieveCollectionView()
        createConstraintsExitButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadGif(name: "space")
        imageView.alpha = 1
        return imageView
    }()
    
    lazy var achieveCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.bounces = true
        collectionView.layer.cornerRadius = 45
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"cancel.png"), for: .normal)
        button.alpha = 0.9
        return button
    }()

    //MARK: CONSTRAINTS

    func createConstraintsBackgroundImageView() {
        backgroundImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: achieveCollectionView.topAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: achieveCollectionView.bottomAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: achieveCollectionView.leadingAnchor).isActive = true
        backgroundImageView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: achieveCollectionView.trailingAnchor).isActive = true
    }
 
    func createConstraintsAchieveCollectionView() {
        achieveCollectionView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        achieveCollectionView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -70).isActive = true
    }

    func createConstraintsExitButton() {
        exitButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
        exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
