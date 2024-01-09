//
//  SettingsView.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 09/01/24.
//

import Foundation
import SwiftUI
import UserNotifications

class TimerManager: ObservableObject {
    @Published var programaIniciado = false
    var timerInterval = 10.0
    var timer: Timer?

    func startTimer() {
        timerInterval = 10.0 // Inicia com 10 segundos
        scheduleNotification()
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.timerInterval += 5 // Aumenta o intervalo
            self.startTimer() // Reagenda o timer
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerInterval = 10.0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Momento Relief"
        content.body = "Hora de voltar ao foco!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timerInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            }
        }
    }
}
