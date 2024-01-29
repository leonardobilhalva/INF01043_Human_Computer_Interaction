//
//  SettingsView.swift
//  Relief
//
//  Created by Leonardo Bilhalva on 09/01/24.
//

import Foundation
import SwiftUI
import UserNotifications
import FamilyControls


struct SettingsView: View {
    @State private var isViewControllerWrapperSheetPresented = false

    @EnvironmentObject var monitorManager: MonitorManager
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Seção da Configuração")) {
                    Button(action: {
                        isViewControllerWrapperSheetPresented.toggle()
                    }) {
                        Text("Abrir ViewControllerWrapper")
                    }
                }
                .sheet(isPresented: $isViewControllerWrapperSheetPresented) {
                    ViewControllerWrapper().environmentObject(monitorManager).environmentObject(notificationManager)
                }

                Section(header: Text("Tempo Permitido")) {
                    Text("Definir tempo permitido nos aplicativos selecionados")
                }

                Section(header: Text("Dias e Horários de Monitoramento")) {
                    Text("Definir os dias e horários de monitoramento")
                }
            }
            .listStyle(GroupedListStyle())
            .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
            .navigationBarTitle("Configurações")
        }
    }
}

struct AppSelectionView: View {
    var body: some View {
        Text("Aqui você pode selecionar os aplicativos")
            .navigationBarTitle("Selecionar Aplicativos")
    }
}


struct ViewControllerWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var monitorManager: MonitorManager
    @EnvironmentObject var notificationManager: NotificationManager

    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController(notificationManager: notificationManager)
        monitorManager.viewController = viewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

