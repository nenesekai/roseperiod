//
//  NewPeriodSelection.swift
//  roseperiod
//
//  Created by Kusanagi Nene on 1/25/25.
//

import SwiftUI

struct NewPeriodSelection: View {
    @Environment(\.modelContext) private var modelContext
    @State var startDate: Date = Date.now
    @State var endDate: Date = Date.now
    @State var intensity: Int = 5
    @Binding var show: Bool
    @State private var calendarId: Int = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 18.0) {
            Text("Record New Period")
                .font(.title)
                .fontWeight(.bold)
            Divider()
            DatePicker("Start Date", selection: $startDate, in: ...Date(), displayedComponents: [.date])
            DatePicker("End Date", selection: $endDate, in: startDate...Date(), displayedComponents: [.date])
            Stepper("Bleeding Intensity \(intensity)", value: $intensity, in: 1...10)
            Divider()
            Button("Save") {
                let period = Period(startDate: startDate, endDate: endDate, intensity: intensity)
                modelContext.insert(period)
                show = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 8.0)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
    }
}
