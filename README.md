# 🩺 Doctor Appointment App

A Flutter-based mobile application that enables users to browse doctors, book appointments, manage bookings, rate doctors, and maintain a list of favorite doctors. The application uses **Firebase Authentication** for user management and **Cloud Firestore** for cloud data storage.

## ✨ Features

- 🔐 User Authentication (Login & Signup)
- 👨‍⚕️ Browse Doctors
- 🔍 Search Doctors
- 🩺 Filter Doctors by Specialty
- 📅 Book Appointments
- ✏️ Reschedule Appointments
- ❌ Cancel Appointments
- ⭐ Rate & Review Doctors
- ❤️ Add/Remove Favorite Doctors
- 👤 User Profile
- ☁️ Real-time Cloud Firestore Integration
- Light/Dark Mode

---

## 🛠 Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Material Design

---

## 📂 Project Structure

```text
lib/
│
├── models/
│
├── providers/
│   ├── appointment_provider.dart
│   ├── auth_provider.dart
│   ├── doctor_provider.dart
│   └── theme_provider.dart
│
├── screens/
│   ├── appointments_screen.dart
│   ├── booking_screen.dart
│   ├── details_screen.dart
│   ├── doctor_details_screen.dart
│   ├── favorites_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── profile_screen.dart
│   ├── register_screen.dart
│   └── splash_screen.dart
│
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
│
├── utils/
│
├── widgets/
│
├── app.dart
├── firebase_options.dart
└── main.dart
```

---

## 📊 Firestore Structure

```text
Firestore
│
├── 123456                  (Doctors)
│     ├── doctorId
│     │      ├── name
│     │      ├── speciality
│     │      ├── experience
│     │      ├── fee
│     │      └── reviews
│
├── Appoinments
│     ├── appointmentId
│
└── users
      └── userId
             └── favorites
```

---

## 🚀 Getting Started

### Clone the repository

```bash
git clone https://github.com/AmanRB13/DoctorAppoinmentApp.git
```

### Install dependencies

```bash
flutter pub get
```

### Configure Firebase

Add your Firebase configuration files:

- `android/app/google-services.json`
- `lib/firebase_options.dart`

These files are intentionally excluded from the repository.

### Run the application

```bash
flutter run
```

---



---

## 👨‍💻 Author

**Aman Ranabhat**

Computer Engineering Student  
Pulchowk Campus
