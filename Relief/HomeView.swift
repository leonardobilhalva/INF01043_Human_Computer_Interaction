import SwiftUI
import UserNotifications
import FamilyControls


struct HomeView: View {
    @State private var navigateToSettings = false
    @State private var navigateToStatistics = false
    @State private var navigateToForum = false
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var monitorManager = MonitorManager()
    var viewController: ViewController?
//    private var monitor: MyMonitorExtension?

        
    
    @State private var isMonitoringActive = false

    var body: some View {
//        NavigationView {
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
                
//                Button("leo")
//                {        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    
//                    notificationManager.scheduleTestNotification()
//                }
//                }

//                NavigationLink(destination: SettingsView().environmentObject(monitorManager).environmentObject(notificationManager)) {
//                                    Text("Configurações")
//                                }
//                                .buttonStyle(MyButtonStyle())
//
                NavigationLink(destination: ViewControllerWrapper().environmentObject(monitorManager).environmentObject(notificationManager)) {
                                    Text("Configurações")
                                }
                                .buttonStyle(MyButtonStyle())

                NavigationLink(destination: StatisticsView().environmentObject(notificationManager)) {
                                    Text("Estatísticas")
                                }
                                .buttonStyle(MyButtonStyle())

                NavigationLink(destination: ForumView().environmentObject(notificationManager)) {
                                    Text("Fórum")
                                }
                                .buttonStyle(MyButtonStyle())
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
            .edgesIgnoringSafeArea(.all)
        
        VStack{}
        .onAppear {
            self.notificationManager.requestAuthorization()
            
            let ac = AuthorizationCenter.shared

            Task {
                do {
                    try await ac.requestAuthorization(for: .individual)
                }
                catch {
                }
            }
            
        }
//        }
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
