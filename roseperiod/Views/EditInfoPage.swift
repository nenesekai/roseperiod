//
//  EditInfoPage.swift
//  roseperiod
//
//  Created by Kusanagi Nene on 1/25/25.
//

import SwiftUI
import SwiftData

struct EditInfoPage: View {
    @Environment(\.modelContext) var modelContext: ModelContext
    @Query var periods: [Period]
    
    @AppStorage("name") var name = ""
    @AppStorage("age") var age = 18
    @AppStorage("height") var height = 60
    @AppStorage("weight") var weight = 140
    @AppStorage("yom") var yom = 0
    @AppStorage("intercourse") var intercourse = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Personal Information")
                .font(.title)
                .fontWeight(.bold)
            Divider()
            Text("Name")
                .padding(.leading, 2.0)
                .foregroundStyle(.secondary)
            TextField("Name", text: $name, prompt: Text("Name"))
                .padding(8.0)
                .background {
                    RoundedRectangle(cornerRadius: 10.0).stroke().foregroundStyle(.secondary)
                }
            Text("Age")
                .padding(.leading, 2.0)
                .foregroundStyle(.secondary)
            Stepper("\(age)", value: $age, in: 0...200)
                .padding(8.0)
                .background {
                    RoundedRectangle(cornerRadius: 10.0).stroke().foregroundStyle(.secondary)
                }
            Text("Height")
                .padding(.leading, 2.0)
                .foregroundStyle(.secondary)
            Stepper("\(height)", value: $height, in: 60...80)
                .padding(8.0)
                .background {
                    RoundedRectangle(cornerRadius: 10.0).stroke().foregroundStyle(.secondary)
                }
            Text("Weight")
                .padding(.leading, 2.0)
                .foregroundStyle(.secondary)
            Stepper("\(weight)", value: $weight, in: 0...400)
                .padding(8.0)
                .background {
                    RoundedRectangle(cornerRadius: 10.0).stroke().foregroundStyle(.secondary)
                }
            Text("Years of Married")
                .padding(.leading, 2.0)
                .foregroundStyle(.secondary)
            Stepper("\(yom)", value: $yom, in: 0...100)
                .padding(8.0)
                .background {
                    RoundedRectangle(cornerRadius: 10.0).stroke().foregroundStyle(.secondary)
                }
            Text("Number of Days of Intercourse")
                .padding(.leading, 2.0)
                .foregroundStyle(.secondary)
            Stepper("\(intercourse)", value: $intercourse, in: 0...400)
                .padding(8.0)
                .background {
                    RoundedRectangle(cornerRadius: 10.0).stroke().foregroundStyle(.secondary)
                }
            Spacer()
            Button("Delete All Period Data") {
                name = ""
                age = 18
                height = 60
                weight = 140
                yom = 0
                intercourse = 0
                for period in periods {
                    modelContext.delete(period)
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8.0)
                    .foregroundStyle(.red)
            }

        }
        .padding()
        .padding(.vertical, 28.0)
    }
}
