//
//  AuthView.swift
//  MyNote51
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab = 0
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.blue)
                    Text("My To-Do List")
                        .font(.largeTitle.bold())
                    Text("Your personal todo list")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)

                // Tab Picker
                Picker("Mode", selection: $selectedTab) {
                    Text("Login").tag(0)
                    Text("Register").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 32)

                // Form
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    SecureField("Password (min 6 chars)", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Error Message
                    if let error = authVM.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }

                    // Action Button
                    Button {
                        Task {
                            if selectedTab == 0 {
                                await authVM.signIn(email: email, password: password)
                            } else {
                                await authVM.signUp(email: email, password: password)
                            }
                        }
                    } label: {
                        Group {
                            if authVM.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(selectedTab == 0 ? "Login" : "Create Account")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(authVM.isLoading || email.isEmpty || password.isEmpty)
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onChange(of: selectedTab) {
                authVM.errorMessage = nil
                password = ""
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
