//
//  TimeSavedView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/13/25.
//

import SwiftUI

struct TimeSavedView: View {
    let presetTimes: [Double] = [1, 3, 5, 8, 10]

    @AppStorage("lastSavedTime") private var lastSavedTime: Double = 0
    @AppStorage("lastSavedTimeDate") private var lastSavedTimeDate: Double = 0
    @Environment(\.dismiss) var dismiss

    @State private var selectedTime: Double?
    @State private var customTime: String = ""
    @State private var showStats = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Select your average weekly gambling time")) {
                    ForEach(presetTimes, id: \.self) { time in
                        Button {
                            selectedTime = time
                            customTime = ""
                        } label: {
                            HStack {
                                Text("\(String(format: "%.0f", time)) hours")
                                Spacer()
                                if selectedTime == time {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Or enter a custom time (in hours)")) {
                    TextField("Custom hours", text: $customTime)
                        .keyboardType(.decimalPad)
                        .onChange(of: customTime) { _ in
                            selectedTime = nil
                        }
                }

                Section {
                    Button("Confirm") {
                        let finalTime = calculateInputTime()
                        saveWeeklyTime(finalTime)
                        showStats = true
                        dismiss()
                    }
                    .disabled(calculateInputTime() <= 0)
                }
            }
            .navigationTitle("Time Saved")
        
        }
    }

    private func calculateInputTime() -> Double {
        if let selected = selectedTime {
            return selected
        } else if let custom = Double(customTime) {
            return custom
        }
        return 0
    }

    private func saveWeeklyTime(_ time: Double) {
        lastSavedTime = time
        lastSavedTimeDate = Date().timeIntervalSince1970
    }
}

#Preview {
    TimeSavedView()
}
