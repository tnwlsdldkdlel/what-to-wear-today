# Product Requirements Document (PRD): What to Wear Today?

## 1. Introduction and Goals

| Component        | Detail                                                                                                                                                               |
| :--------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Product Name** | What to Wear Today? (오늘 뭐 입음?)                                                                                                                                  |
| **Purpose**      | Reduce the time users spend deciding what to wear by providing **real-time, hyper-local, data-driven clothing recommendations**.                                     |
| **Key Value**    | Leveraging **actual, anonymized clothing data** submitted by users in the immediate vicinity to offer a more practical dressing guide than simple weather forecasts. |
| **MVP Goal**     | Validate the core loop: User Submission -> Data Processing -> Local Recommendation.                                                                                  |

## 2. Core Features and Data Structure

### 2.1 User Data Contribution (The "What I Wore" Submission)

- **Goal:** Collect real-time, hyper-local clothing data.
- **Data Fields to Collect:**
  - **Location:** GPS-based geographic area (e.g., Gu/District).
  - **Worn Items:** Categorical selection (Tops, Bottoms, Outerwear, Shoes, Accessories).
- **Design Requirement:** Selection UI must utilize **cute emoji icons** alongside text for each item to enhance visual appeal and submission speed.

### 2.2 Data Processing Logic

- **Core Recommendation Algorithm:** The recommendation is based on real-time, hyper-local clothing data aggregation.
- **Filtering:** All submitted data points in the local area will be utilized for generating the recommendation.
- **Output:** The recommendation (Local Outfit Summary) will be the set of the **most frequently chosen** items, presented with their calculated **probability**.

## 3. User Interface (UI) and Experience (UX) - MVP Scope

### 3.1 Home Screen (Recommendation View)

- **Key Elements (Top-Down Priority):**
  1.  **Current Weather & Temperature:** Display of the current temperature and an associated weather icon.
  2.  **Local Outfit Summary (Core Recommendation):** A clear, concise sentence summarizing the most frequently worn items from submissions in the current area.
  3.  **Location Display:** Shows the user's **current location (GPS-based)**.

### 3.2 Onboarding Flow

- **Mandatory Location Permission:** Upon first launch, the app must immediately explain the need for hyper-local location data and request consent. **Permission is mandatory for core functionality.**

## 4. Technical Requirements and Stack

| Component           | Stack/Tool               | Detail                                                               |
| :------------------ | :----------------------- | :------------------------------------------------------------------- |
| **Frontend**        | **Flutter (Dart, GetX)** | Cross-platform development with GetX for reactive state management.  |
| **Database / BaaS** | **Supabase**             | Used for PostgreSQL database, Authentication, and Realtime features. |
| **Deployment**      | **Vercel**               | Deployment platform (for web/PWA or serverless functions).           |
| **3rd Party API**   | (TBD)                    | Required for real-time weather and temperature data.                 |

## 5. API Specification: GET /recommendation/local

This is the primary API for retrieving the hyper-local, data-driven clothing recommendation.

| Component                      | Detail                                                                                                                                                        |
| :----------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Input (Request Parameters)** | `latitude`, `longitude` (Required for MVP - Current location only)                                                                                            |
| **Output (Response Body)**     | **Probability-based list** for `tops`, `bottoms`, `outerwear`, `shoes`, and `accessories`. Includes `recommendation_area`, `temperature`, and `weather_icon`. |

## 6. Development Guidelines & Pitfalls

### 6.1 State Management (GetX Focus)

- Use **Reactive State** (`Obx`, `Rx` variables) for frequently changing UI elements.
- Enforce **Controller Separation** (e.g., `HomeController`, `SubmissionController`) using the MVC pattern.
- Abstract network calls into a dedicated **Service Layer** (e.g., `RecommendationService`).

### 6.2 Security and Supabase

- **Row-Level Security (RLS):** Must be enabled on all data tables for security.
- **Authentication:** Use Supabase Auth to tie all submissions to a `user_id`, even for anonymous data aggregation.

## 7. Minimum Viable Product (MVP) Scope

| Status  | Feature                             | Notes                                               |
| :------ | :---------------------------------- | :-------------------------------------------------- |
| **IN**  | **Current Location Recommendation** | Core feature using GPS data only.                   |
| **IN**  | **User Data Input**                 | Selection-based input with Emojis.                  |
| **IN**  | **Current Weather Display**         | Real-time weather and temperature data integration. |
| **OUT** | Manual Location Search/Change       | Deferred to V1.1.                                   |
| **OUT** | Hourly Weather Forecast             | Deferred to V1.1.                                   |
| **OUT** | Gamification/Rewards                | Deferred, focus is on intrinsic value.              |
