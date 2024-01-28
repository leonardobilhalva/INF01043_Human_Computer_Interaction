import SwiftUI

struct AppUsage: Identifiable {
    let id = UUID()
    let name: String
    let duration: TimeInterval
    let category: String
}

struct StatisticsView: View {
    let appUsages: [AppUsage] = [
        AppUsage(name: "Xcode", duration: 5.5 * 3600, category: "Development"),
        AppUsage(name: "Pages", duration: 2 * 3600, category: "Productivity"),
        AppUsage(name: "Numbers", duration: 1.5 * 3600, category: "Productivity"),
        AppUsage(name: "Keynote", duration: 1 * 3600, category: "Productivity")
    ]

    var totalDuration: TimeInterval {
        appUsages.reduce(0) { $0 + $1.duration }
    }

    var body: some View {
        VStack {
            RingView(progress: totalDuration / (24 * 3600), thickness: 20)
                .frame(width: 150, height: 150)
            Text("\(totalDuration.stringFromTimeInterval()) de 24h")
                .font(.title)
            List(appUsages) { appUsage in
                HStack {
                    VStack(alignment: .leading) {
                        Text(appUsage.name)
                        Text(appUsage.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text(appUsage.duration.stringFromTimeInterval())
                }
            }
        }
        .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
        .edgesIgnoringSafeArea(.all)
    }
}

struct RingView: View {
    var progress: Double
    var thickness: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: thickness)
                .opacity(0.3)
                .foregroundColor(Color.blue)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
        }
    }
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) % 3600 / 60
        return String(format: "%dh %02dm", hours, minutes)
    }
}
