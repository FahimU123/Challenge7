//
//  StatCardView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import SwiftGlass

struct StatCardView: View {
    @AppStorage("lastSavedAmount") private var savedAmount: Double = 0
    @AppStorage("lastSavedDate") private var savedAmountDate: Double = 0
    @AppStorage("lastSavedTime") private var savedTime: Double = 0
    @AppStorage("lastSavedTimeDate") private var savedTimeDate: Double = 0
    
    private var now: Date { Date() }
    
    var body: some View {
        let moneyWeeks = weeksSince(savedAmountDate)
        let timeWeeks = weeksSince(savedTimeDate)
        
        let moneyTotal = savedAmount * Double(moneyWeeks)
        let timeTotal = savedTime * Double(timeWeeks)
        
        let moneyStatText = moneyWeeks > 0 ? "$\(Int(moneyTotal))" : "--"
        let timeStatText = timeWeeks > 0 ? "\(Int(timeTotal)) Hours" : "--"
        
        let moneySaved = StatCardModel(
            image: "banknote",
            title: "MONEY SAVED",
            stat: moneyStatText,
            viewProvider: { AnyView(MoneySavedView()) }
        )
        
        let timeSaved = StatCardModel(
            image: "clock",
            title: "TIME SAVED",
            stat: timeStatText,
            viewProvider: { AnyView(TimeSavedView()) }
        )
        
        HStack(spacing: 60) {
            StatCard(stat: moneySaved)
            StatCard(stat: timeSaved)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Statistics cards")
    }
    
    func weeksSince(_ timestamp: Double) -> Int {
        guard timestamp > 0 else { return 0 }
        let from = Date(timeIntervalSince1970: timestamp)
        let components = Calendar.current.dateComponents([.day], from: from, to: now)
        let days = components.day ?? 0
        return max(0, days / 7)
    }
}


struct StatCard: View {
    let stat: StatCardModel
    @State private var isPresented = false
    
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: stat.image)
                        .fontWeight(.bold)
                        .foregroundColor(Color.text)
                        .padding(.horizontal, 5)
                        .accessibilityHidden(true)
                    
                    Spacer()
                    
                    Text(stat.stat)
                        .font(.system(size: 15, weight: .bold))
                        .padding(.horizontal, 5)
                        .foregroundColor(Color.text)
                        .accessibilityLabel("Current value is \(stat.stat)")
                }
                .padding(.bottom, 30)
                
                HStack {
                    Text(stat.title)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color.text)
                        .padding(.leading, 5)
                        .accessibilityAddTraits(.isHeader)
                    
                    Spacer()
                    
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color.text)
                        .padding(.trailing, 5)
                        .accessibilityHidden(true)
                }
            }
            .padding()
            .padding(.horizontal, -10)
            .frame(width: 140, height: 110)
            .background(Color.col)
            .glass(
                shadowOpacity: 0.1,
                shadowRadius: 20
            )
        }
        .fullScreenCover(isPresented: $isPresented) {
            stat.viewProvider()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(stat.title) card. \(stat.stat)")
        .accessibilityHint("Double tap to adjust \(stat.title.lowercased()) settings.")
        .accessibilityAddTraits(.isButton)
    }
}
