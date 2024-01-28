import UIKit
import SwiftUI
import DeviceActivity
import UserNotifications
import FamilyControls
import Combine

class ScreenTimeSelectAppsModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()
    @Published var isMonitoringActive = false
    
    init() { }
}

struct ScreenTimeSelectAppsContentView: View {
    @State private var pickerIsPresented = false
    @ObservedObject var model: ScreenTimeSelectAppsModel

    var body: some View {
        Button {
            pickerIsPresented = true
        } label: {
            Text("Select Apps")
        }
        .familyActivityPicker(
            isPresented: $pickerIsPresented,
            selection: $model.activitySelection
        )
        .onDisappear(){
            print("leonardo:  \($model.activitySelection.applicationTokens)")
        }
    }
}

class ViewController: UIViewController {
    var notificationManager: NotificationManager
    private let model = ScreenTimeSelectAppsModel()
    private var center = DeviceActivityCenter()
//    private var monitor: MyMonitorExtension?
    private var cancellables = Set<AnyCancellable>()
    
    private let userDefaultsKey = "ReliefAppsSelection"
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    
    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        observeSelection()
    }

    func startMonitoring() {
        if !model.isMonitoringActive {
            print("Preparando para iniciar monitoramento...")
            
            let atualDate = Date()
            let calendar = Calendar.current
            
            let schedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 0, minute: 0),
                intervalEnd: DateComponents(hour: 23, minute: 59),
                repeats: true
//                warningTime: DateComponents(second: 5)
            )
            
            let ac = AuthorizationCenter.shared
            Task {
                do {
                    try await ac.requestAuthorization(for: .individual)
                }
                catch {
                    print("Error getting auth for Family Controls")
                }
            }
            
            let selection: FamilyActivitySelection = loadSelection() ?? FamilyActivitySelection()
            print("selectioN: \(selection)")
            
            model.$activitySelection.sink { selection in
                self.saveSelection(selection: selection)
            }
            .store(in: &cancellables)
            
            let event = DeviceActivityEvent(
                applications: selection.applicationTokens,
                categories: selection.categoryTokens,
                webDomains: selection.webDomainTokens,
                threshold: DateComponents(second: 15)
            )
            
            let activity = DeviceActivityName("Relief.ScreenTime")
            let eventName = DeviceActivityEvent.Name("Relief.SomeEventName")
            let center = DeviceActivityCenter()
            center.stopMonitoring()

            do {
                try center.startMonitoring(
                    activity,
                    during: schedule,
                    events: [
                        eventName: event
                    ]
                )
                
                model.isMonitoringActive = true
//                monitor = MyMonitorExtension(notificationManager: notificationManager)
                print("Monitoramento iniciado.")
            } catch {
                print("Error starting monitoring: \(error)")
            }
        }
    }

    func stopMonitoring() {
        if model.isMonitoringActive {
            print("Monitoramento parado.")
            let activityNames = [DeviceActivityName("Relief.ScreenTime")]
            do {
                try center.stopMonitoring(activityNames)
                model.isMonitoringActive = false
            } catch {
                print("Erro ao parar o monitoramento: \(error)")
            }
        }
    }

    func setupUI() {
        let rootView = ScreenTimeSelectAppsContentView(model: model)
        let controller = UIHostingController(rootView: rootView)
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.frame
        controller.didMove(toParent: self)
    }
}

extension ViewController { // visualiza, salva e carrega
    func observeSelection() {
            model.activitySelection = loadSelection() ?? FamilyActivitySelection()

              model.$activitySelection.sink { selection in
                  print("Seleção atualizada: \(selection.applicationTokens)")
                  self.saveSelection(selection: selection)
              }
              .store(in: &cancellables)
        }
    
    func saveSelection(selection: FamilyActivitySelection) {
            let defaults = UserDefaults.standard
            defaults.set(
                try? encoder.encode(selection),
                forKey: userDefaultsKey
            )
        }

    func loadSelection() -> FamilyActivitySelection? {
           let defaults = UserDefaults.standard
           guard let data = defaults.data(forKey: userDefaultsKey) else {
               return nil
           }
            let decoder = PropertyListDecoder()
            return try? decoder.decode(FamilyActivitySelection.self, from: data)
       }
}




//class MyMonitorExtension: DeviceActivityMonitor {
//    let notificationManager: NotificationManager
//
//    init(notificationManager: NotificationManager) {
//        self.notificationManager = notificationManager
//        super.init()
//        self.notificationManager.sendImmediateNotification(title: "dasdsadsadsa", body: "dasdsaas")
//    }
//    
//    
//    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventDidReachThreshold(event, activity: activity)
//        print("auiee")
//        print("Aviso: Threshold tingido para atividade: \(activity)")
//        notificationManager.sendImmediateNotification(title: "Atenção", body: "Limite de tempo atingido para \(activity)")
//    }
//
//    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventWillReachThresholdWarning(event, activity: activity)
//        print("auiee")
//        print("Aviso: Threshold prestes a ser atingido para atividade: \(activity)")
//        notificationManager.sendImmediateNotification(title: "Aviso", body: "Limite de tempo prestes a ser atingido para \(activity)")
//    }
//}
// 
//extension ViewController: MyMonitorDelegate {
//    func didUseApp() {
//        print("O aplicativo foi utilizado por mais 10 segundos.")
//    }
//}
//
//protocol MyMonitorDelegate: AnyObject {
//    func didUseApp()
//}

class MonitorManager: ObservableObject {
    @Published var isMonitoringActive = false
    
    var viewController: ViewController?

    func toggleMonitoring() {
        isMonitoringActive.toggle()
        if isMonitoringActive {
            viewController?.startMonitoring()
        } else {
            viewController?.stopMonitoring()
        }
    }
}


