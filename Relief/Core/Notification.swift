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

            self.timerInterval += 0
            self.scheduleNotification(title: "Momento Relief", body: "Hora de voltar ao foco!", interval: self.timerInterval)
            self.scheduleTimer()
        }
    }
    
    func scheduleTestNotification() {
          let content = UNMutableNotificationContent()
          content.title = "Teste de Notificação"
          content.body = "Esta é uma notificação de teste para o modo segundo plano."
          content.sound = UNNotificationSound.default

          // Agendando a notificação para daqui a 15 segundos
          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
          let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

          UNUserNotificationCenter.current().add(request) { error in
              if let error = error {
                  print("Erro ao agendar notificação de teste: \(error.localizedDescription)")
              } else {
                  print("Notificação de teste agendada com sucesso")
              }
          }
      }
    
    func sendImmediateNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil) // nil trigger para notificação imediata

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao disparar notificação imediata: \(error.localizedDescription)")
            } else {
                print("Notificação imediata disparada com sucesso")
            }
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
