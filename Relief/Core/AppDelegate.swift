//
//  AppDelegate.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 21/01/24.
//

import Foundation
import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    UNUserNotificationCenter.current().delegate = self

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if granted {
            print("Permissão para notificações concedida.")
        } else if let error = error {
            print("Permissão para notificações negada: \(error)")
        }
            }
    
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        for request in requests {
            print("Notificação pendente: \(request.identifier) - \(request.trigger)")
        }
    }
        
       return true
   }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    
}
