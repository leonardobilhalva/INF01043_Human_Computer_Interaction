//
//  AppDelegate.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 21/01/24.
//

import Foundation
import UIKit
import UserNotifications
import DeviceActivity

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

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
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("App vai se tornar inativo")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App entrou em background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("App vai entrar em foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App se tornou ativo")
    }
    
}
