# ChatApp 💬

A real-time Flutter chat application powered by Firebase. Supports one-on-one messaging, group chats, image sharing, email verification, and a dark/light theme toggle.

---

## Features

- **Authentication** – Register and log in with email & password via Firebase Auth. New accounts require email verification before access.
- **One-on-One Chat** – Real-time messaging between any two users stored in Firestore.
- **Image Sharing** – Send photos from your device; images are uploaded to Firebase Storage and shared in the chat.
- **Group Chat** – Create groups, add members, and chat in a shared room.
- **Dark / Light Mode** – Toggle between themes from the Settings page.
- **Cross-platform** – Runs on Android, iOS, Web, Linux, macOS, and Windows.

---

## Screenshots

> Add screenshots of your app here.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Storage | Firebase Storage |
| State management | Provider |
| Date/time formatting | intl |
| Image picker | image_picker |
| Unique IDs | uuid |

---

## Project Structure

```
lib/
├── authentication/       # Login, register, and login-or-register screens
├── components/           # Reusable UI widgets (drawer, user tile, etc.)
├── models/               # Data models (Message)
├── pages/
│   ├── group/            # Group creation, member management, and group chat room
│   ├── chat_page.dart    # One-on-one chat screen
│   ├── home_page.dart    # User list / home screen
│   ├── settings_page.dart
│   └── emailverify_page.dart
├── services/
│   ├── auth_gate.dart    # Decides which screen to show based on auth state
│   ├── auth_service.dart # Firebase Auth helper (sign-up, sign-in, sign-out)
│   └── chat_service.dart # Firestore messaging & image upload helpers
├── themes/               # Light and dark theme definitions + ThemeProvider
└── main.dart
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.2.3
- A Firebase project with the following services enabled:
  - Authentication (Email/Password provider)
  - Cloud Firestore
  - Firebase Storage

### Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/Vkkrm14/ChatApp.git
   cd ChatApp
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   - Install the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli) and run:

     ```bash
     flutterfire configure
     ```

   - This generates `lib/firebase_options.dart` with your project credentials.

4. **Run the app**

   ```bash
   flutter run
   ```

---

## Firestore Data Model

```
users/
  {email}/
    E-mail: string
    Name:   string
    Uid:    string
    groups/
      {groupId}/
        id:   string
        name: string

chat_rooms/
  {sorted_email1_email2}/
    messages/
      {messageId}/
        senderId:      string
        senderEmail:   string
        recieverEmail: string
        message:       string   # text content or image URL
        type:          "text" | "img"
        timestamp:     Timestamp

groups/
  {groupId}/
    name:    string
    members: [email, ...]
    messages/
      ...
```

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## License

This project is open source. See [LICENSE](LICENSE) for details.
