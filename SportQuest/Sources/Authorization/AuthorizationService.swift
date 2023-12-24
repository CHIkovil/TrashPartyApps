//
//  AuthorizationService.swift
//  SportQuest
//
//  Created by Никита Бычков on 18.07.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AuthorisationService {
    
    func getUserData(callback: @escaping(Login?) -> Void){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        
        if let password = KeychainService.loadPassword(service: "SportQuest", account: "SportQuest"),let result = try? context.fetch(request) as? [NSManagedObject]{
            if !result.isEmpty{
                callback(Login(nickname: result[0].value(forKey: "nickname") as! String, password: password))
            }else{
                callback(nil)
            }
        }else{
            callback(nil)
        }
    }
}
