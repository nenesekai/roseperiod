//
//  HomePage.swift
//  roseperiod
//
//  Created by Kusanagi Nene on 1/25/25.
//

import SwiftUI
import HorizonCalendar
import SwiftData

struct DayRangeIndicatorViewRepresentable: UIViewRepresentable {

  let framesOfDaysToHighlight: [CGRect]

  func makeUIView(context: Context) -> DayRangeIndicatorView {
      DayRangeIndicatorView(indicatorColor: UIColor.systemTeal)
  }

  func updateUIView(_ uiView: DayRangeIndicatorView, context: Context) {
    uiView.framesOfDaysToHighlight = framesOfDaysToHighlight
  }

}

struct HomePage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Period.startDate) private var periods: [Period]
    @State var showNotImplementedAlert = false
    @State var showNewPeriod = false
    @State var hasPrediction = false
    @State var predictionFailed = false
    @State var predictionInProgress = false
    @State var lengthOfCycle: Int? = nil
    @State var lengthOfMenses: Int? = nil
    @State var calendarViewProxy = CalendarViewProxy()
    @AppStorage("name") var username = ""
    @Binding var showEditInfo: Bool
    var dayRanges: Set<ClosedRange<Date>> {
        Set(periods.map { period in
            period.startDate...period.endDate
        })
    }
    var prediction: String {
        if predictionInProgress {
            return "Prediction In Progress"
        }
        if predictionFailed {
            return "Prediction Failed"
        }
        if periods.count < 2 {
            return "Not Enough Data for Prediction"
        }
        return ""
    }
    
    func predict() {
        hasPrediction = false
        guard periods.count >= 2 else { return }
        Task {
            predictionFailed = false
            predictionInProgress = true
            do {
                let age = UserDefaults.standard.integer(forKey: "age")
                let height = UserDefaults.standard.integer(forKey: "height")
                let weight = UserDefaults.standard.integer(forKey: "weight")
                let yom = UserDefaults.standard.integer(forKey: "yom")
                let intercourse = UserDefaults.standard.integer(forKey: "intercourse")
                var menseLengthTotal = 0
                var periodLengthTotal = 0
                var intensityTotal = 0
                for period in periods {
                    intensityTotal += period.intensity
                    menseLengthTotal += Calendar.current.dateComponents([.day], from: period.startDate, to: period.endDate).day!
                }
                for i in 0..<periods.count-1 {
                    periodLengthTotal += Calendar.current.dateComponents([.day], from: periods[i].startDate, to: periods[i+1].startDate).day!
                }
                let avgIntensity = intensityTotal / periods.count
//                let avgMenseLength = menseLengthTotal / periods.count
                let avgPeriodLength = periodLengthTotal / (periods.count-1)
                let url = URL(string: "http://10.13.203.153:8000/predict_period?Age=\(age)&Height=\(height)&Weight=\(weight)&MeanBleedingIntensity=\(avgIntensity)&NumberOfDaysOfIntercourse=\(intercourse)&YearOfMarried=\(yom)&MeanCycleLength=\(avgPeriodLength)")!
                print(url.absoluteString)
                let (data, _) = try await URLSession.shared.data(from: url) // todo
                let res = try JSONDecoder().decode(PredictionResponse.self, from: data)
                if res.success == 1 {
                    lengthOfCycle = res.length_of_cycle
                    lengthOfMenses = res.length_of_menses
                } else {
                    predictionFailed = true
                }
                hasPrediction = true
            } catch {
                predictionFailed = true
            }
            predictionInProgress = false
        }
    }
    
    var body: some View {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2026, month: 12, day: 31))!
        return ScrollView {
            VStack {
                HStack(spacing: 16.0) {
                    Text("Hello \(username)")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        showEditInfo = true
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.title)
                    }
                    Button {
                        showNewPeriod = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 28)
                Divider()
                CalendarViewRepresentable(calendar: calendar, visibleDateRange: startDate...endDate, monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions()), dataDependency: nil, proxy: calendarViewProxy)
                    .dayRanges(for: dayRanges) { dayRangeLayoutContext in
                        DayRangeIndicatorViewRepresentable(
                          framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame })
                      }
                    .dayBackgrounds({ day in
                        let today = calendar.dateComponents([.year, .month, .day], from: Date())
                        if day.day == today.day && day.month.month == today.month && day.month.year == today.year {
                            Circle()
                                .foregroundStyle(.red)
                        }
                    })
                    .padding()
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Estimated Next Period")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        if hasPrediction {
                            HStack(alignment: .center, spacing: 20.0) {
                                Spacer()
                                VStack {
                                    Text("\(lengthOfCycle ?? 0)")
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                    Text("DAYS CYCLE")
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .foregroundStyle(.secondary)
                                }
                                Divider()
                                VStack {
                                    Text("\(lengthOfMenses ?? 0)")
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                    Text("DAYS MENSES")
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                        } else {
                            Text(prediction)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .padding(.horizontal, 28.0)
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke()
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                Spacer()
            }
            .alert("Not Yet Implemented", isPresented: $showNotImplementedAlert) {
                Button("那无敌了") {
                    showNotImplementedAlert = false
                }
            }
            .popover(isPresented: $showNewPeriod) {
                NewPeriodSelection(show: $showNewPeriod)
            }
        }
        .onAppear {
            calendarViewProxy.scrollToMonth(containing: Date(), scrollPosition: .centered, animated: false)
            predict()
        }
        .onChange(of: periods) {
            predict()
        }
        .refreshable {
            predict()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Period.self, inMemory: true)
}
