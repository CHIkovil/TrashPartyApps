//
//  RegistrationPresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 20.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RegistrationPresenter {
    private let registrationService:RegistrationService
    
    init(registrationService:RegistrationService){
        self.registrationService = registrationService
    }
    
    func saveUserData(data: User){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
        let newUserData = NSManagedObject(entity: entity!, insertInto: context)
        
        newUserData.setValue(data.race, forKey: "race")
        newUserData.setValue(data.nickname, forKey: "nickname")
        newUserData.setValue(data.normDistance, forKey: "normDistance")
        
        do{
            try context.save()
            if let _ = KeychainService.loadPassword(service: "SportQuest", account: "SportQuest"){
                KeychainService.updatePassword(service: "SportQuest", account: "SportQuest", data: data.password!)
            }else{
               KeychainService.savePassword(service: "SportQuest", account: "SportQuest", data: data.password!)
            }
            
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
}
