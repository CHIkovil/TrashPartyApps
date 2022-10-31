//
//  RegistrationModels.swift
//  SportQuest
//
//  Created by Nikolas on 07.02.2022.
//  Copyright © 2022 Никита Бычков. All rights reserved.
//

import Foundation

enum RegistrationModels{
    struct User {
        let race: String
        let nickname: String?
        let normDistance: Int
        let password: String?
    }
    
    public enum Race: String, CaseIterable {
        case Chair, Knight

        init?(id : Int) {
            switch id {
            case 0: self = .Chair
            case 1: self = .Knight
       
            default: return nil
            }
        }
    }
}

typealias User = RegistrationModels.User
typealias Race = RegistrationModels.Race
