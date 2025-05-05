//
//  HomeView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(.systemGray5)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
               
                Text("No Gamble")
                    .font(.system(size: 38, weight: .semibold, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)

                CounterView()
                    .frame(maxWidth: .infinity)
                    .padding()

                Button(action: {

                }) {
                    Text("Reset Counter")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.yellow)
                        .cornerRadius(12)
                }
                .shadow(radius: 3)
                .padding()

                StatCardView()
                    .padding()

                VStack(alignment: .center) {
                    Text("How are you feeling right now?")
                        .font(.system(size: 32, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.horizontal, 26)

                    HStack {
                        Button(action: {
                           
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.black)
                        }

                        Text("Check In")
                            .font(.system(size: 32, weight: .medium))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
}


#Preview {
    HomeView()
}
