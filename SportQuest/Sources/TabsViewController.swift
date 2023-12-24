//
//  TabsViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView

class TabsViewController: AMTabsViewController{
    
    var notificationService: NotificationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTabControllers()
      
        notificationService = NotificationService()
        notificationService?.userNotificationCenter.delegate = self
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didSwippedViewControllers)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        notificationService?.requestNotificationAuthorization()
        notificationService?.sendNotification()
    }
    
    func setTabControllers() {
        let runViewController = RunViewController()
        runViewController.enableSwipeNavigation = {[weak self] enable in
            guard let self = self else {return}
            if enable {
                self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.didSwippedViewControllers)))
            }else {
                self.view.gestureRecognizers?.removeAll()
            }
        }
        let accountViewController = AccountViewController()
        viewControllers = [
            runViewController,
            accountViewController,
        ]
    }
    
    //MARK: OBJC
    
    @objc func didSwippedViewControllers(_ sender: UIPanGestureRecognizer){
        if sender.state == .ended {
            let velocity = sender.velocity(in: self.view)
            if (velocity.x > 0) {
                selectedTabIndex = 0
            } else {
                selectedTabIndex = 1
            }
        }
    }
}

//MARK: DELEGATE

extension TabsViewController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}



