//
//  BrandsView.swift
//  iTobacWorker
//
//  Created by Nikolas on 29.01.2022.
//

import Foundation
import UIKit

//MARK: CONSTANTS

private enum BrandViewConstants {
    static let collectionViewWidth = 350
    static let collectionViewHeight = 507
}

// MARK: CONTANTS

enum BrandsViewConstants {

    static let cellSpacing: CGFloat = 8
}

class BrandsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    //MARK: UI
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = BrandsViewConstants.cellSpacing
        layout.minimumInteritemSpacing = BrandsViewConstants.cellSpacing
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1075955555, green: 0.1069958732, blue: 0.1293319464, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //MARK: CONSTRAINTS
    
    func constraintsCollectionView() {
        collectionView.snp.makeConstraints {(make) -> Void in
            make.center.equalTo(self.snp.center)
            make.height.equalTo(BrandViewConstants.collectionViewHeight)
            make.width.equalTo(BrandViewConstants.collectionViewWidth)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        
        self.addSubview(collectionView)
        constraintsCollectionView()
    }
}
