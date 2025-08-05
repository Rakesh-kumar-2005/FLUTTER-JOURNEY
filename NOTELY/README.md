# 📝 Notely - A Flutter Note Taking App

**Notely** is a beautifully minimal, fully-featured note-taking application built using **Flutter**, **Dart**, and **Sqflite** for local data persistence. It supports **light/dark themes**, smooth UI, and colorful notes to organize your thoughts better.

> 🎯 **Live Demo (APK)**: _Coming Soon_. <br>
> 📂 **GitHub Repo**: [https://github.com/Rakesh-kumar-2005/FLUTTER-JOURNEY/NOTELY](https://github.com/Rakesh-kumar-2005/FLUTTER-JOURNEY/NOTELY)

---

## 🛠️ Tech Stack

* 💙 **Flutter** – For building natively compiled applications.
* 🧠 **Dart** – Modern, reactive programming language.
* 💾 **Sqflite** – Lightweight SQLite plugin for Flutter.
* 🎨 **Multiple Accent Colors** – Variety of vibrant note colors.
* 🌗 **Theme Support** – Light and Dark mode support.

---

## 🌈 Note Colors Used



| Color Dot | Name            |
|-----------|-----------------|
|   🟡      | Amber           |
|   🔴      | Red Accent      |
|   🔵      | Blue Accent     |
|   🟢      | Green Accent    |
|   🟣      | Purple Accent   |
|   🟡      | Yellow Accent   |
|   🟠      | Orange Accent   |
|   🌸      | Pink Accent     |
|   🔷      | Cyan Accent     |
|   💚      | Emerald Green   |



---

## 📸 Screenshots

> Screenshots of the project are located in the `/assets/screenshots` folder.
> You can add them below by using the following format:

### 🌞 Light Mode & 🌙 Dark Mode

| Light Mode | Dark Mode |
|------------|-----------|
| <img src="https://raw.githubusercontent.com/Rakesh-kumar-2005/FLUTTER-JOURNEY/main/NOTELY/assets/screenshots/ss1.jpg" width="200" style="height:auto;"/> | <img src="https://raw.githubusercontent.com/Rakesh-kumar-2005/FLUTTER-JOURNEY/main/NOTELY/assets/screenshots/ss2.jpg" width="200" style="height:auto;"/> |

### 📄 Note View & ✏️ Edit Screen

| Note View Screen | Edit Screen |
|------------------|-------------|
| <img src="https://raw.githubusercontent.com/Rakesh-kumar-2005/FLUTTER-JOURNEY/main/NOTELY/assets/screenshots/ss3.jpg" width="200" style="height:auto;"/> | <img src="https://raw.githubusercontent.com/Rakesh-kumar-2005/FLUTTER-JOURNEY/main/NOTELY/assets/screenshots/ss4.jpg" width="200" style="height:auto;"/> |


---

## 📁 Project Structure

```
NOTELY/
├── android/
├── assets/
│   └── screenshots/            # Screenshots for README
├── build/
├── ios/
├── lib/
│   ├── model/                  # Note model classes
│   ├── screens/                # UI Screens
│   │   ├── add_edit_screen.dart
│   │   ├── home_screen.dart
│   │   └── view_note_screen.dart
│   ├── services/               # Local DB and helper functions
│   ├── Theme/                  # Theme provider for light/dark mode
│   └── main.dart               # Entry point of the app
├── linux/
├── macos/
├── test/
├── web/
├── windows/
├── .flutter-plugins
├── .flutter-plugins-dependencies
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── notely.iml
├── pubspec.lock
├── pubspec.yaml
└── README.md

```

---

## 🚀 Getting Started

### 🔧 Prerequisites

Make sure you have Flutter installed. [Get Flutter →](https://flutter.dev/docs/get-started/install)

### 📥 Clone & Run

```bash
git clone https://github.com/Rakesh-kumar-2005/FLUTTER-JOURNEY.git
cd FLUTTER-JOURNEY/NOTELY
flutter pub get
flutter run
```

---

## 🔐 Features

* 📝 Create, update, and delete notes
* 🌈 Color-coded notes for better visual management
* 🌗 Toggle between light and dark themes
* 🗂️ Local storage using `sqflite`
* 🔄 Responsive and clean UI

---

## 🛣️ Future Plans

* Add cloud sync using Firebase
* Add reminders and alarms
* Add voice note support

---

## 📌 License

This project is open-source and free to use. Contributions welcome!

---

## 🙌 Acknowledgments

* Flutter team & community
* Sqflite for local DB
* Theme provider logic from Flutter examples

---