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
    @State private var showValidationError: Bool = false
    @State private var showAlert = false

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
                ForEach(tagGroups, id: \.title) { group in
                    let tagBinding = Binding<String>(
                        get: { customTags[group.title, default: ""] },
                        set: { customTags[group.title] = $0 }
                    )

                    SurveySectionView(
                        title: group.title,
                        tags: group.tags,
                        selectedTags: $selectedTags,
                        userTags: userTagsPerGroup[group.title] ?? [],
                        customTag: tagBinding,
                        onAddCustomTag: { tag in
                            userTagsPerGroup[group.title, default: []].append(tag)
                            selectedTags.insert(tag)
                            if let encoded = try? JSONEncoder().encode(userTagsPerGroup) {
                                UserDefaults.standard.set(encoded, forKey: userTagsKey)
                            }
                        }
                    )
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
        .alert("Please answer all questions", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
      
    func saveCheckIn() {
        // Combine default + user tags per group
        let allTags = Dictionary(uniqueKeysWithValues: tagGroups.map { group in
            let userTags = userTagsPerGroup[group.title] ?? []
            return (group.title, group.tags + userTags)
        })

        func tags(for title: String) -> [String] {
            selectedTags.filter { allTags[title]?.contains($0) == true }
        }

        guard
            let activityGroup = tagGroups.first(where: { $0.title == "What were you doing?" }),
            let locationGroup = tagGroups.first(where: { $0.title == "Where were you?" }),
            let companionGroup = tagGroups.first(where: { $0.title == "Who were you with?" })
        else {
            print("Missing tag groups")
            return
        }

        let activity = tags(for: activityGroup.title)
        let location = tags(for: locationGroup.title)
        let companions = tags(for: companionGroup.title)

        if activity.isEmpty || location.isEmpty || companions.isEmpty {
            showAlert = true
            return
        }

        let entry = CheckInEntry(
            timestamp: Date(),
            activityTags: activity,
            locationTags: location,
            companionTags: companions
        )

        modelContext.insert(entry)
        dismiss()
    }
}

#Preview {
    SurveyView()
}

struct SurveySectionView: View {
    let title: String
    let tags: [String]
    @Binding var selectedTags: Set<String>
    var userTags: [String]
    @Binding var customTag: String
    var onAddCustomTag: (String) -> Void

    @State private var showInput = false
    @FocusState private var isFocused: Bool

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
            Text(title)
                .font(.headline)
                .foregroundColor(.snow)
                .padding(.top, 8)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(tags + userTags, id: \.self) { tag in
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

            if showInput {
                TextField("...", text: $customTag)
                    .focused($isFocused)
                    .onSubmit {
                        let trimmed = customTag.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        onAddCustomTag(trimmed)
                        customTag = ""
                        showInput = false
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
                        isFocused = true
                    }
            } else {
                Button(action: {
                    showInput = true
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
}
