//
//  ContentView.swift
//  MyNote51
//
//  Created by Md Sabbir Hossain on 6/11/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Group {
            if authVM.isLoggedIn {
                TodoListView()
            } else {
                AuthView()
            }
        }
        .animation(.easeInOut, value: authVM.isLoggedIn)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(TodoViewModel())
}
