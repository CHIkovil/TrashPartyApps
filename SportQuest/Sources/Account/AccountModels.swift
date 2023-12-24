//
//  AccountModels.swift
//  SportQuest
//
//  Created by Nikolas on 09.02.2022.
//  Copyright © 2022 Никита Бычков. All rights reserved.
//

import Foundation

enum AccountModels {
    enum SkillsName: String, CaseIterable {
        case Agility, Endurance, Force

        init?(id : Int) {
            switch id {
            case 0: self = .Agility
            case 1: self = .Endurance
            case 2: self = .Force
            default: return nil
            }
        }
    }
    
    struct UserProgress {
        let user: User
        let skillsStore:[Double]
        let achievesStore: Int
    }
    
    
    struct Skills {
        var agility: Double
        var endurance:Double
        var force:Double
    }
}

typealias SkillsName = AccountModels.SkillsName
typealias Skills = AccountModels.Skills
typealias UserProgress = AccountModels.UserProgress
