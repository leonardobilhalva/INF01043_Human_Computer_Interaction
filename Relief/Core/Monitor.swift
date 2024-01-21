//
//  MonitorView.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 21/12/23.
//

import SwiftUI
import DeviceActivity
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       let center = UNUserNotificationCenter.current()
       center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
       }
       return true
   }
}
