//
//  UIGraphView.swift
//  iTobacWorker
//
//  Created by Nikolas on 27.12.2021.
//

import Foundation
import UIKit
import Dispatch

//MARK: STRING

private enum UIGraphViewString: String{
    case markupLayerName = "markup"
    case pointAnimationKey = "transform.scale"
}

//MARK: CONSTANTS

private enum UIGraphViewConstants {
    static let margin: CGFloat = 15.0
    static let topBorder: CGFloat = 45
    static let bottomBorder: CGFloat = 35
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 8.0
    static let defTextSize: CGFloat = 15
}

final class UIGraphView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeUI()
        makeLayer()
    }
    
    //MARK: updateGraph
    func updateGraph(_ setup:  GraphSetup){
        if (!checkGraphExist(setup)) {return}
        if (!checkGraphsMaxValue([setup])) {return}
        
        updateGraphSetups(setup)
        removeGraphs([setup.annotation])
        showGraph(setup)
    }
    
    //MARK: setGraphs
    func setGraphs(_ newSetups: [GraphSetup]?) {
        if let setups = newSetups {
            if (setups.isEmpty) {return}
            if (!checkGraphsMaxValue(setups)) {return}
            self.currentGraphSetups = setups
        }
        
        guard let currentGraphSetups = self.currentGraphSetups else{return}
        
        removeGraphs(nil)
        for setup in currentGraphSetups {
            showGraph(setup)
        }
    }
    
    //MARK: getCurrentGraphSetups
    func getCurrentGraphSetups() -> Dictionary<String, GraphSetup>?{
        guard let currentGraphSetups = self.currentGraphSetups else{return nil}
        
        var result = Dictionary<String, GraphSetup>()
        currentGraphSetups.forEach { setup in
            result[setup.annotation] = setup
        }
        return result
    }
    
    
    //MARK: PRIVATE
    
    private var viewWidth: CGFloat {self.frame.height}
    private var viewHeight: CGFloat {self.frame.height}
    private var maxValue: Int?
    private var currentGraphSetups: [GraphSetup]?
    
    //MARK: UI
    
    private lazy var minValueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: viewWidth - UIGraphViewConstants.margin + 2, y: viewHeight - UIGraphViewConstants.bottomBorder - viewHeight * 0.05, width: viewHeight * 0.1, height: viewHeight * 0.1))
        label.font = UIFont(name: AppString.fontName.rawValue, size: UIGraphViewConstants.defTextSize)
        label.backgroundColor = .clear
        label.textColor = .lightGray
        label.text = "\(0)"
        return label
    }()
    
    private lazy var maxValueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: viewWidth - UIGraphViewConstants.margin + 2, y: UIGraphViewConstants.topBorder - viewHeight * 0.05, width: viewWidth * 0.2, height: viewHeight * 0.1))
        label.font = UIFont(name: AppString.fontName.rawValue, size: UIGraphViewConstants.defTextSize)
        label.backgroundColor = .clear
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var weekStackView: UIStackView = {
        let view = UIStackView(frame: CGRect(x: UIGraphViewConstants.margin, y: viewHeight - UIGraphViewConstants.bottomBorder, width: viewWidth - 2 * UIGraphViewConstants.margin, height: viewHeight * 0.1))
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var annotationStackView: UIStackView = {
        let view = UIStackView(frame: CGRect(x: UIGraphViewConstants.margin, y: UIGraphViewConstants.topBorder - viewHeight * 0.1 - 10, width: viewWidth - 2 * UIGraphViewConstants.margin, height: viewHeight * 0.1))
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        self.addSubview(minValueLabel)
        self.addSubview(maxValueLabel)
        self.addSubview(weekStackView)
        self.addSubview(annotationStackView)
        
        addWeekStack()
    }
    
    private func makeLayer() {
        let color = #colorLiteral(red: 0.1582991481, green: 0.1590825021, blue: 0.1307061911, alpha: 1)
        self.layer.drawBlockLayer(cornerWidth: 25, color: color, borderWidth: nil)
        self.showMarkup()
    }
    
    private func showMarkup(){
        if self.layer.sublayers?.contains(where: {$0.name == UIGraphViewString.markupLayerName.rawValue}) == true {
            return
        }
        
        let horizontalLayer = drawHorizontalMarkup()
        let verticalLayer = drawVerticalMarkup()
        
        self.layer.addSublayer(horizontalLayer)
        self.layer.addSublayer(verticalLayer)
        
    }
    
    private func addWeekStack(){
        if (!self.weekStackView.arrangedSubviews.isEmpty){return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        let weekdays = dateFormatter.shortWeekdaySymbols.shift()
        for weekday in weekdays {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: (viewWidth - 2 * UIGraphViewConstants.margin) / 7).isActive = true
            label.textAlignment = .center
            label.font = UIFont(name: AppString.fontName.rawValue, size: UIGraphViewConstants.defTextSize - 2)
            label.textColor = .lightGray
            label.text = weekday
            weekStackView.addArrangedSubview(label)
        }
    }
    
    private func showGraphAnnotation(_ setup: GraphSetup) {
        let width = (setup.viewSetup!.width - 2 * UIGraphViewConstants.margin) / 2
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.textAlignment = .center
        label.font = UIFont(name: AppString.fontName.rawValue, size: UIGraphViewConstants.defTextSize - 2)
        label.textColor = .lightGray
        label.text = setup.annotation
        
        let lineLayer = drawAnnotationLine(to: width, color: setup.color)
        
        label.layer.addSublayer(lineLayer)
        label.layer.sublayers?.first?.addActivationAnimation()
        
        let index = currentGraphSetups?.firstIndex(of: setup)
        self.annotationStackView.insertArrangedSubview(label, at: index!)
    }
    
    private func showGraph(_ setup: GraphSetup) {
        var finalSetup = setup
        if (finalSetup.viewSetup == nil) {
            finalSetup.viewSetup = ViewSetup(width: self.viewWidth, height: self.viewHeight, graphMaxValue: self.maxValue!)
        }
        
        let graphLayer = self.drawGraph(finalSetup)
        self.layer.addSublayer(graphLayer.line)
        self.layer.addSublayer(graphLayer.clipping)
        graphLayer.points.enumerated().forEach {(index,point) in
            point.addStickAnimation(duration: CGFloat(index + 1) / 10 + 0.1)
            self.layer.addSublayer(point)
        }

        self.showGraphAnnotation(finalSetup)
    }
    
    private func checkGraphsMaxValue(_ setups: [GraphSetup]) -> Bool {
        if setups.count == 1{
            guard let newMaxValue = setups.first?.points.max() else{return false}
            switch self.maxValue{
            case (let maxValue?):
                if (newMaxValue > maxValue){
                    fallthrough
                }
            default:
                self.maxValue = newMaxValue
            }
        }else{
            var allMaxValue:[Int] = []
            for setup in setups {
                guard let maxValue = setup.points.max() else{continue}
                allMaxValue.append(maxValue)
            }
            guard let maxValue = allMaxValue.max() else{return false}
            self.maxValue = maxValue
        }
        
        self.maxValueLabel.text =  self.maxValue == 0 ? "" : "\(self.maxValue!)"
        return true
    }
    
    private func checkGraphExist(_ setup: GraphSetup) -> Bool{
        let setups = currentGraphSetups?.filter {$0.annotation == setup.annotation}
        
        switch setups {
        case (let setups?):
            if(!setups.isEmpty){
                return true
            }else{
                fallthrough
            }
        default:
            return false
        }
    }
    
    private func removeGraphs(_ annotations: [String]?) {
        guard let currentSetups = currentGraphSetups else {
            return
        }
        
        let removedAnnotations:[String]!
        if let annotations = annotations {
            removedAnnotations = annotations
        }else{
            removedAnnotations = currentSetups.map {$0.annotation}
        }
        
        self.layer.sublayers?.forEach {layer in
            guard let name = layer.name else{return}
            if (removedAnnotations.contains(name)){
                layer.removeFromSuperlayer()
            }
        }
        
        self.annotationStackView.arrangedSubviews.forEach {view in
            guard let label = view as? UILabel else{return}
            guard let name = label.text else{return}
            if (removedAnnotations.contains(name)) {
                view.removeFromSuperview()
            }
        }
    }
    
    private func updateGraphSetups(_ newSetup: GraphSetup){
        guard let currentSetups = currentGraphSetups else {
            return
        }
        
        currentSetups.enumerated().forEach {index, currentSetup in
            if (currentSetup.annotation == newSetup.annotation){
                currentGraphSetups![index] = newSetup
            }
        }
    }
    
    private func calculateX(_ column: Int,_ setup: GraphSetup?) -> CGFloat{
        let margin = UIGraphViewConstants.margin
        let graphWidth = (setup?.viewSetup?.width ?? self.viewWidth) - margin * 2 - 10
        let spacing = graphWidth / CGFloat(6)
        
        return CGFloat(column) * spacing + margin + 5
    }
    
    private func calculateY(_ graphPoint: Int, _ setup: GraphSetup) -> CGFloat {
        let topBorder = UIGraphViewConstants.topBorder
        let bottomBorder = UIGraphViewConstants.bottomBorder
        let graphHeight = setup.viewSetup!.height - topBorder - bottomBorder
        
        
        let yPoint =  CGFloat(graphPoint) / CGFloat(setup.viewSetup!.graphMaxValue == 0 ? 1 : setup.viewSetup!.graphMaxValue) * graphHeight
        
        return graphHeight + topBorder - yPoint
    }
    
    //MARK: DRAW
    
    private func drawHorizontalMarkup() -> CAShapeLayer {
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x:UIGraphViewConstants.margin, y: UIGraphViewConstants.topBorder))
        linePath.addLine(to: CGPoint(x: viewWidth - UIGraphViewConstants.margin, y: UIGraphViewConstants.topBorder))
        
        linePath.move(to: CGPoint(x: UIGraphViewConstants.margin, y: viewHeight / 2))
        linePath.addLine(to: CGPoint(x: viewWidth - UIGraphViewConstants.margin, y: viewHeight / 2))
        
        linePath.move(to: CGPoint(x: UIGraphViewConstants.margin, y: viewHeight - UIGraphViewConstants.bottomBorder))
        linePath.addLine(to: CGPoint(x: viewWidth - UIGraphViewConstants.margin, y: viewHeight - UIGraphViewConstants.bottomBorder))
        
        let color = UIColor(white: 1.0, alpha: UIGraphViewConstants.colorAlpha)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.name = UIGraphViewString.markupLayerName.rawValue
        
        return shapeLayer
    }
    
    private func drawVerticalMarkup() -> CAShapeLayer {
        let linePath = UIBezierPath()
        
        for column in 0...6{
            linePath.move(to: CGPoint(x: calculateX(column, nil), y: viewHeight - UIGraphViewConstants.bottomBorder))
            linePath.addLine(to: CGPoint(x: calculateX(column, nil), y: viewHeight - UIGraphViewConstants.bottomBorder - 5))
        }
        
        let color = UIColor(white: 1.0, alpha: UIGraphViewConstants.colorAlpha)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.name = UIGraphViewString.markupLayerName.rawValue
        
        return shapeLayer
    }
    
    private func drawGraph(_ setup: GraphSetup)  -> Graph{
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: calculateX(0, setup), y: calculateY(setup.points[0], setup)))
        
        var pointLayers: [CAShapeLayer] = []
        for i in 0..<setup.points.count{
            var nextPoint = CGPoint(x: calculateX(i,setup), y: calculateY(setup.points[i], setup))
            
            linePath.addLine(to: nextPoint)
            
            nextPoint.x -= UIGraphViewConstants.circleDiameter / 2
            nextPoint.y -= UIGraphViewConstants.circleDiameter / 2
            
            let pointPath = UIBezierPath(ovalIn: CGRect(origin: nextPoint, size: CGSize(width: UIGraphViewConstants.circleDiameter, height: UIGraphViewConstants.circleDiameter)))
            let pointLayer = CAShapeLayer()
            pointLayer.path = pointPath.cgPath
            pointLayer.fillColor = setup.color.cgColor
            pointLayer.name = setup.annotation
            pointLayers.append(pointLayer)
        }
        
        let linesLayer = CAShapeLayer()
        linesLayer.path = linePath.cgPath
        linesLayer.strokeColor = setup.color.cgColor
        linesLayer.fillColor = UIColor.clear.cgColor
        linesLayer.lineWidth = 3
        linesLayer.lineCap = .round
        linesLayer.name = setup.annotation
        
        let clippingLayer = drawGraphClipping(setup, path: UIBezierPath(cgPath: linesLayer.path!))
        
        return Graph(line: linesLayer, points: pointLayers, clipping: clippingLayer)
    }
    
    private func drawGraphClipping(_ setup: GraphSetup, path: UIBezierPath) -> CAShapeLayer {
        let clippingPath = path.copy() as! UIBezierPath
        
        clippingPath.addLine(to: CGPoint(x: calculateX(6, setup),y: viewHeight - UIGraphViewConstants.bottomBorder - 5))
        clippingPath.addLine(to: CGPoint(x: calculateX(0, setup), y: viewHeight - UIGraphViewConstants.bottomBorder - 5))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = clippingPath.cgPath
        shapeLayer.fillColor = setup.color.cgColor
        shapeLayer.opacity = 0.3
        shapeLayer.name = setup.annotation
        
        return shapeLayer
    }
    
    private func drawAnnotationLine(to x: CGFloat,color: UIColor) -> CAShapeLayer{
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: 20, y: self.annotationStackView.frame.height))
        linePath.addLine(to: CGPoint(x: x - 20, y: self.annotationStackView.frame.height))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineCap = .round
        return shapeLayer
    }
}

//MARK: ANIMATION EXTENSION

private extension CALayer {
    func addStickAnimation(duration: CGFloat){
        let animation = CABasicAnimation(keyPath: UIGraphViewString.pointAnimationKey.rawValue)
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        self.add(animation, forKey: UIGraphViewString.pointAnimationKey.rawValue)
    }
}


//MARK: EXTENSION

private extension Array {
    func shift(withDistance distance: Int = 1) -> Array<Element> {
        let offsetIndex = distance >= 0 ?
        self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
        self.index(endIndex, offsetBy: distance, limitedBy: startIndex)
        
        guard let index = offsetIndex else { return self }
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }
}


