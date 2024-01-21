import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var programaIniciado = false
    private var timer: Timer?
    private var timerInterval = 10.0

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // Tratamento da resposta do usuário
        }
    }

    func startTimer() {
        programaIniciado = true
        timerInterval = 10.0
        scheduleTimer()
    }

    func stopTimer() {
        programaIniciado = false
        timer?.invalidate()
        timer = nil
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func scheduleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.scheduleNotification(title: "Momento Relief", body: "Hora de voltar ao foco!", interval: self.timerInterval)
            self.timerInterval += 5
            self.scheduleTimer()
        }
    }

    private func scheduleNotification(title: String, body: String, interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            }
        }
    }
}
