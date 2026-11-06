//
//  TodoViewModel.swift
//  MyNote51
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    // MARK: - Start Listening (Real-time)
    func startListening(for userId: String) {
        // Remove any existing listener
        listener?.remove()

        isLoading = true
        listener = db
            .collection("todos")
            .document(userId)
            .collection("items")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.todos = (snapshot?.documents ?? []).compactMap { doc in
                    try? doc.data(as: TodoItem.self)
                }
            }
    }

    // MARK: - Stop Listening
    func stopListening() {
        listener?.remove()
        listener = nil
        todos = []
    }

    // MARK: - Create
    func addTodo(title: String, userId: String) async {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newItem = TodoItem(title: title, userId: userId)
        do {
            _ = try db
                .collection("todos")
                .document(userId)
                .collection("items")
                .addDocument(from: newItem)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Update (Toggle Complete)
    func toggleComplete(_ item: TodoItem, userId: String) async {
        guard let id = item.id else { return }
        do {
            try await db
                .collection("todos")
                .document(userId)
                .collection("items")
                .document(id)
                .updateData(["isCompleted": !item.isCompleted])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Update Title
    func updateTitle(_ item: TodoItem, newTitle: String, userId: String) async {
        guard let id = item.id,
              !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        do {
            try await db
                .collection("todos")
                .document(userId)
                .collection("items")
                .document(id)
                .updateData(["title": newTitle])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Delete
    func deleteTodo(_ item: TodoItem, userId: String) async {
        guard let id = item.id else { return }
        do {
            try await db
                .collection("todos")
                .document(userId)
                .collection("items")
                .document(id)
                .delete()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Delete from IndexSet (swipe)
    func deleteTodos(at offsets: IndexSet, userId: String) {
        Task {
            for index in offsets {
                await deleteTodo(todos[index], userId: userId)
            }
        }
    }
}
