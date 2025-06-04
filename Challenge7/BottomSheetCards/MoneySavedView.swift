//
//  MoneySaved.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/13/25.
//

import SwiftUI

struct MoneySavedView: View {
    let presetAmounts: [Double] = [100, 250, 500, 750, 1000]
    @AppStorage("lastSavedAmount") private var lastSavedAmount: Double = 0
    @AppStorage("lastSavedDate") private var lastSavedDate: Double = 0
    @State private var showAlert = false
    @FocusState private var customAmountIsFocused: Bool

    @State private var selectedAmount: Double?
    @State private var customAmount: String = ""
    @State private var showHome = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.snow
                Form {
                    Section(header: Text("Select your average weekly gambling amount")) {
                        ForEach(presetAmounts, id: \.self) { amount in
                            Button {
                                selectedAmount = amount
                                customAmount = ""
                            } label: {
                                HStack {
                                    Text("$\(String(format: "%.2f", amount))")
                                        .foregroundColor(selectedAmount == amount ? .snow : .snow)
                                    Spacer()
                                    if selectedAmount == amount {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }

                    Section(header: Text("Or enter a custom amount")) {
                        TextField("Custom amount", text: $customAmount)
                            .keyboardType(.decimalPad)
                            .focused($customAmountIsFocused)
                            // Fix: Use the new onChange syntax with two parameters
                            .onChange(of: customAmount) { oldValue, newValue in
                                selectedAmount = nil
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        customAmountIsFocused = false
                                    }
                                }
                            }
                    }
                }

                Button {
                    let finalAmount = calculateInputAmount()
                    if finalAmount <= 0 {
                        showAlert = true
                    } else {
                        saveWeeklyAmount(finalAmount)
                        showHome = true // Consider what `showHome` does here. If it's for navigation, you might need a `NavigationLink` or `.sheet` modifier.
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
                .alert("Please select or enter a valid amount", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
                .navigationTitle("Money Saved")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }

    private func calculateInputAmount() -> Double {
        if let selected = selectedAmount {
            return selected
        } else if let custom = Double(customAmount) {
            return custom
        }
        return 0
    }

    private func saveWeeklyAmount(_ amount: Double) {
        lastSavedAmount = amount
        lastSavedDate = Date().timeIntervalSince1970
    }
}

#Preview {
    MoneySavedView()
}
