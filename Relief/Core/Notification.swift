import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var programaIniciado = false
    private var timer: Timer?
    private var timerInterval = 10.0
    private var timerCounts = 0

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permissão concedida")
            } else if let error = error {
                print("Permissão negada: \(error.localizedDescription)")
            }
        }
    }
    func startTimer() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Timer iniciado")
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
        print("Agendando timer com intervalo: \(timerInterval)")

        self.timerCounts += 1

        if timerCounts == 1 {
            self.scheduleNotification(title: "Momento Relief", body: "Hora de voltar ao foco!", interval: timerInterval)
        }

        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            print("Timer disparado, agendando notificação")

            self.timerInterval += 5
            self.scheduleNotification(title: "Momento Relief", body: "Hora de voltar ao foco!", interval: self.timerInterval)
            self.scheduleTimer()
        }
    }




    private func scheduleNotification(title: String, body: String, interval: TimeInterval) {
        print("Agendando notificação com intervalo: \(interval)")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            } else {
                print("Notificação agendada com sucesso")
            }
        }
    }
}
