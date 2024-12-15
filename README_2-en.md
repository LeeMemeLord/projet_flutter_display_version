# Class Management Application

This project is an application developed in **Flutter** with **Firebase** as the backend. It allows students and teachers to access and manage classes intuitively.

## Prerequisites

Before you begin, ensure you have the following tools installed on your machine:

- **Flutter** (latest version): [Official Documentation](https://flutter.dev/docs/get-started/install)
- **Android Studio** or **Visual Studio Code**
- **Android SDK** properly configured
- A Firebase account and a configured project

## Firebase Configuration

1. Create a project in Firebase: [Firebase Console](https://console.firebase.google.com/).
2. Add an Android application to your Firebase project.
3. Download the `google-services.json` file.
4. Place this file in the following directory of your project:  
   `android/app/google-services.json`

Make sure to enable the necessary Firebase services (e.g., Authentication, Firestore, Cloud Storage).

## Installation and Execution

### 1. Clone the Repository

Clone the Git repository for this project to your local machine:

git clone <repository_url>  
cd <project_name>

### 2. Install Dependencies

Retrieve all project dependencies by running the following command in the terminal:

flutter pub get

### 3. Prepare a Device or Emulator

- Connect a physical Android device to your computer (enable USB debugging on the device).
- Or configure an Android emulator in Android Studio.

### 4. Run the Application

Launch the application with the following command:

flutter run

Ensure that the device or emulator is detected by Flutter before executing the command.

## Application Features

- **Authentication**: Login and registration for students and teachers.
- **Class Management**: View and edit class information.
- **Real-Time Database**: Synchronize data via Firebase.

## Common Issues

- **Firebase Connection**: If the application does not connect to Firebase correctly, ensure the `google-services.json` file is in the correct location.
- **Firebase Services**: Ensure your Firebase project includes all necessary services (e.g., Firestore or Authentication).
- **Device Not Detected**: If no device is detected by Flutter, use the following command to check connected devices:

flutter devices

## Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)

---

This project is designed for efficient class management and seamless data synchronization using Flutter and Firebase.
