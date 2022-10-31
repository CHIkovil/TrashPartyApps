//
//  AchievePresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 18.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation

class AchievePresenter {
    private let achieveService:AchieveService
    
    init(achieveService:AchieveService){
        self.achieveService = achieveService
    }
    
    func getCollectionData() -> [Achieve]{
        return achieveService.getAchieveData()
    }
}
