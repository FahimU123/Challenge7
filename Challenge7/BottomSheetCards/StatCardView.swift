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

    private var aWeekInSeconds: Double { 60 * 60 * 24 * 7 }
    private var now: Double { Date().timeIntervalSince1970 }

    var body: some View {
        let moneyStatText: String = {
            let elapsed = now - savedAmountDate
            return elapsed >= aWeekInSeconds ? "$\(Int(savedAmount))" : "--"
        }()

        let timeStatText: String = {
            let elapsed = now - savedTimeDate
            return elapsed >= aWeekInSeconds ? "\(Int(savedTime)) Hours" : "--"
        }()

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
                        .foregroundColor(Color.text)
                        .padding(.horizontal, 5)

                    Spacer()

                    Text(stat.stat)
                        .font(.system(size: 15, weight: .bold))
                        .padding(.horizontal, 5)
                        .foregroundColor(Color.text)
                }
                .padding(.bottom, 30)

                HStack {
                    Text(stat.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.text)
                        .padding(.leading, 5)

                    Spacer()

                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color.text)
                        .padding(.trailing, 5)
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
    }
}

#Preview {
    StatCardView()
}
