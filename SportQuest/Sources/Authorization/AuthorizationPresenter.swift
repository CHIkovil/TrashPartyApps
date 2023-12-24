//
//  AuthorizationPresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 18.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation

class AuthorisationPresenter {
    
    private let authorisationService:AuthorisationService
    weak private var authorisationViewDelegate : AuthorisationViewDelegate?
    
    init(authorisationService:AuthorisationService){
        self.authorisationService = authorisationService
    }
    
    func setViewDelegate(authorisationViewDelegate:AuthorisationViewDelegate){
        self.authorisationViewDelegate = authorisationViewDelegate
    }
    
    func getUserData(){
        authorisationService.getUserData {[weak self] data in
            guard let self = self else{return}
            self.authorisationViewDelegate?.showUserData(data)
        }
    }
}
