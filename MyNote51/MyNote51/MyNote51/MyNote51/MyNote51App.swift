//
//  MyNote51App.swift
//  MyNote51
//
//  Created by Md Sabbir Hossain on 6/11/26.
//

import SwiftUI
import FirebaseCore

@main
struct MyNote51App: App {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var todoVM = TodoViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .environmentObject(todoVM)
        }
    }
}
