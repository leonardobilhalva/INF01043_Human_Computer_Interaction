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


struct ScreenTimeSelectAppsContentView: View {
    @State private var activeDays = Array(repeating: false, count: 7)
    @State private var timeLimit: TimeInterval = TimeLimitView.loadTimeLimitFromUserDefaults()

    @State private var pickerIsPresented = false
    @State private var isTimeLimitSheetPresented = false
    @State private var isDayPickerSheetPresented = false // Adicionado para controlar a apresentação da DayPickerView
    @ObservedObject var model: ScreenTimeSelectAppsModel

    var body: some View {
        List {
            Button("Selecione os aplicativos para monitorar") {
                pickerIsPresented = true
            }
            .familyActivityPicker(
                isPresented: $pickerIsPresented,
                selection: $model.activitySelection
            )
            .onDisappear() {
                print("apps selecionados: \(model.activitySelection.applicationTokens)")
            }

            Section(header: Text("Tempo Permitido")) {
                Button("Definir tempo permitido nos aplicativos selecionados") {
                    isTimeLimitSheetPresented = true
                }
                .sheet(isPresented: $isTimeLimitSheetPresented) {
                    TimeLimitView(timeLimit: $timeLimit)
                }
            }

            Section(header: Text("Dias e Horários de Monitoramento")) {
                Button("Definir os dias e horários de monitoramento") {
                    isDayPickerSheetPresented = true // Apenas atualiza a variável de estado para apresentar a sheet
                }
                .sheet(isPresented: $isDayPickerSheetPresented) { // Adiciona a sheet para apresentar a DayPickerView
                    DayPickerView(activeDays: $activeDays)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
        .navigationBarTitle("Configurações")
    }
}

struct TimeLimitView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var timeLimit: TimeInterval // O tempo limite agora é um Binding<TimeInterval>
    private var timeLimitDate: Date {
        // Converte o TimeInterval (segundos) em Date, começando da meia-noite do dia atual
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date()).addingTimeInterval(timeLimit)
    }
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker(
                    "Tempo Permitido",
                    selection: Binding(get: {
                        self.timeLimitDate
                    }, set: { newValue in
                        // Aqui usamos Calendar.current diretamente
                        self.timeLimit = newValue.timeIntervalSince(Calendar.current.startOfDay(for: Date()))
                    }),
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            }
            .navigationTitle("Definir Tempo Permitido")
            .navigationBarItems(trailing: Button("Salvar") {
                saveTimeLimitToUserDefaults()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveTimeLimitToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(timeLimit, forKey: "timeLimit")
    }
    
    static func loadTimeLimitFromUserDefaults() -> TimeInterval {
        let defaults = UserDefaults.standard
        if let savedTime = defaults.object(forKey: "timeLimit") as? TimeInterval {
            return savedTime
        }
        // Valor padrão se nada estiver salvo, por exemplo, 1 hora (3600 segundos)
        return 3600
    }
}

struct DayPickerView: View {
    @Binding var activeDays: [Bool]
    @Environment(\.presentationMode) var presentationMode
    let daysOfTheWeek = ["Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"]

    var body: some View {
        NavigationView {
            List {
                ForEach(daysOfTheWeek.indices, id: \.self) { index in
                    Toggle(isOn: $activeDays[index]) {
                        Text(daysOfTheWeek[index])
                    }
                }
            }
            .navigationTitle("Dias de Monitoramento")
            .navigationBarItems(trailing: Button("Salvar") {
                saveToUserDefaults()
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            loadFromUserDefaults() // Certifique-se de chamar a função de carregamento quando a view aparecer
        }
    }

    private func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(activeDays, forKey: "activeDays")
    }
    
    private func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let savedDays = defaults.array(forKey: "activeDays") as? [Bool] {
            self.activeDays = savedDays
        }
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

