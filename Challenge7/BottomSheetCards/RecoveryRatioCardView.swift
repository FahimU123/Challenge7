//
//  RecoveryRatioView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//

import SwiftUI

struct RecoveryRatioCardView: View {
    var body: some View {
        ZStack {
            Color.orange
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 50) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 50))
                    
                    Image(systemName: "info.circle")
                        .padding(.bottom, 25)
                }
                Text("Recovery Ratio")
            }
           
        }
        .frame(width: 140, height: 110)
        .cornerRadius(10)
    }
}
        
        
                
              
            
#Preview {
    RecoveryRatioCardView()
}
