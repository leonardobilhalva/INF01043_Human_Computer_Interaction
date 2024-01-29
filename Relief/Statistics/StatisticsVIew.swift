import SwiftUI

struct StatisticsView: View {
    let appUsages: [AppUsage] = [
        AppUsage(name: "TikTok", duration: 5.5 * 3600, category: "Social"),
        AppUsage(name: "Instagram", duration: 2 * 3600, category: "Social"),
        AppUsage(name: "Notes", duration: 1.5 * 3600, category: "Productivity"),
        AppUsage(name: "Pages", duration: 1 * 3600, category: "Productivity")
    ]

    @State private var dailyMood: String = ""
    @State private var showingCalendar = false
    @State private var moodEntries: [MoodEntry] = []
    @AppStorage("moodEntries") var moodEntriesData: Data = Data()
    
    var body: some View {
            ScrollView {
                Spacer()
                VStack(spacing: 20) {
                    VStack {
                        Text("Tempo de Uso")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    RingView(progress: totalDuration / (24 * 3600), thickness: 20)
                        .frame(width: 200, height: 200)
                    
                    Text("\(totalDuration.stringFromTimeInterval()) de 24h")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer()
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(appUsages) { usage in
                                UsageRowView(usage: usage)
                            }
                        }
                    }
                    .frame(maxHeight: 200) 
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .shadow(radius: 3)

                    VStack {
                        Text("Humor do Dia")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                        TextField("Como você está se sentindo?", text: $dailyMood)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        HStack {
                            Button(action: {
                                saveMood()
                            }) {
                                Text("Salvar Humor")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }

                            Spacer()

                            Button(action: {
                                showingCalendar = true
                            }) {
                                Text("Ver Calendário de Humores")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                            .sheet(isPresented: $showingCalendar, onDismiss: loadMoods) {
                                MoodCalendarView(moodEntries: $moodEntries, onSave: saveMoods)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .shadow(radius: 3)
                }   
                .padding(.top)
            }
            .onAppear(perform: loadMoods)
            .background(Color(red: 213/255.0, green: 245/255.0, blue: 245/255.0))
            .edgesIgnoringSafeArea(.all)
        }
       

    var totalDuration: TimeInterval {
        appUsages.reduce(0) { $0 + $1.duration }
    }

    
    func saveMood() {
           let newEntry = MoodEntry(date: Calendar.current.startOfDay(for: Date()), mood: dailyMood)
           moodEntries.append(newEntry)
           dailyMood = ""
           saveMoods()
       }

       func saveMoods() {
           if let encoded = try? JSONEncoder().encode(moodEntries) {
               moodEntriesData = encoded
           }
       }

       func loadMoods() {
           if let decoded = try? JSONDecoder().decode([MoodEntry].self, from: moodEntriesData) {
               moodEntries = decoded
           }
       }

    func deleteMood(at offsets: IndexSet) {
        moodEntries.remove(atOffsets: offsets)
        saveMoods()
    }
}

struct MoodEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let mood: String

    init(date: Date, mood: String) {
        self.id = UUID()
        self.date = date
        self.mood = mood
    }
}


    struct UsageRowView: View {
        let usage: AppUsage

        var body: some View {
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                VStack(alignment: .leading) {
                    Text(usage.name)
                        .font(.headline)
                    Text(usage.category)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(usage.duration.stringFromTimeInterval())
                    .font(.subheadline)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding(.horizontal)
        }
    }

    extension TimeInterval {
        func stringFromTimeInterval() -> String {
            let hours = Int(self) / 3600
            let minutes = Int(self) % 3600 / 60
            return String(format: "%dh %02dm", hours, minutes)
        }
    }

   

struct MoodCalendarView: View {
    @Binding var moodEntries: [MoodEntry]
    let onSave: () -> Void

    var body: some View {
        List {
            ForEach(moodEntries) { entry in
                Text("\(entry.date.formatted(date: .abbreviated, time: .omitted)): \(entry.mood)")
            }
            .onDelete(perform: delete)
        }
    }

    private func delete(at offsets: IndexSet) {
        moodEntries.remove(atOffsets: offsets)
        onSave()
    }
}


    struct AppUsage: Identifiable {
        let id = UUID()
        let name: String
        let duration: TimeInterval
        let category: String
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
