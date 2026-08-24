# 🏫 Madrasty (مدرستي) - School Management & Educational Social Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.44+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-GetX%20MVC-orange?style=for-the-badge)](https://pub.dev/packages/get)
[![Language](https://img.shields.io/badge/Localization-Arabic%20%7C%20English-blue?style=for-the-badge)](#-internationalization--localization)

**Madrasty** is a school management, educational social network, and student tracking platform built with **Flutter**. It unifies schools, teachers, parents, students, supervisors, and transportation drivers in a single mobile experience with multimedia feeds, direct messaging, attendance monitoring, class schedules, and school exploration.

---

## 📑 Table of Contents

- [🌟 Features Overview](#-features-overview)
- [👥 User Documentation (Role Guides)](#-user-documentation-role-guides)
  - [1. Authentication & Security](#1-authentication--security)
  - [2. Teachers](#2-teachers-teacher)
  - [3. Parents](#3-parents-parent)
  - [4. Students](#4-students-student)
  - [5. Supervisors](#5-supervisors-supervisor)
  - [6. Drivers](#6-drivers-driver)
  - [7. Guests & School Explorer](#7-guests--school-explorer)
- [🛠 Technical Documentation](#-technical-documentation)
  - [Architecture & Design Pattern](#architecture--design-pattern)
  - [Directory Structure](#directory-structure)
  - [Core Services & Networking](#core-services--networking)
  - [Data Models](#data-models)
  - [Internationalization & Localization](#internationalization--localization)
  - [Key Dependencies](#key-dependencies)
- [💻 Installation & Setup Guide (Mac & Laptop)](#-installation--setup-guide-mac--laptop)
  - [System Requirements](#system-requirements)
  - [Setup on macOS (iOS & Android)](#setup-on-macos-ios--android)
  - [Setup on Windows / Linux (Android)](#setup-on-windows--linux-android)
  - [Running the Application](#running-the-application)
  - [Building Production Bundles](#building-production-bundles)
  - [Common Troubleshooting](#common-troubleshooting)

---

## 🌟 Features Overview

- **Dynamic Role-Based UI**: Adapts dashboards, permissions, and available navigation tabs according to the logged-in role (`Teacher`, `Parent`, `Student`, `Supervisor`, `Driver`, or `Visitor`).
- **Interactive Educational Feed**: Share multimedia posts (photos, compressed videos, PDF documents) with class/subject-targeted privacy filters, likes, comments, and post reporting.
- **In-App Messaging & Media Sharing**: 1-on-1 chat channels supporting rich attachments (images, video, documents) and the ability to share specific feed posts directly into conversation threads.
- **Attendance & Departure Tracking**: Real-time student attendance marking, absence reporting, and check-in/check-out logs.
- **Academic & Behavioral Recommendations**: Direct feedback channel between teachers and parents regarding student academic progress and conduct.
- **School Directory & Maps**: Searchable directory of registered schools with geographical map previews, contact information, tuition fees, and admission inquiry forms.
- **Bilingual Experience**: Native support for **Arabic (RTL)** and **English (LTR)** with custom typography (*Bahij TheSansArabic* & *Alois*).
- **Biometric Security**: Quick biometric fingerprint/FaceID authentication alongside OTP verification.

---

## 👥 User Documentation (Role Guides)

### 1. Authentication & Security
- **Registration & Verification**: Users sign up with their phone number, country code, name, and role. A 4-digit SMS OTP is sent for identity verification.
- **Login**: Fast login using phone number + password or saved biometric credentials (`Face ID` / `Fingerprint`).
- **Password Recovery**: Secure OTP-based self-service password reset.

### 2. Teachers (`TEACHER`)
- **Publish Posts**: Create announcements, homework assignments, or educational activities. Attach multiple photos, video clips (automatically compressed), or PDF files. Choose whether the post is visible to specific classes or subjects.
- **Attendance Management**: Mark student daily presence, absence, and arrival/leaving statuses per class.
- **Class Schedules**: View weekly teaching schedules and subject timetables.
- **Behavioral Recommendations**: Submit behavioral or academic praise/notes for specific students directly accessible to their parents.

### 3. Parents (`PARENT`)
- **Multi-Child Dashboard**: Switch seamlessly between enrolled children to view individualized data.
- **Monitor Attendance**: Real-time attendance notifications and historical attendance records.
- **Class Schedules & Feeds**: Check daily lesson timetables and class updates posted by teachers.
- **Direct Messaging**: Chat directly with teachers and bus drivers.
- **Driver Tracking**: View assigned bus driver details and arrival/drop-off status.

### 4. Students (`STUDENT`)
- **Daily Timetables**: View upcoming classes, subjects, and assigned teachers.
- **Class Posts & Assignments**: Access homework sheets, PDF attachments, video lectures, and announcements.
- **Teacher Communication**: Ask questions and communicate directly with teachers.

### 5. Supervisors (`SUPERVISOR`)
- **Class Attendance Tables**: Audit attendance records across multiple classes and school departments.
- **Student Status Updates**: Verify check-in/check-out logs and generate student status sheets.

### 6. Drivers (`DRIVER`)
- **Trip Coordination**: View assigned students list for bus routes.
- **Parent Communication**: Quick messaging channel with parents for pickup and drop-off updates.

### 7. Guests & School Explorer
- **Explore Schools**: Search schools by region, educational stage (Kindergarten, Primary, Preparatory, Secondary), and school type (Private, Language, International).
- **School Profile**: View facilities, photos, contact numbers, map location, and social media channels.
- **Join School Request**: Submit a request directly to the school administration to enroll a child.

---

## 🛠 Technical Documentation

### Architecture & Design Pattern

Madrasty follows a clean **GetX MVC / MVVM** modular architectural pattern:

```
┌─────────────────────────────────────────────────────────────┐
│                          UI Layer                           │
│  (Screens, Custom Widgets, Forms, Reactive GetView/GetBuilder)│
└──────────────────────────────┬──────────────────────────────┘
                               │ Observables & Events
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      Controller Layer                       │
│     (GetxController: Business Logic, State Management)       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Calls
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                       Services Layer                        │
│   (PostingServices, AuthServices, AttendanceServices, etc.)  │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTP / Cache
                               ▼
┌──────────────────────────────┴──────────────────────────────┐
│                  Network & Storage Client                   │
│   (Dio ApiService, PrettyDioLogger, StorageService/Prefs)   │
└─────────────────────────────────────────────────────────────┘
```

- **Dependency Injection**: Services (`StorageService`, `LocalizationService`, `ConnectionService`) are registered permanently at boot time via `Get.putAsync` and `Get.put`.
- **Reactive UI**: State updates are triggered using `update()` inside `GetBuilder` or reactive Rx observables (`.obs`).
- **HTTP Client**: Powered by `Dio` with custom timeout handling (10 minutes for large media uploads), interceptors, and error handling dialogs.

---

### Directory Structure

```
lib/
├── main.dart                             # Application entry point & service initialization
├── Models/                               # 30 Data transfer object (DTO) models
│   ├── auth_model.dart                   # Auth tokens, user profiles, and session info
│   ├── post_model.dart                   # Feed posts, attachments, likes, comments
│   ├── school_details_model.dart         # School profile, coordinates, ratings
│   ├── attendance_table_model.dart       # Student attendance sheets
│   ├── messages_list_model.dart          # Real-time chat messages
│   └── class_schedules_model.dart        # Timetable schedules
├── Services/                             # API service layer
│   ├── api_service.dart                  # Core Dio client wrapper
│   ├── auth_services.dart                # Sign in, Sign up, OTP, password recovery
│   ├── posting_services.dart             # Feed retrieval, post creation, comments
│   ├── chat_services.dart                # Messaging channels & media transfers
│   ├── attendance_services.dart          # Attendance marking and reports
│   └── school_services.dart              # School directory search and filtering
├── UI/                                   # Feature modules (Screens & Controllers)
│   ├── auth/                             # Login, Sign Up, OTP screens
│   ├── home_screen/                      # Dynamic role dispatcher dashboard
│   ├── posts/                            # Post feeds, media preview, comments
│   ├── chat/                             # 1-on-1 chat with media & post attachments
│   ├── teacher_profile/                  # Teacher dashboard, attendance, schedules
│   ├── perent_profile_screen/            # Parent multi-child view & driver tracking
│   ├── student_profile/                  # Student timetable & class feed
│   ├── sepervisor_profile/               # Supervisor class oversight tools
│   ├── driver_profile/                   # Driver student transport tools
│   ├── school_list/ & school_details/    # School explorer, map views & directory
│   ├── costumer_care/                    # In-app live support (Tawk.to)
│   └── academic_and_behavior_recommendation/ # Behavior notes & academic reviews
├── Utils/                                # Utilities & Configurations
│   ├── memory.dart                       # StorageService wrapping SharedPreferences
│   ├── localization_services.dart        # Locale controller (AR/EN toggle)
│   ├── transelation/                     # Multi-language string dictionaries
│   ├── connection_service.dart           # Real-time Internet connectivity monitoring
│   ├── validator.dart                    # Form validation rules (email, phone, password)
│   └── Colors_File.dart                  # Color palette constants
└── Widgets/                              # Reusable UI widgets
    ├── DrawerWidget.dart                 # Dynamic role-based navigation drawer
    ├── custom_text_widget.dart           # Auto-font switching typography widget
    ├── text_field_widget.dart            # Custom styled input fields
    └── file_icons_widget.dart            # Dynamic file extension icon renderer
```

---

### Core Services & Networking

The application communicates with a backend REST API hosted at `https://my-school-app.com/api/`.

- **`ApiService`** (`lib/Utils/api_service.dart`):
  - Built on `Dio` with request/response logging via `PrettyDioLogger`.
  - Configurable timeouts (`connectTimeout: 600,000ms`, `receiveTimeout: 600,000ms`).
  - Automatic error boundary dialogs with localized messages.
- **`StorageService`** (`lib/Utils/memory.dart`):
  - Manages session keys: `userId`, `userType`, `userOtp`, `schoolId`, `activeLocale`.
- **`ConnectionService`** (`lib/Utils/connection_service.dart`):
  - Listens to device connectivity state changes (`connectivity_plus`) and verifies active DNS resolution against `google.com`.

---

### Internationalization & Localization

- **Supported Locales**:
  - `ar`: Arabic (Default - RTL)
  - `en`: English (LTR)
- **Automatic Font Switching**:
  - Arabic: *Bahij TheSansArabic* (`Al-Mujahed_Al-Anbobi`)
  - English: *Alois* (`alois`)
- **Key Translation Dictionary**: Found in `lib/Utils/transelation/app_transelation.dart` and referenced using `.tr` extension.

---

### Key Dependencies

| Dependency | Purpose |
| :--- | :--- |
| `get: ^4.6.6` | Navigation, state management & dependency injection |
| `dio: ^5.7.0` | HTTP networking client |
| `shared_preferences: ^2.3.5` | Local persistent storage |
| `connectivity_plus: ^6.1.0` | Network status monitoring |
| `firebase_core: ^3.10.1` | Firebase initialization |
| `firebase_messaging: ^15.2.1` | Cloud push notifications |
| `google_maps_flutter: ^2.10.0` | Interactive Google Maps in school profiles |
| `video_player: ^2.9.2` | In-app video playback |
| `video_compress: ^3.1.4` | Video compression prior to upload |
| `pdf: ^3.11.1` & `flutter_pdfview: 1.3.2` | PDF document rendering and generation |
| `local_auth: ^2.3.0` | Biometric fingerprint / Face ID authentication |
| `flutter_tawkto: ^0.0.5` | Live support chat widget |
| `cached_network_image: ^3.4.1` | Image caching with placeholder shimmers |

---

## 💻 Installation & Setup Guide (Mac & Laptop)

Follow these steps to run Madrasty on your laptop (macOS, Windows, or Linux).

### System Requirements

1. **Flutter SDK**: `3.44.x` or newer ([Install Flutter](https://docs.flutter.dev/get-started/install))
2. **Dart SDK**: `3.12.x` or newer (included with Flutter)
3. **Java Development Kit (JDK)**: JDK 17 (Required for modern Gradle 8.x)
4. **Git**: Latest version installed
5. **IDE**: [VS Code](https://code.visualstudio.com/) (with Flutter and Dart extensions) or [Android Studio](https://developer.android.com/studio)

---

### Setup on macOS (iOS & Android)

#### 1. Install Homebrew & Dependencies
Open Terminal and run:
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Flutter via Homebrew (or download manually from flutter.dev)
brew install --cask flutter

# Install CocoaPods (required for iOS dependencies)
brew install cocoapods
```

#### 2. Configure Xcode for iOS
1. Install **Xcode** from the Mac App Store.
2. Configure command-line tools:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```
3. Open iOS Simulator:
   ```bash
   open -a Simulator
   ```

#### 3. Configure Android Studio on macOS
1. Download and install **Android Studio for Mac (Apple Silicon or Intel)**.
2. Open Android Studio → **SDK Manager** → Install:
   - Android SDK Platform (API 34 / 35)
   - Android SDK Command-line Tools
   - Android SDK Build-Tools
3. Accept Android licenses:
   ```bash
   flutter doctor --android-licenses
   ```

#### 4. Clone and Prepare Project
```bash
# Clone repository
git clone https://github.com/AhmedElbasha97/madrasty.git
cd madrasty/madrasty

# Install Flutter dependencies
flutter pub get

# Install iOS CocoaPods pods
cd ios
pod install
cd ..
```

---

### Setup on Windows / Linux (Android)

#### 1. Install Flutter & Java 17
1. Download Flutter SDK for Windows/Linux from [flutter.dev](https://docs.flutter.dev/get-started/install).
2. Extract to `C:\src\flutter` (Windows) or `~/development/flutter` (Linux).
3. Add Flutter `bin` directory to your system `PATH`.
4. Install **OpenJDK 17**:
   - Windows: [Adoptium Eclipse Temurin JDK 17](https://adoptium.net/)
   - Linux: `sudo apt install openjdk-17-jdk`
5. Set `JAVA_HOME` environment variable pointing to your JDK 17 installation.

#### 2. Install Android Studio & Setup Emulator
1. Download and install **Android Studio**.
2. Open **SDK Manager** and install:
   - Android SDK Platform (API 34 or 35)
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
3. Open **Virtual Device Manager (AVD)** and create an Android Emulator (e.g., Pixel 7 with API 34).
4. In terminal, accept licenses:
   ```powershell
   flutter doctor --android-licenses
   ```

#### 3. Clone and Fetch Packages
```powershell
git clone https://github.com/AhmedElbasha97/madrasty.git
cd madrasty\madrasty
flutter pub get
```

---

### Running the Application

1. Verify environment health:
   ```bash
   flutter doctor
   ```
   *Ensure Flutter, Android SDK, and Xcode (if on Mac) show green checkmarks.*

2. List available devices/emulators:
   ```bash
   flutter devices
   ```

3. Launch the app in debug mode:
   ```bash
   # Run on connected device or default simulator
   flutter run

   # Or specify target device
   flutter run -d chrome        # Web preview
   flutter run -d emulator-5554 # Android emulator
   flutter run -d iPhone        # iOS simulator (macOS only)
   ```

---

### Building Production Bundles

#### Android:
```bash
# Build Universal APK
flutter build apk --release

# Build Split per-ABI APKs (smaller file sizes)
flutter build apk --split-per-abi --release

# Build Google Play Store Bundle (.aab)
flutter build appbundle --release
```
*Output location:* `build/app/outputs/flutter-apk/app-release.apk`

#### iOS (macOS only):
```bash
# Build iOS Application Bundle
flutter build ipa --release
```
*Output location:* `build/ios/archive/Runner.xcarchive`

---

### Common Troubleshooting

<details>
<summary><b>1. Gradle Build Error: Java version mismatch</b></summary>

Ensure your IDE and terminal are using **Java 17**. Check via:
```bash
java -version
```
In Android Studio: Go to **Settings/Preferences → Build, Execution, Deployment → Build Tools → Gradle → Gradle JDK** and select **JDK 17**.
</details>

<details>
<summary><b>2. CocoaPods Error on macOS (pod install failed)</b></summary>

Run:
```bash
cd ios
rm -rf Pods Podfile.lock .symlinks
pod cache clean --all
pod repo update
pod install
cd ..
```
</details>

<details>
<summary><b>3. Missing Assets or Fonts</b></summary>

Run:
```bash
flutter clean
flutter pub get
```
</details>

---

## 📄 License & Contact

- **Repository**: [AhmedElbasha97/madrasty](https://github.com/AhmedElbasha97/madrasty)
- **API Portal**: [https://my-school-app.com](https://my-school-app.com)

