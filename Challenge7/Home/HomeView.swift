//
//  HomeView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI

struct HomeView: View {
    @State private var sheetOffset: CGFloat = 300
    @State private var dragOffset: CGFloat = 100
    private let expandedOffset: CGFloat = 50
    private let collapsedOffset: CGFloat = 400
    
    @State private var sharedViewModel = CounterViewModel()
    
    private var isExpanded: Bool {
        sheetOffset <= expandedOffset + 50
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            if !isExpanded {
                StarShowerView()
            } 
           
            
            VStack {
                if !isExpanded {
                    CounterView(viewModel: sharedViewModel)
                        .padding(.top, 60)
                } else {
                    PlainCounterView(viewModel: sharedViewModel)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            BottomSheetView(
                isExpanded: isExpanded,
                viewModel: sharedViewModel
            )
            .offset(y: sheetOffset + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in dragOffset = value.translation.height }
                    .onEnded { value in
                        if value.translation.height < -100 {
                            sheetOffset = expandedOffset
                        } else if value.translation.height > 100 {
                            sheetOffset = collapsedOffset
                        }
                        dragOffset = 0
                    }
            )
            .animation(.easeInOut, value: sheetOffset)
        }
    }
}



#Preview {
    HomeView()
}
