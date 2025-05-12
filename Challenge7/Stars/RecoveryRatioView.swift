//
//  RecoveryRatioView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//

import SwiftUI

struct RecoveryRatioView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.orange
                .ignoresSafeArea(edges: .all)
            VStack(alignment: .center) {
                Text("test")
                Text("test")
                
            }
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
            }
        }
 
        
    }
    
}

#Preview {
    RecoveryRatioView()
}
