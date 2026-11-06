//
//  TodoListView.swift
//  MyNote51
//

import SwiftUI
import FirebaseAuth

struct TodoListView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var todoVM: TodoViewModel

    @State private var newTodoTitle = ""
    @State private var showAddField = false

    var userId: String { authVM.user?.uid ?? "" }

    var pendingTodos: [TodoItem] { todoVM.todos.filter { !$0.isCompleted } }
    var completedTodos: [TodoItem] { todoVM.todos.filter { $0.isCompleted } }

    var body: some View {
        NavigationStack {
            Group {
                if todoVM.isLoading && todoVM.todos.isEmpty {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if todoVM.todos.isEmpty {
                    emptyStateView
                } else {
                    todoList
                }
            }
            .navigationTitle("My Todos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Logout") {
                        todoVM.stopListening()
                        authVM.signOut()
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation { showAddField.toggle() }
                    } label: {
                        Image(systemName: showAddField ? "xmark.circle.fill" : "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if showAddField {
                    addTodoBar
                }
            }
            .alert("Error", isPresented: .constant(todoVM.errorMessage != nil)) {
                Button("OK") { todoVM.errorMessage = nil }
            } message: {
                Text(todoVM.errorMessage ?? "")
            }
        }
        .onAppear {
            todoVM.startListening(for: userId)
        }
    }

    // MARK: - Todo List
    private var todoList: some View {
        List {
            if !pendingTodos.isEmpty {
                Section("Pending (\(pendingTodos.count))") {
                    ForEach(pendingTodos) { item in
                        TodoRowView(item: item, userId: userId)
                    }
                    .onDelete { offsets in
                        todoVM.deleteTodos(at: offsets, userId: userId)
                    }
                }
            }

            if !completedTodos.isEmpty {
                Section("Completed (\(completedTodos.count))") {
                    ForEach(completedTodos) { item in
                        TodoRowView(item: item, userId: userId)
                    }
                    .onDelete { offsets in
                        todoVM.deleteTodos(at: offsets, userId: userId)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text("No todos yet!")
                .font(.title2.bold())
            Text("Tap the + button to add your first task.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Add Todo Bar
    private var addTodoBar: some View {
        HStack(spacing: 12) {
            TextField("What needs to be done?", text: $newTodoTitle)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onSubmit { submitNewTodo() }

            Button(action: submitNewTodo) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(newTodoTitle.isEmpty ? .secondary : .blue)
            }
            .disabled(newTodoTitle.isEmpty)
        }
        .padding()
        .background(.regularMaterial)
    }

    private func submitNewTodo() {
        guard !newTodoTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        Task {
            await todoVM.addTodo(title: newTodoTitle, userId: userId)
            newTodoTitle = ""
            withAnimation { showAddField = false }
        }
    }
}

#Preview {
    TodoListView()
        .environmentObject(AuthViewModel())
        .environmentObject(TodoViewModel())
}
