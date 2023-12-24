//
//  UIAbbreviationLabel.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import Dispatch

//MARK: STRING

private enum UIAbbreviationLabelString: String {
    case cigaretteImageName = "cigarette"
    case smokeImageName = "smoke"
    case charAnimationKey = "opacity"
    case charLayerName = "char"
}

//MARK: CONSTANTS

private enum UIAbbreviationLabelConstants{
    static let defTextSize: CGFloat = 45
}

// MARK: DELEGATE

protocol UIAbbreviationDelegate: AnyObject {
    func didEndedPresentAnimation()
}

final class UIAbbreviationLabel: UIView {
    
    weak var delegate: UIAbbreviationDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    //MARK: showAbbreviation
    func showAbbreviation() {
        let stringAttributes = [NSAttributedString.Key.font: UIFont(name: AppString.fontName.rawValue, size: UIAbbreviationLabelConstants.defTextSize)!]
        let attributedString = NSMutableAttributedString(string: AppString.appName.rawValue, attributes: stringAttributes )
        let charPaths = self.getCharPaths(attributedString: attributedString, position: CGPoint(x: -10, y: labelHeight - 10))
        
        charPaths.enumerated().forEach { index, path in
            let  shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = #colorLiteral(red: 0.9456624389, green: 0.9458207488, blue: 0.9456415772, alpha: 1).cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.path = path
            
            self.layer.addSublayer(shapeLayer)
            
            let animation = CABasicAnimation(keyPath: UIAbbreviationLabelString.charAnimationKey.rawValue)
            animation.fromValue = 1
            animation.toValue = 0
            animation.fillMode = .forwards;
            animation.isRemovedOnCompletion = false;
            
            let length = charPaths.count
            
            switch index {
            case length / 2 - 1:
                animation.delegate = self
                fallthrough
            case 0...length / 2 - 2:
                animation.duration = CFTimeInterval(index + 1)
            case length / 2 + 1...length - 1:
                animation.duration = CFTimeInterval(length - index + 1)
            case length / 2:
                return
            default:
                break
            }
            
            shapeLayer.name = UIAbbreviationLabelString.charLayerName.rawValue
            shapeLayer.add(animation, forKey: UIAbbreviationLabelString.charAnimationKey.rawValue)
        }
    }
    
    //MARK: showSmoke
    func showSmoke(){
        animateSmoke()
    }
    
    //MARK: PRIVATE
    
    private var labelHeight: CGFloat {self.frame.height}
    
    //MARK: UI
    
    private lazy var cigaretteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: UIAbbreviationLabelString.cigaretteImageName.rawValue))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.alpha = 0
        return imageView
    }()
    
    private lazy var smokeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: UIAbbreviationLabelString.smokeImageName.rawValue))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.alpha = 0
        return imageView
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsCigaretteImageView() {
        cigaretteImageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.height).multipliedBy(0.57)
            make.height.equalTo(self.snp.height).multipliedBy(0.57)
            make.centerX.equalTo(self.snp.centerX).offset(-22)
            make.bottom.equalTo(self.snp.bottom).offset(-6.5)
        }
    }
    
    private func constraintsSmokeImageView() {
        smokeImageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.height).multipliedBy(0.85)
            make.height.equalTo(self.snp.height).multipliedBy(0.85)
            make.centerX.equalTo(cigaretteImageView.snp.centerX).offset(-12)
            make.bottom.equalTo(cigaretteImageView.snp.top).offset(8)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        self.addSubview(cigaretteImageView)
        self.addSubview(smokeImageView)
        
        constraintsCigaretteImageView()
        constraintsSmokeImageView()
    }
    
    private func getCharPaths(attributedString: NSAttributedString, position: CGPoint) -> [CGPath] {
        
        let line = CTLineCreateWithAttributedString(attributedString)
        
        guard let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return []}
        
        var characterPaths = [CGPath]()
        
        for glyphRun in glyphRuns {
            guard let attributes = CTRunGetAttributes(glyphRun) as? [String:AnyObject] else { continue }
            let font = attributes[kCTFontAttributeName as String] as! CTFont
            
            for index in 0..<CTRunGetGlyphCount(glyphRun) {
                let glyphRange = CFRangeMake(index, 1)
                
                var glyph = CGGlyph()
                CTRunGetGlyphs(glyphRun, glyphRange, &glyph)
                
                var characterPosition = CGPoint()
                CTRunGetPositions(glyphRun, glyphRange, &characterPosition)
                characterPosition.x += position.x
                characterPosition.y += position.y
                
                if let glyphPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                    var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: characterPosition.x, ty: characterPosition.y)
                    if let charPath = glyphPath.copy(using: &transform) {
                        characterPaths.append(charPath)
                    }
                }
            }
        }
        return characterPaths
    }
}

//MARK: ANIMATION EXTENSION

private extension UIAbbreviationLabel {
    
    func animateCigaretteWithEnding(delegate: UIAbbreviationDelegate?){
        UIView.animate(withDuration: 2, animations: {[weak self] in
            guard let self = self else{return}
            self.cigaretteImageView.alpha = 0.9
        }, completion: { _ in
            delegate?.didEndedPresentAnimation()
        })
    }
    
    func animateSmoke(){
        UIView.animate(withDuration: 3) {[weak self] in
            guard let self = self else{return}
            self.smokeImageView.alpha = 0.8
        }
    }
}

//MARK: DELEGATE EXTENSION

extension UIAbbreviationLabel:CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animateCigaretteWithEnding(delegate: delegate)
    }
}
