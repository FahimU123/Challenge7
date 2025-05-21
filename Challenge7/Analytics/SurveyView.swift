//
//  SurveyView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/13/25.
//

import SwiftUI

struct SurveyView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTags: Set<String> = []
    @State private var customTags: [String: String] = [:]
    @State private var userTagsPerGroup: [String: [String]] = [:]
    @State private var showInputForGroup: String? = nil
    @FocusState private var focusedGroup: String?

    private let userTagsKey = "userTagsPerGroup"

    let tagGroups: [(title: String, tags: [String])] = [
        ("What were you doing?", ["Working", "Exercising", "Scrolling"]),
        ("Where were you?", ["Home", "Work", "Outdoors"]),
        ("Who were you with?", ["Alone", "Friends", "Family"])
    ]

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack(alignment: .topLeading) {
            
        
            VStack(alignment: .leading, spacing: 24) {
                quoteSection
                ForEach(tagGroups, id: \.title) { group in
                    surveySection(title: group.title, tags: group.tags)
                }
                Button(action: saveCheckIn) {
                    Text("Complete Check-In")
                        .font(.headline)
                        .foregroundColor(.text)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(Color.snow)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(.leading, 35)
                }
            }
            .padding()
            .padding(.top, 60)
            .padding(.bottom, 32)
            .onAppear {
                if let data = UserDefaults.standard.data(forKey: userTagsKey),
                   let decoded = try? JSONDecoder().decode([String: [String]].self, from: data) {
                    userTagsPerGroup = decoded
                }
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 24))
                    .foregroundColor(.snow)
                    .padding()
            }
            .padding()

            Text(Date.now.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(.snow)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.snow.opacity(0.1))
                .clipShape(Capsule())
                .padding()
                .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
    }

    var quoteSection: some View {
        Text("Thank you for being honest. Reflecting is the first step toward control. We'll check in again tomorrow.")
            .foregroundColor(.snow)
            .font(.headline)
            .padding(.top, 12)
    }
      
    @ViewBuilder
    func surveySection(title: String, tags: [String]) -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Divider()

            Text(title)
                .font(.headline)
                .foregroundColor(.snow)
                .padding(.top, 8)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedTags.contains(tag) ? Color.snow : Color.text)
                        .foregroundColor(selectedTags.contains(tag) ? Color.text : .snow)
                        .overlay(
                            Capsule()
                                .stroke(Color.snow.opacity(0.6), lineWidth: 1)
                        )
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .clipShape(Capsule())
                        .onTapGesture {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                }

                if let userTags = userTagsPerGroup[title], !userTags.isEmpty {
                    ForEach(userTags, id: \.self) { tag in
                        Text(tag)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(selectedTags.contains(tag) ? Color.snow : Color.text)
                            .foregroundColor(selectedTags.contains(tag) ? Color.text : .snow)
                            .overlay(
                                Capsule()
                                    .stroke(Color.snow.opacity(0.6), lineWidth: 1)
                            )
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .clipShape(Capsule())
                            .onTapGesture {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                    }
                }
            }

            if showInputForGroup == title {
                TextField("Enter custom tag", text: Binding(
                    get: { customTags[title, default: ""] },
                    set: { customTags[title] = $0 }
                ))
                .focused($focusedGroup, equals: title)
                .onSubmit {
                    let trimmed = customTags[title, default: ""].trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    userTagsPerGroup[title, default: []].append(trimmed)
                    selectedTags.insert(trimmed)
                    customTags[title] = ""
                    showInputForGroup = nil

                    if let encoded = try? JSONEncoder().encode(userTagsPerGroup) {
                        UserDefaults.standard.set(encoded, forKey: userTagsKey)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.snow.opacity(0.2))
                .foregroundColor(.snow)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.snow.opacity(0.4), lineWidth: 1)
                )
                .submitLabel(.done)
                .onAppear {
                    focusedGroup = title
                }
            } else {
                Button(action: {
                    showInputForGroup = title
                }) {
                    Label("Add your own...", systemImage: "plus")
                        .font(.subheadline)
                        .foregroundColor(.snow)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.snow.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.bottom, 12)

    }
    func saveCheckIn() {
        // Combine default + user tags per group
        let allTags = Dictionary(uniqueKeysWithValues: tagGroups.map { group in
            let userTags = userTagsPerGroup[group.title] ?? []
            return (group.title, group.tags + userTags)
        })

        let selectedTagsArray = Array(selectedTags)
        let activity = selectedTagsArray.filter { allTags[tagGroups[0].title]?.contains($0) == true }
        let location = selectedTagsArray.filter { allTags[tagGroups[1].title]?.contains($0) == true }
        let companions = selectedTagsArray.filter { allTags[tagGroups[2].title]?.contains($0) == true }

        guard !activity.isEmpty || !location.isEmpty || !companions.isEmpty else {
            dismiss()
            return
        }

        let entry = CheckInEntry(
            timestamp: Date(),
            activityTags: Array(activity),
            locationTags: Array(location),
            companionTags: Array(companions)
        )

        modelContext.insert(entry)
        dismiss()
    }
}

#Preview {
    SurveyView()
}
