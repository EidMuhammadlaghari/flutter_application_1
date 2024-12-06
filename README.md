# Task Manager Application

A Flutter-based task management application that allows users to schedule tasks, receive notifications, and send email reminders for tasks. It integrates Firebase for authentication and Firestore for task storage, as well as Flutter Local Notifications for push notifications.

## Features

- **User Authentication**: Sign up and log in using Firebase Authentication.
- **Task Management**: Create, view, edit, and delete tasks.
- **Task Notifications**: Receive local notifications for tasks based on the scheduled time.
- **Email Notifications**: Send email reminders for tasks to specified recipients.
- **Real-time Updates**: Tasks are fetched from Firestore and updated in real-time.

---

## Tech Stack

- **Flutter**: Cross-platform mobile development framework.
- **Firebase Authentication**: For user login and signup.
- **Cloud Firestore**: For storing and managing tasks.
- **Flutter Local Notifications**: For scheduling and displaying task notifications.
- **Mailer (SMTP)**: For sending email notifications.
- **GetX**: State management for efficient data binding and navigation.
- **Permission Handler**: For managing notification permissions.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Firebase project](https://firebase.google.com/docs/flutter/setup)
- An email account (used for SMTP email notifications)

---

## Setup

1. Clone this repository:

   ```bash
   git clone https://github.com/EidMuhammadlaghari/flutter_application_1.git
   ```

2. Install dependencies:

   Navigate to the project directory and run:

   ```bash
   flutter pub get
   ```

3. Set up Firebase for your project:

   - Go to [Firebase Console](https://console.firebase.google.com/), create a new project, and enable Firebase Authentication and Firestore.
   - Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) and place them in the `android/app` or `ios/Runner` directory, respectively.

4. Set up Firebase authentication and Firestore rules.

   Firebase Authentication should allow email/password login and Firestore rules should allow read/write access based on user authentication.

5. Configure your email sender settings:
   
   - You need a Gmail account for sending email notifications. 
   - Use your own SMTP credentials in the `HomeController` class:
     - Email: `tasktrack123@gmail.com`
     - Password: `iolbtunkfitqzpgy`
     - SMTP Server: `smtp.gmail.com`
     - Port: `587`

---

## Usage

### 1. Running the Application

After completing the setup, you can run the application on your emulator or physical device:

```bash
flutter run
```

### 2. Register and Login

- Sign up with your email and password.
- Log in to access your task manager.

### 3. Creating Tasks

- Create tasks by specifying the title, description, recipient email (for email tasks), and scheduled time.
- Tasks will be shown under "Upcoming Tasks" and will trigger notifications based on the set time.

### 4. Receiving Notifications

- You will receive push notifications for tasks based on their scheduled time.
- If an email recipient is set, an email will also be sent.

### 5. Marking Tasks as Complete

- Tasks can be marked as completed once you finish them, and this will reflect on the Firebase Firestore.

---

## Code Structure

- **HomeController**: Main logic for managing tasks, notifications, email sending, and Firestore operations.
- **Task**: Data model representing a task with attributes like title, description, dateTime, and recipient.
- **Firebase Authentication**: Used for user login and sign-up functionalities.
- **Firebase Firestore**: Used for storing user tasks, fetched and updated in real-time.

---

## Contributions

Feel free to fork the repository, make changes, and open a pull request.

---
