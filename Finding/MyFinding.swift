//
//  MyFinding.swift
//  Finding
//
//  Created by Leonardo Bilhalva on 25/01/24.
//

import Foundation
import UIKit
import MobileCoreServices
import ManagedSettings
import DeviceActivity

class MyMFinding: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("interval did start")
        let model = MyFindingModel.shared
        let applications = model.selectionToDiscourage.applicationTokens
        store.shield.applications = applications.isEmpty ? nil : applications
        store.dateAndTime.requireAutomaticDateAndTime = true
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        store.shield.applications = nil
        store.dateAndTime.requireAutomaticDateAndTime = false
    }
}
