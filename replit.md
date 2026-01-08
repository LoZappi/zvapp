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
│       ├── entruempelung/           - Entrümpelung service
│       │   ├── entruempelung_step1.dart
│       │   ├── entruempelung_step2.dart
│       │   └── widgets/
│       │       ├── entruempelung_ui.dart
│       │       └── entruempelung_waste_categories.dart
│       │
│       ├── umzug/                   - Umzug (moving) service
│       │   ├── umzug_address.dart
│       │   ├── umzug_contact.dart
│       │   ├── umzug_details.dart
│       │   └── umzug_summary.dart
│       │
│       ├── transport/               - Transport service (placeholder)
│       │
│       ├── altro/                   - Altro service
│       │   └── altro_coming_soon.dart
│       │
│       ├── anfragen/                - Requests management
│       │   ├── anfragen_dashboard.dart
│       │   ├── anfragen_list.dart
│       │   └── anfragen_detail.dart
│       │
│       └── shared/                  - Shared components
│           ├── home/
│           │   ├── home_screen.dart
│           │   ├── home_shell.dart
│           │   ├── home_start.dart
│           │   └── quick_start.dart
│           ├── wizard/
│           │   ├── wizard_state.dart
│           │   ├── wizard_shell.dart
│           │   └── steps/
│           │       ├── step_addresses.dart
│           │       ├── step_contact.dart
│           │       ├── step_contact_addresses.dart
│           │       ├── step_home.dart
│           │       ├── step_inventory.dart
│           │       ├── step_price_type.dart
│           │       ├── step_service.dart
│           │       ├── step_summary.dart
│           │       └── step_tech.dart
│           └── splash_screen.dart
└── utils/                   - General utilities (share, PDF, etc.)
```

## Service-Based Organization
- **Entrümpelung** - Clearing/junk removal service flow
- **Umzug** - Moving service flow
- **Transport** - Transport service flow (placeholder)
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
- 2026-01-08: Renamed all files with logical naming convention (service_purpose.dart)
- 2026-01-08: Reorganized subfolders to match parent folder naming
- 2026-01-08: Restructured wizard sections to steps/
- 2026-01-08: Configured for Replit environment with SDK ^3.8.0
- 2026-01-08: Set up static file serving workflow on port 5000
