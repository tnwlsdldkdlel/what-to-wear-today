# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Guidelines

- If requirements are ambiguous or conflicting, do not write code immediately. Ask for clarification first.
- Always include an "Uncertainty Map" block at the end of every response, containing:
  - The most uncertain points
  - Potential oversimplifications
  - Additional questions that could change the answer
- Always respond in Korean.
- If request history is unclear, check the `__prompts` folder first to find connections with previous work. If still unclear, ask the user for clarification.

## Required Guidelines

- Record each request in `__prompts/_task` with the format `YYYY-MM-DD_brief-task-title_###.md`, incrementing from the latest number. Include the request content and actual changes made.
- Before starting work, create a file in `__prompts/_plan` following the same naming convention. Document the task overview, plan, process, and execution results in order.

## Project Overview

"What to Wear Today?" (오늘 뭐 입음?) is a Flutter + Supabase hyper-local outfit recommendation app. Users submit their current outfit and comfort level, and the app provides data-driven clothing recommendations based on actual submissions from nearby users who reported feeling "just right" at similar temperatures.

## Development Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Copy environment template and configure
cp .env.example .env
# Edit .env with your SUPABASE_URL and SUPABASE_ANON_KEY

# Apply Supabase database policies (requires psql)
psql -h <supabase-host> -U <user> -d <database> -f supabase/policies.sql
```

### Running the App
```bash
# Run on default device
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

### Code Quality
```bash
# Run linter
flutter analyze

# Format code
flutter format .

# Run tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Build
```bash
# Build APK (Android)
flutter build apk

# Build iOS
flutter build ios
```

## Architecture

### State Management: GetX Pattern

The app follows GetX MVC architecture with strict separation of concerns:

- **Controllers**: Manage state and business logic (e.g., `HomeController`, `SubmissionController`)
- **Bindings**: Dependency injection setup for each route (e.g., `HomeBinding`, `SubmissionBinding`)
- **Views**: Pure UI components that observe reactive state via `Obx()` widgets
- **Services**: Abstract external dependencies and API calls (in `lib/core/services/`)

### Core Data Flow

1. **Location → Weather → Recommendation**:
   - `LocationService` (lib/core/services/location_service.dart) gets GPS position and reverse geocodes to area name
   - `RecommendationService` (lib/core/services/recommendation_service.dart) fetches current weather from Open-Meteo API
   - Temperature-based outfit suggestions are generated client-side in `_buildOutfitSuggestions()`

2. **User Submission Flow**:
   - Multi-step form: Top → Bottom → Outer (optional) → Shoes → Accessories (multi-select, optional) → Comfort → Review
   - Each step is a separate route with shared `SubmissionBinding`
   - State managed in `SubmissionController` using reactive `Rx` variables
   - Automatic navigation between steps on selection (via `Get.toNamed()`)
   - Final submission requires auth session, location permission, and accumulated form data
   - Data submitted to Supabase via `SupabaseService` with userId from anonymous auth

### Key Directories

```
lib/
├── app/                    # App-level configuration
│   ├── routes/            # Route definitions and navigation
│   └── themes/            # AppTheme with design system colors
├── core/                  # Shared business logic
│   ├── config/           # Environment variable handling
│   ├── models/           # Data models (Recommendation, OutfitSubmission)
│   └── services/         # External API and data services
└── features/             # Feature modules
    ├── home/            # Home screen with recommendations
    └── submission/      # Multi-step outfit submission flow
```

### Services Layer

All network calls and external dependencies are abstracted into services:

- **AuthService**: Supabase anonymous authentication
- **LocationService**: GPS position and reverse geocoding (Geolocator + Geocoding packages)
- **RecommendationService**: Fetches weather from Open-Meteo and generates outfit suggestions
- **SupabaseService**: Database operations (currently only outfit submission inserts)

Controllers should never directly call external APIs—always go through a service.

## Environment Configuration

Environment variables are loaded from `.env` file (via `flutter_dotenv`) with fallback to `Platform.environment` for CI/CD:

- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Supabase anonymous public key

The `AppEnvironment` class (lib/core/config/environment.dart) handles reading and validation. Missing variables throw `StateError` at startup.

## Supabase Schema & RLS

Database table: `public.outfit_submissions`

Key columns:
- `user_id`: References `auth.users(id)`, required for RLS
- `latitude`, `longitude`: GPS coordinates
- `top`, `bottom`, `outerwear`, `shoes`: Text fields for clothing items
- `accessories`: Text array
- `comfort`: Enum ('hot', 'justRight', 'cold')
- `is_just_right`: Boolean flag computed from comfort field

Row-Level Security policies (defined in supabase/policies.sql):
- Users can INSERT their own submissions (`auth.uid() = user_id`)
- Users can SELECT all submissions for aggregated data (`using (true)`)

## Design System

Defined in `lib/app/themes/app_theme.dart` and documented in `docs/DESIGN.md`:

### Color Palette
- Primary: `#5C6BC0` (calm blue) - brand color
- Accent: `#FF8A65` (warm orange) - CTA buttons
- Comfort feedback colors:
  - Hot: `#EF5350` (red)
  - Just Right: `#66BB6A` (green) - core recommendation color
  - Cold: `#42A5F5` (sky blue)

### UI/UX Principles
- **Clarity**: Bold text, high contrast, immediate information
- **Locality**: Prominently display area name to build trust
- **Cheerfulness**: Emoji-based item selection, gentle color palette

## Navigation & Routes

Routes defined in `lib/app/routes/`:
- `AppRoutes.home`: Home screen with recommendations
- `AppRoutes.submissionTop/Bottom/Outer/Shoes/Accessories/Comfort/Review`: Multi-step submission flow

All submission routes use `Transition.cupertino` for iOS-style navigation.

## Testing

Currently minimal test coverage (only default widget_test.dart). When adding tests:
- Mock services using GetX dependency overrides
- Test controllers independently of UI
- Use `flutter test` for unit tests, `flutter test integration_test/` for integration tests (if added)

## Important Notes

- **Anonymous Authentication**: The app uses Supabase anonymous auth via `AuthService.ensureSession()`. Called automatically before outfit submission.
- **Weather Data**: Open-Meteo API requires no API key—it's free and open.
- **Recommendation Logic**: Currently client-side and temperature-based. Future versions should query aggregated Supabase data filtered by location and "just right" comfort level (see docs/PRD.md).
- **Location Permissions**: Mandatory for core functionality. Required both at home screen load (for recommendations) and at submission time (for GPS coordinates).
- **Optional vs Required Fields**: Tops, bottoms, shoes, and comfort are required. Outerwear and accessories are optional (can be skipped).

## Git Commit Convention

- **Language**: Commit messages should be written in Korean (title and body), while keeping the type prefix in English
- **Format**: `<type>: <Korean description>`
- **Examples**:
  - `feat: 사용자 프로필 화면 추가`
  - `fix: 로그인 오류 해결`
  - `chore: Claude Code 설정 추가`
  - `refactor: 홈 컨트롤러 코드 정리`
  - `docs: README 파일 업데이트`

## Documentation

- `docs/PRD.md`: Full product requirements, API specs, MVP scope
- `docs/DESIGN.md`: Complete design guide with color codes, typography, and UI/UX guidelines
- `docs/AGENTS.md`: (If present) Agent-specific documentation
- `README.md`: Korean-language project overview and setup instructions
