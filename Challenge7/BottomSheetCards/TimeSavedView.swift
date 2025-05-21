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
    @State private var showAlert = false
    @FocusState private var customTimeIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.snow
                Form {
                    Section(header: Text("Select your average weekly gambling time")) {
                        ForEach(presetTimes, id: \.self) { time in
                            Button {
                                selectedTime = time
                                customTime = ""
                            } label: {
                                HStack {
                                    Text("\(String(format: "%.0f", time)) hours")
                                        .foregroundColor(selectedTime == time ? .snow : .snow)
                                    Spacer()
                                    if selectedTime == time {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Or enter a custom time (in hours)")) {
                        TextField("Custom hours", text: $customTime)
                            .keyboardType(.decimalPad)
                            .focused($customTimeIsFocused)
                            .onChange(of: customTime) { _ in
                                selectedTime = nil
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        customTimeIsFocused = false
                                    }
                                }
                            }
                    }
                }
                
                Button {
                    let finalTime = calculateInputTime()
                    if finalTime <= 0 {
                        showAlert = true
                    } else {
                        saveWeeklyTime(finalTime)
                        showStats = true
                        dismiss()
                    }
                } label: {
                    Text("CONFIRM")
                        .fontWeight(.bold)
                        .foregroundColor(.text)
                        .frame(maxWidth: 300)
                }
                .padding()
                .background(Color.snow)
                .cornerRadius(20)
                .shadow(radius: 5)
                .offset(y: 300)
                .alert("Please select or enter a valid time", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
                .navigationTitle("Time Saved")
            }
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
