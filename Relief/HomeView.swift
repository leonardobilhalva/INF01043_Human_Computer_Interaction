import SwiftUI
import UserNotifications
import FamilyControls


struct HomeView: View {
    @State private var navigateToSettings = false
    @State private var navigateToStatistics = false
    @State private var navigateToForum = false
    @StateObject private var timerManager = NotificationManager()

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
//                        self.timerManager.stopTimer()
                    } else {
//                        self.timerManager.startTimer()
                    }
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
                .background(NavigationLink(destination: SettingsView().environmentObject(timerManager), isActive: $navigateToSettings) { EmptyView() })

                Button("Teste") {
                                  self.navigateToSettings = true
                              }
                              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                              .background(Color.blue)
                              .foregroundColor(.white)
                              .cornerRadius(10)
                              .padding(.horizontal)
                              .background(NavigationLink(destination: ViewControllerWrapper(), isActive: $navigateToSettings) { EmptyView() })
                
                Button("Estatísticas") {
                    self.navigateToStatistics = true
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .background(NavigationLink(destination: StatisticsView().environmentObject(timerManager), isActive: $navigateToStatistics) { EmptyView() })
                
                Button("Fórum") {
                    self.navigateToForum = true
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .background(NavigationLink(destination: ForumView().environmentObject(timerManager), isActive: $navigateToForum) { EmptyView() })
                
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
    func makeUIViewController(context: Context) -> ViewController {
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
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
