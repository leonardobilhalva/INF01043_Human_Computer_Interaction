import DeviceActivity
import UserNotifications
import SwiftUI

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    override init() {
           super.init()
//        scheduleNotification(with: "INICIOU O EXTERNO")
           // Solicitação de permissão para enviar notificações
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound]) { granted, error in
               if let error = error {
                   print("Erro na solicitação de permissão para notificações: \(error)")
               }
           }
       }
    
    func scheduleInstantNotification(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default
                
                // Definir o gatilho para um tempo muito curto para disparar instantaneamente
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                
                // Usar um identificador único para cada notificação
                let requestIdentifier = UUID().uuidString
                let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            } else {
                print("Permission denied. \(error?.localizedDescription ?? "")")
            }
        }
    }


    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
//        print("Interval began")
//        scheduleNotification(with: "interval did start")
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
//        print("Interval ended")
//        scheduleNotification(with: "interval did end")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        scheduleInstantNotification(title: "Momento Relief", body: "Está na hora de desconectar!")
    }
    
//    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventWillReachThresholdWarning(event, activity: activity)
//        
//        // Handle the warning before the event reaches its threshold.
//        print("Interval will reach threshold")
//        scheduleNotification(with: "event will reach threshold warning")
//    }
    
//    override func intervalWillStartWarning(for activity: DeviceActivityName) {
//        super.intervalWillStartWarning(for: activity)
//        
//        // Handle the warning before the interval starts.
//        print("Interval will start")
//        scheduleNotification(with: "interval will start warning")
//    }
//    
//    override func intervalWillEndWarning(for activity: DeviceActivityName) {
//        super.intervalWillEndWarning(for: activity)
//        
//        // Handle the warning before the interval ends.
//        print("Interval will end")
//        scheduleNotification(with: "interval will end warning")
//    }
    
}
