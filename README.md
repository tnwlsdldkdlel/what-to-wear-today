# 오늘 뭐 입음? (What to Wear Today?)

Flutter + Supabase 기반의 하이퍼로컬 착장 추천 앱입니다. 사용자가 지금 입은 옷과 체감 온도를 공유하면, 주변 지역의 데이터를 바탕으로 확률 기반 추천을 제공합니다.

## 주요 기능 (MVP)

- 착장 데이터 제출 플로우: 이모지 기반 UI로 빠르게 의상을 입력하고 Supabase에 저장.
- 홈 추천 화면: 현재 위치를 기반으로 GET `/recommendation/local` API를 호출하여 확률 기반 추천 문장, 날씨, 온도 표시.
- Supabase 인증 및 RLS: 익명 인증과 Row-Level Security 정책으로 사용자 데이터를 보호.

## 기술 스택

- Flutter 3 + GetX 상태관리
- Supabase (PostgreSQL, Auth, Realtime)
- HTTP 기반 외부 추천 API 연동
- Open-Meteo API를 통한 실시간 날씨 데이터 수집
- Geolocator/Geocoding을 통한 위치 권한 및 역지오코딩 처리

## 개발 환경 설정

1. 환경 변수 설정 (`.env` 또는 런치 스크립트)
   - `cp .env.example .env`로 예시 파일을 복사한 뒤 값을 채워 넣습니다.
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - 참고: `.env.example` 파일에 기본 키 목록이 포함되어 있으며, Open-Meteo API는 별도 키가 필요 없습니다.
2. Flutter 의존성 설치
   ```bash
   flutter pub get
   ```
3. Supabase 정책 적용
   ```sql
   \i supabase/policies.sql
   ```
4. 앱 실행
   ```bash
   flutter run
   ```

자세한 기능 요구 사항은 `docs/PRD.md`, 디자인 가이드는 `docs/DESIGN.md`를 참고하세요.
