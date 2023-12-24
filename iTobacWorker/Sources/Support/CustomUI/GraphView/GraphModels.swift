//
//  GraphModel.swift
//  iTobacWorker
//
//  Created by Nikolas on 01.01.2022.
//

import Foundation
import UIKit

enum GraphModels {
    struct GraphSetup: Hashable{
        var points: [Int]
        let color: UIColor
        let annotation: String
        var viewSetup: ViewSetup?
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(annotation)
        }
        
        static func == (lhs: GraphModels.GraphSetup, rhs: GraphModels.GraphSetup) -> Bool {
            return lhs.annotation == rhs.annotation
        }
    }
    
    struct Graph {
        let line: CAShapeLayer
        let points: [CAShapeLayer]
        let clipping: CAShapeLayer
    }
    
    struct ViewSetup {
        let width: CGFloat
        let height: CGFloat
        let graphMaxValue: Int
    }
}

typealias GraphSetup = GraphModels.GraphSetup
typealias Graph = GraphModels.Graph
typealias ViewSetup = GraphModels.ViewSetup
