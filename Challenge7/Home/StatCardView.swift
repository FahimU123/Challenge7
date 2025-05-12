//
//  StatCardView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI

struct StatCardView: View {
    let moneySaved = StatCardModel(image: "banknote", title: "Money Saved", stat: "$120")
    let timeSaved = StatCardModel(image: "clock", title: "Time Saved", stat: "8 Hours")

    var body: some View {
        HStack(spacing: 60) {
            StatCard(stat: moneySaved)
            StatCard(stat: timeSaved)
        }
    }
}

struct StatCard: View {
    let stat: StatCardModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    // action placeholder
                } label: {
                    Image(systemName: stat.image)
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                }
                .padding(.bottom, 30)

                Spacer()

                Text(stat.stat)
                    .font(.system(size: 15, weight: .bold))
                    .padding(.bottom, 30)
                    .foregroundColor(.primary)
            }

            HStack {
                Text(stat.title)
                    .font(.system(size: 12, weight: .medium))
                Spacer()

                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 24, weight: .medium))
            }
            .foregroundColor(.primary)
        }
        .padding()
        .padding(.horizontal, -10)
        .frame(width: 140, height: 110)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    StatCardView()
}
