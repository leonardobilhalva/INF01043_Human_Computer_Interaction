import SwiftUI
import UserNotifications

struct HomeView: View {
    @State private var navigateToSettings = false
    @State private var navigateToStatistics = false
    @State private var navigateToForum = false
    @State private var programaIniciado = false
    @StateObject private var timerManager = TimerManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 30)
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 250)
                
                Button(action: {
                    if self.timerManager.programaIniciado {
                        self.timerManager.stopTimer()
                    } else {
                        self.timerManager.startTimer()
                    }
                    self.timerManager.programaIniciado.toggle()
                }) {
                    Text(timerManager.programaIniciado ? "Parar App" : "Iniciar App")
                        .frame(width: 140, height: 140)
                        .background(timerManager.programaIniciado ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(color: .gray, radius: 10, x: 0, y: 0)
                        .padding()
                }

                
                Button("Configurações") {
                    self.navigateToSettings = true
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .background(NavigationLink(destination: SettingsView(), isActive: $navigateToSettings) { EmptyView() })
                
                Button("Estatísticas") {
                    self.navigateToStatistics = true
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .background(NavigationLink(destination: StatisticsView(), isActive: $navigateToStatistics) { EmptyView() })
                
                Button("Fórum") {
                    self.navigateToForum = true
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .background(NavigationLink(destination: ForumView(), isActive: $navigateToForum) { EmptyView() })
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        }
    }

}


struct SettingsView: View {
    var body: some View {
        Text("Settings View")        .navigationBarBackButtonHidden(true)

    }
}

struct StatisticsView: View {
    var body: some View {
        Text("Statistics View")        .navigationBarBackButtonHidden(true)

    }
}

struct ForumView: View {
    var body: some View {
        Text("Forum View")        .navigationBarBackButtonHidden(true)

    }
}
