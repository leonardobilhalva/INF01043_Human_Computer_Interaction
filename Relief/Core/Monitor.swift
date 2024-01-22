import UIKit
import SwiftUI
import DeviceActivity
import UserNotifications
import FamilyControls
import Combine

// Modelo para gerenciar a seleção de atividades da família
class ScreenTimeSelectAppsModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()
    @Published var isMonitoringActive = false

//    init() { }
}

// View SwiftUI para selecionar aplicativos
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
    }
}

class ViewController: UIViewController {
    private let model = ScreenTimeSelectAppsModel()
    private var center = DeviceActivityCenter() // Instância de DeviceActivityCenter
    private var monitor: MyMonitorExtension?
    private var timer: Timer?
    private var lastRecordedTime: TimeInterval = 0
    private let checkInterval: TimeInterval = 10
    private var cancellables = Set<AnyCancellable>()
    var viewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeSelection()
    }
    
    func startMonitoring() {
        if !model.isMonitoringActive {
            let activityName = DeviceActivityName("MyAppUsage")
            let event = DeviceActivityEvent(
                applications: model.activitySelection.applicationTokens,
                categories: model.activitySelection.categoryTokens,
                webDomains: model.activitySelection.webDomainTokens,
                threshold: DateComponents(second: 10)
            )

            let schedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 0, minute: 0),
                intervalEnd: DateComponents(hour: 23, minute: 59),
                repeats: true
            )

            do {
                try center.startMonitoring(
                    activityName,
                    during: schedule,
                    events: [DeviceActivityEvent.Name("UsageEvent"): event]
                )
                model.isMonitoringActive = true
                monitor = MyMonitorExtension()
            } catch {
                print("Error starting monitoring: \(error)")
            }
        }
    }

    
    func stopMonitoring() {
        if model.isMonitoringActive {
            let activityNames = [DeviceActivityName("MyAppUsage")]
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

    func observeSelection() {
        model.$activitySelection.sink { [weak self] selection in
            self?.startMonitoring(selection: selection)
        }
        .store(in: &cancellables)
    }

    func startMonitoring(selection: FamilyActivitySelection) {
        let center = DeviceActivityCenter()
        let activity = DeviceActivityName("Relief.Activity")

        let event = DeviceActivityEvent(
            applications: selection.applicationTokens,
            categories: selection.categoryTokens,
            webDomains: selection.webDomainTokens,
            threshold: DateComponents(second: 10)
        )

        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        do {
            try center.startMonitoring(
                activity,
                during: schedule,
                events: [DeviceActivityEvent.Name("Relief.Usage"): event]
            )

            monitor = MyMonitorExtension()
        } catch {
            print("Error starting monitoring: \(error)")
        }

        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkUsage), userInfo: nil, repeats: true)
    }

    @objc func checkUsage() {
        // Implementação fictícia
        let currentTime = getAppUsageTime()
        if currentTime - lastRecordedTime >= checkInterval {
            print("O aplicativo foi utilizado por mais 10 segundos.")
            lastRecordedTime = currentTime
        }
    }

    func getAppUsageTime() -> TimeInterval {
        // Implementação fictícia
        return 0 // Valor temporário
    }
}


class MyMonitorExtension: DeviceActivityMonitor {
    // Este método é chamado quando o limite de tempo é atingido
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        // Aqui você pode implementar o que acontece quando o limite de tempo é atingido
    }

    // Este método é chamado quando o limite de tempo está prestes a ser atingido
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        // Aqui você pode implementar um aviso para o usuário
    }
}

extension ViewController: MyMonitorDelegate {
    func didUseApp() {
        print("O aplicativo foi utilizado por mais \(checkInterval) segundos.")
    }
}

protocol MyMonitorDelegate: AnyObject {
    func didUseApp()
}


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
