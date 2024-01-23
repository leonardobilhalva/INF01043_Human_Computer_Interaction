import UIKit
import SwiftUI
import DeviceActivity
import UserNotifications
import FamilyControls
import Combine

class ScreenTimeSelectAppsModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()
    @Published var isMonitoringActive = false
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
    }
}

class ViewController: UIViewController {
    var notificationManager: NotificationManager
    private let model = ScreenTimeSelectAppsModel()
    private var center = DeviceActivityCenter()
    private var monitor: MyMonitorExtension?
    private var cancellables = Set<AnyCancellable>()
    
    
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
        observeSelection()
    }

    func startMonitoring() {
        if !model.isMonitoringActive {
            print("Preparando para iniciar monitoramento...")
            let activityName = DeviceActivityName("MyAppUsage")
            let event = DeviceActivityEvent(
                applications: model.activitySelection.applicationTokens,
                categories: [],
                webDomains: [],
                threshold: DateComponents(second: 2)
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
                monitor = MyMonitorExtension(notificationManager: notificationManager)
                print("Monitoramento iniciado.")
            } catch {
                print("Error starting monitoring: \(error)")
            }
        }
    }

    func stopMonitoring() {
        if model.isMonitoringActive {
            print("Monitoramento parado.")
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
            print("Seleção atualizada: \(selection.applicationTokens)")
        }
        .store(in: &cancellables)
    }
}

class MyMonitorExtension: DeviceActivityMonitor {
    let notificationManager: NotificationManager

    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
        super.init()
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        notificationManager.sendImmediateNotification(title: "Atenção", body: "Limite de tempo atingido para \(activity)")
    }

    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        notificationManager.sendImmediateNotification(title: "Aviso", body: "Limite de tempo prestes a ser atingido para \(activity)")
    }
}

extension ViewController: MyMonitorDelegate {
    func didUseApp() {
        print("O aplicativo foi utilizado por mais 10 segundos.")
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
