//
//  TodoItem.swift
//  MyNote51
//

import Foundation
import FirebaseFirestore

struct TodoItem: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var isCompleted: Bool
    var userId: String
    var createdAt: Date

    init(id: String? = nil, title: String, isCompleted: Bool = false, userId: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.userId = userId
        self.createdAt = createdAt
    }
}
