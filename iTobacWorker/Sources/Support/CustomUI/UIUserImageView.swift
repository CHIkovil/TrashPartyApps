//
//  UIUserImageView.swift
//  iTobacWorker
//
//  Created by Nikolas on 09.12.2021.
//

import Foundation
import UIKit

//MARK: STRING

enum UIUserImageViewString: String {
    case defImageName = "question"
    case buttonImageName = "add"
    case frameLayerName = "arcLayer"
    case arcAnimationKey = "transform.rotation"
}

class UIUserImageView: UIView {

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
        makeLayer()
    }
    
    // MARK: addButtonGestureRecognizer
    func addButtonGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer){
        button.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: setImage
    func setImage(image: UIImage){
        imageView.image = image
    }
    
    // MARK: getImageData
    func getImageData() -> Data?{
        return imageView.image?.pngData()
    }
    
    // MARK: animateImagePulse
    func animateImagePulse(){
        imageView.layer.addPulseAnimation()
    }
    
    // MARK: PRIVATE
    
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    
    
    // MARK: UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: UIUserImageViewString.defImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.9983720183, green: 0.890299499, blue: 0.4330784082, alpha: 1)
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        imageView.alpha = 0.9
        return imageView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: UIUserImageViewString.buttonImageName.rawValue), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.alpha = 0.9
        return button
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        return view
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsBackgroundView() {
        backgroundView.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.6)
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.center.equalTo(self.snp.center)
        }
    }
    
    private func constraintsImageView() {
        imageView.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.6)
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.center.equalTo(self.snp.center)
        }
    }
    
    private func constraintsButton() {
        button.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(self.snp.height).multipliedBy(0.18)
            make.width.equalTo(self.snp.width).multipliedBy(0.18)
            make.top.equalTo(imageView.snp.bottom).offset(-10)
            make.leading.equalTo(imageView.snp.trailing).offset(-10)
        }
    }
    
    // MARK: SUPPORT FUNC
    
    private func makeUI(){
        backgroundView.addSubview(imageView)
        self.addSubview(backgroundView)
        self.addSubview(button)
      
        constraintsBackgroundView()
        constraintsImageView()
        constraintsButton()
    }
    
    private func makeLayer(){
        let color = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        self.layer.drawBlockLayer(cornerWidth: 35, color:color, borderWidth: nil)
        self.showImageFrame()
        
        imageView.layer.cornerRadius = (viewWidth + viewHeight) * 0.15
        backgroundView.layer.cornerRadius = (viewWidth + viewHeight) * 0.15
    }
    
    private func showImageFrame(){
        if self.layer.sublayers?.contains(where: {$0.name == UIUserImageViewString.frameLayerName.rawValue}) == true{
            return
        }
        
        for index in 1...3 {
            let arcLayer = drawArcLayer(offset: CGFloat(index))
            arcLayer.addInfinityRotationAnimation()
            self.layer.addSublayer(arcLayer)
        }
    }
    
    //MARK: DRAW
    
    private func drawArcLayer(offset: CGFloat) -> CAShapeLayer{
        let shapeLayer = CAShapeLayer()
        let center = CGPoint(x: viewWidth / 2, y: viewHeight / 2)
        let bounds = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        let startAngle = CGFloat.pi / 180 * CGFloat.random(in: 0...360)
        
        shapeLayer.path = UIBezierPath(arcCenter: center,
                                          radius: (viewWidth + viewHeight)  * 0.15 + offset * 5,
                                          startAngle: startAngle,
                                          endAngle: startAngle * CGFloat.random(in: 0...100) / 100,
                                          clockwise: true).cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.7908198833, green: 0.8205971718, blue: 0.8312640786, alpha: 1).cgColor
        shapeLayer.lineWidth = offset
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.name = UIUserImageViewString.frameLayerName.rawValue
        
        shapeLayer.position = center
        shapeLayer.bounds = bounds
        return shapeLayer
    }
}


//MARK: ANIMATION EXTENSION

private extension CALayer {
    func addInfinityRotationAnimation(){
        let animation = CABasicAnimation(keyPath: UIUserImageViewString.arcAnimationKey.rawValue)
        animation.byValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        animation.duration = 10
        animation.repeatCount = .infinity
        self.add(animation, forKey: UIUserImageViewString.arcAnimationKey.rawValue)
    }
}

