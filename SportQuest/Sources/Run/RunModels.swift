//
//  RunModels.swift
//  SportQuest
//
//  Created by Nikolas on 08.02.2022.
//  Copyright © 2022 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit

enum RunModels {
    enum Week: String, CaseIterable {
        case Mon, Tue, Wed, Thu, Fri, Sat, Sun

        init?(id : Int) {
            switch id {
            case 0: self = .Mon
            case 1: self = .Tue
            case 2: self = .Wed
            case 3: self = .Thu
            case 4: self = .Fri
            case 5: self = .Sat
            case 6: self = .Sun
            default: return nil
            }
        }
    }
    
    struct Quote: Codable {
        let text: String
        let author: String?
    }
    
    struct Chart {
        var week: [Double]
        var month: [Double]
        var showValue: Bool
    }
    
    struct Table {
        var rows: [NSMutableAttributedString]
        var palette: [String:UIColor]
    }
    
    struct Mode {
        var distance: Int?
        var coordinates:String?
        var time: String?
        var countInterval: String?
        
        func checkAllData() -> Bool {
            guard let _ = distance, let _ = coordinates, let _ = time, let _ = countInterval else {
                return false
            }
            return true
        }
    }

    
}

typealias Quotes = [RunModels.Quote]
typealias Week  = RunModels.Week
typealias Chart = RunModels.Chart
typealias Table = RunModels.Table
typealias Mode = RunModels.Mode

