# MyNote - A To-Do-List App

> A simple, modern SwiftUI todo app with Firebase authentication and real-time cloud synchronization.

MyNote is an iOS application created for a Mobile Computing Laboratory assignment. Users can create an account, sign in securely, and manage their personal todo list from a clean SwiftUI interface.

## Screenshots

<p align="center">
  <img src="./MyNote51/MyNote51/UI%20Screenshots/IMG-20261106-WA0006.jpg" width="220" alt="MyNote completed todo screen">
  <img src="./MyNote51/MyNote51/UI%20Screenshots/IMG-20261106-WA0003.jpg" width="220" alt="MyNote authentication screen">
  <br>
  <img src="./MyNote51/MyNote51/UI%20Screenshots/IMG-20261106-WA0005.jpg" width="220" alt="MyNote adding a todo">
  <img src="./MyNote51/MyNote51/UI%20Screenshots/IMG-20261106-WA0004.jpg" width="220" alt="MyNote todo list screen">
</p>

## Features

- Email and password login
- New user registration
- Real-time todo synchronization with Firebase Firestore
- Add, edit, complete, and delete todos
- Separate pending and completed task sections
- Empty-state screen for new users
- Loading and error states
- Sign out from the todo list

## Tech Stack

- **SwiftUI** for the user interface
- **Firebase Authentication** for account management
- **Cloud Firestore** for real-time todo storage
- **Xcode** for development and iOS builds

## Project Structure

```text
MyNote51/
└── MyNote51/
    ├── MyNote51/              # SwiftUI application source
    │   ├── Models/
    │   ├── ViewModels/
    │   └── Views/
    └── UI Screenshots/        # Application screenshots
```

## Getting Started

1. Clone this repository.
2. Open `MyNote51/MyNote51/MyNote51.xcodeproj` in Xcode.
3. Ensure the project has a valid Firebase `GoogleService-Info.plist`.
4. Select an iOS simulator or connected device.
5. Build and run the app.

> Firebase Authentication and Cloud Firestore must be enabled in the connected Firebase project for login and todo synchronization to work.
