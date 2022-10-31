//
//  AuthorizationModels.swift
//  SportQuest
//
//  Created by Никита Бычков on 08.08.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation

enum AuthorizationModels{
    struct Login {
        let nickname: String
        let password: String
    }
}

typealias Login = AuthorizationModels.Login
