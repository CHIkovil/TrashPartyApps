//
//  NotificationService.swift
//  SportQuest
//
//  Created by Никита Бычков on 12.08.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import NotificationCenter
import CoreData

class NotificationService {
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification() {
        if let notifications = UIApplication.shared.scheduledLocalNotifications{
            if !notifications.isEmpty{
                return
            }
        }
    
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "SportQuest"
        notificationContent.body = "It's time to run my friend!🧐"
        notificationContent.badge = NSNumber(value: 1)
        
        if let resource = getUserRaceData(){
            if let url = Bundle.main.url(forResource: resource.lowercased(),
                                         withExtension: "png") {
                if let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString,
                                                                  url: url,
                                                                  options: nil) {
                    notificationContent.attachments = [attachment]
                }
            }
        }
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 30
        
        let trigger =  UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}

//MARK: SUPPORT FUNC

extension NotificationService{
    
    func getUserRaceData() -> String?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        let result = try? context.fetch(request) as? [NSManagedObject]
        switch result {
        case let result?:
            if !result.isEmpty{
                return result[0].value(forKey: "race") as? String
            }else{
                fallthrough
            }
        default:
            return nil
        }

    }
}
