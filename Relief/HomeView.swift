import SwiftUI
import UserNotifications
import FamilyControls


struct HomeView: View {
    @State private var navigateToSettings = false
    @State private var navigateToStatistics = false
    @State private var navigateToForum = false
    @StateObject private var timerManager = NotificationManager()
    @StateObject private var monitorManager = MonitorManager()
    var viewController: ViewController?

    
    
    @State private var isMonitoringActive = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 30)
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 250)
                
                Button(action: {
                    monitorManager.toggleMonitoring()
                }) {
                    Text(monitorManager.isMonitoringActive ? "Parar App" : "Iniciar App")
                        .frame(width: 140, height: 140)
                        .background(monitorManager.isMonitoringActive ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(color: .gray, radius: 10, x: 0, y: 0)
                        .padding()
                }

                NavigationLink(destination: SettingsView().environmentObject(timerManager)) {
                                    Text("Configurações")
                                }
                                .buttonStyle(MyButtonStyle())

                NavigationLink(destination: ViewControllerWrapper().environmentObject(monitorManager)) {
                                    Text("Teste")
                                }
                                .buttonStyle(MyButtonStyle())

                NavigationLink(destination: StatisticsView().environmentObject(timerManager)) {
                                    Text("Estatísticas")
                                }
                                .buttonStyle(MyButtonStyle())

                NavigationLink(destination: ForumView().environmentObject(timerManager)) {
                                    Text("Fórum")
                                }
                                .buttonStyle(MyButtonStyle())
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            self.timerManager.requestAuthorization()
            
            let ac = AuthorizationCenter.shared

            Task {
                do {
                    try await ac.requestAuthorization(for: .individual)
                }
                catch {
                    // Some error occurred
                }
            }
            
        }
    }
}

struct ViewControllerWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var monitorManager: MonitorManager

    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        monitorManager.viewController = viewController
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}


struct SettingsView: View {
    @EnvironmentObject var timerManager: NotificationManager

    var body: some View {
        Text("Settings View")
            .navigationBarBackButtonHidden(true)
    }
}

struct StatisticsView: View {
    @EnvironmentObject var timerManager: NotificationManager

    var body: some View {
        Text("Statistics View")
            .navigationBarBackButtonHidden(true)
    }
}

struct ForumView: View {
    @EnvironmentObject var timerManager: NotificationManager

    var body: some View {
        Text("Forum View")
            .navigationBarBackButtonHidden(true)
    }
}
