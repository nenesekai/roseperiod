//
//  ContentView.swift
//  roseperiod
//
//  Created by Kusanagi Nene on 1/25/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var showEditInfo = false
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomePage(showEditInfo: $showEditInfo)
            }
            Tab("Consult", systemImage: "headset") {
                ConsultPage()
            }
        }
        .popover(isPresented: $showEditInfo) {
            EditInfoPage()
        }
    }
}

#Preview {
    ContentView(showEditInfo: false)
        .modelContainer(for: Period.self, inMemory: true)
}
