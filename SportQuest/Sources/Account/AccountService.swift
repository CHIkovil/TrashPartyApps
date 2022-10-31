//
//  AccountService.swift
//  SportQuest
//
//  Created by Никита Бычков on 16.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import Charts
import CoreData

class AccountService{
    var normDistance: Int?
    
    func getUserProgressData(callback: @escaping(UserProgress?) -> Void){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        
        let result = try? context.fetch(request) as? [NSManagedObject]
        switch result {
        case let result?:
            if !result.isEmpty{
                let normDistance = result[0].value(forKey: "normDistance") as! Int
                self.normDistance = normDistance
                callback(parseToUserProcess(data: User(race: result[0].value(forKey: "race") as! String, nickname: nil, normDistance: normDistance, password: nil)))
            }else{
                fallthrough
            }
        default:
            callback(nil)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    func parseToUserProcess(data: User) -> UserProgress {
        var skills: Skills
        switch data.race {
        case "Chair":
            skills = Skills(agility: 10, endurance: 100, force: 10)
        case "Knight":
            skills = Skills(agility: 50, endurance: 50, force: 150)
        default:
            skills = Skills(agility: 0, endurance: 0, force: 0)
        }
        
        var achieveStore = 0
        for (name, store) in zip(["achieve1", "achieve2"], [50,100]) {
            if let _ = UserDefaults.standard.string(forKey: name){
                switch name {
                case "achieve1":
                    skills.agility += Double(store)
                case "achieve2":
                    skills.force += Double(store)
                default:break
                }
                achieveStore += store
            }
        }
        return UserProgress(user: data, skillsStore: [skills.agility,skills.endurance, skills.force], achievesStore: achieveStore)
    }
}
