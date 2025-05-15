//
//  BottomSheetView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//

import SwiftUI
import SwiftGlass

struct BottomSheetView: View {
    var isExpanded: Bool
    var viewModel: CounterViewModel
    var note: Note?
    @State private var showFullNoteView = false
    @State private var showFullRecoveryRatioView = false
    @EnvironmentObject var checkInManager: CheckInDataManager

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
                    
                }
                .padding(.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glass()
        .opacity(0.8)
        .cornerRadius(isExpanded ? 5 : 16)
    }
}
