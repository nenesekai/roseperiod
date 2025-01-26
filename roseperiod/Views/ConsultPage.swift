//
//  ConsultPage.swift
//  roseperiod
//
//  Created by Kusanagi Nene on 1/25/25.
//

import SwiftUI
import SwiftData

struct ConsultPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Period.startDate) private var periods: [Period]
    @State var userInput = ""
    @State var waitingForResponse = false
    @State var errorOccurred = false
    @State var consultOutput = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 18.0) {
            VStack(alignment: .leading) {
                Label("Consult", systemImage: "headset")
                if waitingForResponse {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke()
                                .foregroundStyle(.secondary)
                        }
                } else {
                    Text(
                        errorOccurred ? "An Error Has Occurred"
                        : waitingForResponse ? "Waiting for Response"
                        : consultOutput == "" ? "Waiting for User Input"
                        : consultOutput
                    )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke()
                                .foregroundStyle(.secondary)
                        }
                }
            }
            Divider()
            VStack(alignment: .leading) {
                Label("User", systemImage: "person.circle")
                TextField("User Input", text: $userInput, prompt: Text("User Input"))
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke()
                            .foregroundStyle(.secondary)
                    }
            }
            Button("Consult") {
                errorOccurred = false
                Task {
                    waitingForResponse = true
                    do {
                        let age = UserDefaults.standard.integer(forKey: "age")
                        let height = UserDefaults.standard.integer(forKey: "height")
                        let weight = UserDefaults.standard.integer(forKey: "weight")
                        let yom = UserDefaults.standard.integer(forKey: "yom")
                        let intercourse = UserDefaults.standard.integer(forKey: "intercourse")
                        var avgIntensity = -1
                        var avgPeriodLength = -1
                        if periods.count >= 2 {
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
                        }
                        let (data, _) = try await URLSession.shared.data(from: URL(string: "http://10.13.203.153:8000/chatbot?Age=\(age)&Height=\(height)&Weight=\(weight)&MeanBleedingIntensity=\(avgIntensity)&NumberOfDaysOfIntercourse=\(intercourse)&YearOfMarried=\(yom)&MeanCycleLength=\(avgPeriodLength)&query=\(userInput)")!)
                        let res = try JSONDecoder().decode(ChatbotResponse.self, from: data)
                        if let msg = res.message {
                            consultOutput = msg
                        } else {
                            errorOccurred = true
                        }
                    } catch {
                        errorOccurred = true
                    }
                    waitingForResponse = false
                }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 14.0)
                    .foregroundStyle(.teal)
            }
            .padding(.top, 18.0)
        }
        .padding()
    }
}

#Preview {
    ConsultPage()
}
