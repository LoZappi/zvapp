# Z&V Transport App

## Overview
A Flutter web application for Z&V Transport services. The app allows users to create and manage transport-related quotes for moving (Umzug), transport, and clearing (Entrümpelung) services.

## Project Architecture
- **Framework**: Flutter 3.32.0 with Dart 3.8.0
- **Platform**: Web (built and served as static files)
- **State Management**: Simple StatelessWidget pattern with repo pattern for data

## Directory Structure
```
lib/
├── data/           - Data repositories and catalogs
├── models/         - Data models (Request, etc.)
├── pricing/        - Pricing logic
├── theme/          - Theme definitions
├── ui/
│   ├── components/ - Reusable UI components
│   ├── screens/    - App screens and wizards
│   ├── theme/      - Colors and styling
│   ├── utils/      - UI helper utilities
│   └── widgets/    - App-level widgets
└── utils/          - General utilities
```

## Development Workflow
- Build: `flutter build web --release`
- The built files are served from `build/web/` directory
- Uses Python's http.server to serve static files on port 5000

## Dependencies
Key packages:
- firebase_core, cloud_firestore (Firebase integration - currently unused in web)
- url_launcher (URL launching)
- path_provider (File paths)
- image_picker (Image selection)

## Recent Changes
- 2026-01-08: Configured for Replit environment with SDK ^3.8.0
- 2026-01-08: Set up static file serving workflow on port 5000
