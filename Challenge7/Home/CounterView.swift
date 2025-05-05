//
//  CounterView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import UIKit


struct CounterView: View {
    
    
    @State private var launchDate = Date()
    @State private var elapsed = 0
    @State private var showShareSheet = false
    @State private var shareContent: String? = nil
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Current Streak")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    Text("Started on \(dateFormatter.string(from: launchDate))")
                        .font(.system(size: 8, weight: .light, design: .monospaced))
                }
                
                Spacer()
                
                Button(action: {
                    shareStreak()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            HStack(spacing: 18) {
                VStack {
                    timeBlock(value: days(from: elapsed))
                    Text("Days")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                VStack {
                    timeBlock(value: hours(from: elapsed))
                    Text("Hours")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                VStack {
                    timeBlock(value: minutes(from: elapsed))
                    Text("Minutes")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                VStack {
                    timeBlock(value: seconds(from: elapsed))
                    Text("Seconds")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            
        }
        
        
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
        .shadow(radius: 3)
        
        Button(action: {
            launchDate = Date()
            elapsed = 0
        }) {
            Text("Reset Counter")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.yellow)
                .cornerRadius(12)
            
        }
        .shadow(radius: 3)
        .padding(.bottom, 20)
    
    
        .padding()
        .onReceive(timer) { _ in
            elapsed = Int(Date().timeIntervalSince(launchDate))
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let shareContent = shareContent {
                ShareSheet(activityItems: [shareContent])
            }
        })
    }

    
    func days(from seconds: Int) -> Int {
        seconds / 86400
    }
    
    func hours(from seconds: Int) -> Int {
        (seconds % 86400) / 3600
    }
    
    func minutes(from seconds: Int) -> Int {
        (seconds % 3600) / 60
    }
    
    func seconds(from seconds: Int) -> Int {
        seconds % 60
    }
    
    func timeBlock(value: Int) -> some View {
        Text(String(format: "%02d", value))
            .font(.system(size: 30, weight: .bold, design: .monospaced))
            .frame(minWidth: 60)
    }
    
    func shareStreak() {
        let streakInfo = """
    Current Streak:
    Started on \(dateFormatter.string(from: launchDate))
    Days: \(days(from: elapsed))
    Hours: \(hours(from: elapsed))
    Minutes: \(minutes(from: elapsed))
    Seconds: \(seconds(from: elapsed))
    """
        shareContent = streakInfo
        showShareSheet.toggle()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
let activityItems: [Any]

func makeUIViewController(context: Context) -> UIActivityViewController {
    return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
}

func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}





#Preview {
    CounterView()
}
