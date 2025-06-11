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
                    Section(header: Text("Select your average weekly gambling time")
                                .accessibilityAddTraits(.isHeader)) {
                        ForEach(presetTimes, id: \.self) { time in
                            Button {
                                selectedTime = time
                                customTime = ""
                            } label: {
                                HStack {
                                    Text("\(String(format: "%.0f", time)) hours")
                                        .foregroundColor(selectedTime == time ? .accentColor : .primary)
                                    Spacer()
                                    if selectedTime == time {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                            .accessibilityHidden(true)
                                    }
                                }
                            }
                            .accessibilityLabel("Select \(String(format: "%.0f", time)) hours")
                            .accessibilityAddTraits(selectedTime == time ? [.isButton, .isSelected] : .isButton)
                            .accessibilityHint(selectedTime == time ? "Currently selected. Double tap to deselect." : "Double tap to select this amount.")
                        }
                    }

                    Section(header: Text("Or enter a custom time (in hours)")
                                .accessibilityAddTraits(.isHeader)) {
                        TextField("Custom hours", text: $customTime)
                            .keyboardType(.decimalPad)
                            .focused($customTimeIsFocused)
                            .onChange(of: customTime) { oldValue, newValue in
                                selectedTime = nil
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        customTimeIsFocused = false
                                    }
                                    .accessibilityLabel("Done with custom time input")
                                }
                            }
                            .accessibilityLabel("Custom time text field")
                            .accessibilityHint("Enter your average weekly gambling time in hours here.")
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
                .cornerRadius(32)
                .shadow(radius: 5)
                .offset(y: 300)
                .alert("Please select or enter a valid time", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                    .accessibilityLabel("OK")
                }
                .accessibilityLabel("Confirm time button")
                .accessibilityHint("Confirms your selected or custom weekly gambling time.")
                .navigationTitle("Time Saved")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                        }
                        .accessibilityLabel("Dismiss")
                        .accessibilityHint("Closes the time saved screen.")
                    }
                }
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
