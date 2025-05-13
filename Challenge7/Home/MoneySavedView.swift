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
    @State private var selectedAmount: Double?
    @State private var customAmount: String = ""
    @State private var showHome = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Select your average weekly gambling amount")) {
                    ForEach(presetAmounts, id: \.self) { amount in
                        Button {
                            selectedAmount = amount
                            customAmount = ""
                        } label: {
                            HStack {
                                Text("$\(String(format: "%.2f", amount))")
                                Spacer()
                                if selectedAmount == amount {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Or enter a custom amount")) {
                    TextField("Custom amount", text: $customAmount)
                        .keyboardType(.decimalPad)
                        .onChange(of: customAmount) { _ in
                            selectedAmount = nil
                        }
                }

                Section {
                    Button("Confirm") {
                        let finalAmount = calculateInputAmount()
                        saveWeeklyAmount(finalAmount)
                        showHome = true
                        dismiss()
                    }
                    .disabled(calculateInputAmount() <= 0)
                }
            }
            .navigationTitle("Money Saved")
        
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
