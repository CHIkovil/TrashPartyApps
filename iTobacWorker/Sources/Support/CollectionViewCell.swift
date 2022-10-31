//
//  CollectionViewCell.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.02.2022.
//

import Foundation
import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        makeLayer()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeLayer()
    }
    
    //MARK: UI
    
    lazy var brandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.1220629886, green: 0.1255925298, blue: 0.1454096735, alpha: 1)
        return imageView
    }()
    
    lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: AppString.fontName.rawValue, size: 25)
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    //MARK: CONSTRAINTS

    func constraintsBrandImageView() {
        brandImageView.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }

    func constraintsBrandLabel() {
        brandLabel.snp.makeConstraints {(make) -> Void in
            make.center.equalTo(contentView.snp.center)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(contentView.snp.height)
        }
    }
    

    //MARK: SUPPORT FUNC
    
    func configure(with cellData: Brand) {
        brandLabel.text = cellData.title
    }
    
    func makeUI() {
        contentView.addSubview(brandImageView)
        contentView.addSubview(brandLabel)
        
        constraintsBrandImageView()
        constraintsBrandLabel()
    }
    
    func makeLayer(){
        contentView.layer.cornerRadius = 12.0
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
    }
}


