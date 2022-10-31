//
//  AchieveService.swift
//  SportQuest
//
//  Created by Никита Бычков on 17.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation

class AchieveService {
    
    func getAchieveData() -> [Achieve]{
        let gif = ["achieve1", "achieve2"]
        let text = ["First 100m", "First 1000m"]
        let store = [50, 100]
        
        let achieves = (0..<2).map {index in
            return Achieve(gif: gif[index], text: text[index], store: store[index])
        }
        return achieves
    }
}
