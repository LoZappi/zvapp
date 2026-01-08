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
├── data/                    - Data repositories and catalogs
├── models/                  - Data models (Request, etc.)
├── pricing/                 - Pricing logic
├── theme/                   - Theme definitions
├── ui/
│   ├── components/          - Reusable UI components (ZVCard, ZVTopBar, etc.)
│   ├── theme/               - Colors and styling
│   ├── utils/               - UI helper utilities
│   └── screens/
│       ├── entruempelung/   - Entrümpelung service screens
│       │   └── sections/    - Step1, Step2, entru UI/waste categories
│       ├── umzug/           - Umzug (moving) service screens
│       │   └── wizard_*     - Address, contact, details, summary screens
│       ├── transport/       - Transport service screens (placeholder)
│       ├── altro/           - Altro service (coming soon placeholder)
│       ├── anfragen/        - Requests management screens
│       │   ├── dashboard_screen.dart
│       │   ├── requests_screen.dart
│       │   └── request_detail_screen.dart
│       └── shared/          - Shared screens and wizard components
│           ├── wizard/      - Common wizard state and shell
│           │   └── sections/ - Shared wizard sections
│           ├── quick_start_screen.dart
│           ├── home_screen.dart
│           └── splash_screen.dart
└── utils/                   - General utilities (share, PDF, etc.)
```

## Service-Based Organization
- **Entrümpelung** - Clearing/junk removal service flow
- **Umzug** - Moving service flow
- **Transport** - Transport service flow
- **Altro** - Coming soon placeholder
- **Anfragen** - Requests list and detail views
- **Shared** - Common components used across all services

## Development Workflow
- Build: `flutter build web --release`
- The built files are served from `build/web/` directory
- Uses Python's http.server to serve static files on port 5000

## Dependencies
Key packages:
- firebase_core, cloud_firestore (Firebase integration)
- url_launcher (URL launching)
- path_provider (File paths)
- image_picker (Image selection)

## Recent Changes
- 2026-01-08: Restructured app into service-based folders (entruempelung/, umzug/, transport/, altro/, anfragen/, shared/)
- 2026-01-08: Fixed all import paths after restructuring
- 2026-01-08: Created Altro coming soon placeholder
- 2026-01-08: Configured for Replit environment with SDK ^3.8.0
- 2026-01-08: Set up static file serving workflow on port 5000
