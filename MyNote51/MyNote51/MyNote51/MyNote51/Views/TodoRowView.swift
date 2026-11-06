//
//  TodoRowView.swift
//  MyNote51
//

import SwiftUI

struct TodoRowView: View {
    let item: TodoItem
    let userId: String
    @EnvironmentObject var todoVM: TodoViewModel

    @State private var isEditing = false
    @State private var editedTitle = ""

    var body: some View {
        HStack(spacing: 14) {
            // Complete Toggle Button
            Button {
                Task {
                    await todoVM.toggleComplete(item, userId: userId)
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            // Title / Edit Field
            if isEditing {
                TextField("Todo title", text: $editedTitle)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        Task {
                            await todoVM.updateTitle(item, newTitle: editedTitle, userId: userId)
                            isEditing = false
                        }
                    }
            } else {
                Text(item.title)
                    .strikethrough(item.isCompleted, color: .secondary)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture(count: 2) {
                        editedTitle = item.title
                        isEditing = true
                    }
            }

            Spacer()

            // Edit button
            if isEditing {
                Button("Save") {
                    Task {
                        await todoVM.updateTitle(item, newTitle: editedTitle, userId: userId)
                        isEditing = false
                    }
                }
                .font(.caption.bold())
                .foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
