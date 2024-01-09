//
//  MonitorView.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 21/12/23.
//

import SwiftUI
import DeviceActivity
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configurar o monitoramento de eventos de atividade do dispositivo aqui
        startDeviceActivityMonitoring()
        return true
    }

    func startDeviceActivityMonitoring() {
//        let criteria = DeviceActivityCriteria()
//        
//        // Aqui você definiria critérios específicos, mas devido às restrições do iOS,
//        // não é possível especificar o monitoramento do uso do Safari.
//        // Por exemplo, você pode definir critérios para eventos de desbloqueio de tela.
//        criteria.requiresDeviceUnlock = true
//
//        DeviceActivityEvent.monitor(criteria) { event in
//            // Aqui você processaria o evento recebido
//            self.handleDeviceActivityEvent(event)
//        }
    }

    func handleDeviceActivityEvent(_ event: DeviceActivityEvent) {
        // Implemente sua lógica aqui. Por exemplo, registrar o evento em um log.
        print("Evento de atividade do dispositivo recebido: \(event)")
    }
}


struct MonitorView: View {
    var body: some View {
        Text("texte")
    }
}
