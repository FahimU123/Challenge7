//
//  RandomNoteView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//

import SwiftUI

struct RandomNoteView: View {
    var note: Note?

    var body: some View {
       
        VStack(alignment: .leading) {

            Spacer()

            HStack {
                Button {
                   
                } label: {
                    Image(systemName: "plus")
                        .padding(8)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Spacer()

                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold))
            }
        }
        .padding()
        .frame(width: 140, height: 110)
        .background(Color(.systemGray5))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}


#Preview {
    RandomNoteView()
}
