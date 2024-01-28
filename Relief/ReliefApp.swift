//
//  ReliefApp.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 21/12/23.
//

import SwiftUI

@main
struct ReliefApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
