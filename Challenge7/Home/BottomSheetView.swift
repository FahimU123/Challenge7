//
//  BottomSheetView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//

import SwiftUI
import SwiftGlass
import SwiftData

struct BottomSheetView: View {
    var isExpanded: Bool
    var viewModel: CounterViewModel
    var note: Note?
    @State private var showFullNoteView = false
    @State private var showFullRecoveryRatioView = false
    @EnvironmentObject var checkInManager: CheckInDataManager
    @Query(sort: \CheckInEntry.timestamp, order: .reverse) private var checkIns: [CheckInEntry]

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 40, height: 6)
                .padding(.top, 8)
            
            ScrollView {
                VStack(spacing: 20) {
                    StatCardView()
                        .padding(.vertical)
                    HStack(spacing: 60) {
                        Button {
                            showFullNoteView.toggle()
                        } label: {
                            RandomNoteView()
                        }
                        .fullScreenCover(isPresented: $showFullNoteView, content: NotesWallView.init)
                        
                        Button {
                            showFullRecoveryRatioView.toggle()
                        } label: {
                            RecoveryRatioCardView(showFullRecoveryRatioView: $showFullRecoveryRatioView)
                        }
                        .fullScreenCover(isPresented: $showFullRecoveryRatioView) {
                            RecoveryRatioView(dataManager: checkInManager)
                        }
                    }
                     
                            if let recentEntry = checkIns.first {
                                RiskTriggersView(entry: recentEntry)
                                    .padding(.horizontal)
                            } else {
                                VStack {

                                    Text("Check in for more in depth insights")
                                        .font(.headline)
                                        .foregroundColor(Color.text)
                                        
                                }
                                .padding()
                                .frame(width: 350, height: 100)
                                .background(Color.col)
                                .cornerRadius(32)
                                .glass(shadowOpacity: 0.1, shadowRadius: 20)
                                .padding(.horizontal)
                    
                        }

                    
                    
                }
                .padding(.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glass()
        .opacity(0.8)
        .cornerRadius(isExpanded ? 16 : 32)
    }
}


#Preview {
    BottomSheetView(isExpanded: true, viewModel: CounterViewModel())
        .environmentObject(CheckInDataManager())
}
