# Project XYZ - Unified Workforce Management

A premium, high-fidelity workforce management and attendance system built with Flutter and Supabase. Designed for security, efficiency, and high-end user experience.

---

## 🗺️ Project Roadmap

| Phase | Focus | Key Deliverables |
| :--- | :--- | :--- |
| **Phase A** | **Architecture** | ✅ Database schema & secure environment setup. |
| **Phase B** | **Authentication** | ✅ Secure login & Face ID registration implemented. |
| **Phase C** | **Location Logic** | ✅ GPS/Geo-fencing logic for attendance (Dynamic). |
| **Phase D** | **Task Module** | ✅ Kanban-style task tracker with proof-of-work imaging. |
| **Phase E** | **Admin Portal** | ✅ PDF reporting and analytics dashboards. |
| **Phase F** | **Pro Scaling** | ✅ Logic for automated payroll calculation. |
| **Phase G** | **Deployment** | ✅ Android/iOS release configs & permissions finalized. |

---

## 💎 Core Features

- **Biometric Trust**: AI-powered face matching for secure attendance.
- **Geofenced Security**: Site-specific check-ins via high-precision GPS.
- **Task Intelligence**: Real-time team operations with Kanban tracking.
- **Pro Analytics**: Advanced dashboard for admin oversight and payroll transparency.
- **Luxury UI**: Dark-mode primary interface with glassmorphism and smooth micro-animations.

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **AI**: Google ML Kit (Face Detection)
- **Design**: Material 3 + Custom Luxury Design System

## 🚀 Getting Started

1. **Backend Setup**:
   - Run the SQL in `supabase/schema.sql` in your Supabase SQL Editor to initialize tables and RLS policies.
   - Update your Supabase URL and Key in the `.env` file at the root of the project.
2. **Dependencies**: Run `flutter pub get`.
3. **Run**: Use `flutter run` to launch on your preferred device.

## 📦 Automated Builds (CI/CD)

This project is configured with **GitHub Actions**. Every time you push to the `main` branch, a production-ready APK is automatically built in the cloud.

1. Push your code to a GitHub repository.
2. Go to the **Actions** tab on GitHub.
3. Once the "Build Release APK" workflow finishes, download the APK from the **Artifacts** section.

---
*Powering the modern workforce with precision and style.*
