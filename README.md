# 오늘 뭐 입음? (What to Wear Today?)

Flutter + Supabase 기반의 하이퍼로컬 착장 추천 앱입니다. 사용자가 지금 입은 옷과 체감 온도를 공유하면, 주변 지역의 데이터를 바탕으로 확률 기반 추천을 제공합니다.

## 주요 기능 (MVP)

### 착장 데이터 제출 플로우
SVG 기반의 직관적인 카드 UI로 빠르게 의상을 입력할 수 있습니다:
1. **상의 선택** (반팔티, 후드티, 긴팔티, 셔츠, 니트, 맨투맨)
2. **하의 선택** (긴바지, 반바지, 치마)
3. **아우터 선택** (후드집업, 가디건, 코트, 패딩) - 선택 사항
4. **신발 선택** (운동화, 장화, 샌들, 어그부츠)
5. **악세서리 선택** (목도리, 모자, 우산, 장갑) - 복수 선택 가능
6. **제출 전 확인** - 선택한 착장을 이미지와 함께 확인
7. 데이터는 Supabase에 저장되어 추천 알고리즘에 활용됩니다.

### 홈 추천 화면
- 현재 위치 기반으로 날씨 및 온도 정보 표시
- Open-Meteo API를 통한 실시간 날씨 데이터 수집
- 온도에 따른 착장 추천 제공 (향후 실제 사용자 데이터 기반으로 개선 예정)

### 위치 선택

**GPS 위치와 수동 지역 선택**

사용자는 현재 GPS 위치 또는 한국 전역의 시/도 중 원하는 지역을 선택하여 날씨 및 추천 정보를 확인할 수 있습니다.

**프로세스**

1. **위치 선택 UI 진입**
   - 홈 화면 AppBar의 지역명을 탭하면 위치 선택 바텀시트가 표시됩니다
   - 현재 선택된 지역명 옆에 드롭다운 아이콘(▼)이 표시되어 선택 가능함을 나타냅니다

2. **위치 선택 바텀시트 구성**
   - **검색창**: 시/도 이름으로 실시간 필터링 가능
   - **현재 위치 옵션**: GPS 기반 위치로 복원 (파란색 하이라이트)
   - **전체 지역 목록**: 한국의 17개 광역시/도 목록 표시

3. **지역 선택 동작**
   - 특정 지역 선택 시:
     - `HomeController.selectRegion(CityRegion)` 호출
     - 해당 지역의 대표 좌표로 날씨 정보 재조회
     - 바텀시트 자동 닫힘
   - 현재 위치 선택 시:
     - `HomeController.useCurrentLocation()` 호출
     - GPS 권한 확인 후 현재 위치로 날씨 정보 재조회
     - 바텀시트 자동 닫힘

4. **상태 관리**
   - `selectedRegion`: 현재 선택된 지역 정보 (null이면 GPS 위치 사용)
   - 지역 변경 시 `fetchRecommendation()` 자동 실행
   - 선택된 지역명이 AppBar 타이틀에 반영됨

**데이터 구조**

```dart
class CityRegion {
  final String name;        // 지역명 (예: '서울특별시')
  final double latitude;    // 대표 위도
  final double longitude;   // 대표 경도
}
```

**지원 지역 (17개)**
- 서울특별시, 부산광역시, 대구광역시, 인천광역시
- 광주광역시, 대전광역시, 울산광역시, 세종특별자치시
- 경기도, 강원특별자치도, 충청북도, 충청남도
- 전북특별자치도, 전라남도, 경상북도, 경상남도, 제주특별자치도

### Supabase 인증 및 RLS
- 익명 인증으로 간편한 사용자 경험 제공
- Row-Level Security 정책으로 사용자 데이터 보호

### 알림 설정

**로컬 알림 기반 구현**

매일 지정한 시간에 날씨와 추천 착장을 알려주는 로컬 푸시 알림을 제공합니다.

**왜 로컬 알림을 선택했나요?**
- **간편함**: FCM/APNS 같은 원격 푸시 서비스 설정이 불필요
- **비용 절감**: 외부 푸시 서비스 인프라 불필요
- **개인정보 보호**: 푸시 토큰을 외부 서버에 전송할 필요 없음
- **충분한 기능**: 매일 정해진 시간에 알림을 보내는 단순한 요구사항에 적합

**핵심 설계 결정**

1. **device_id를 primary identifier로 사용**
   - 익명 인증 방식이므로 user_id가 불안정할 수 있음
   - 기기별로 고유한 알림 설정 관리 가능
   - device_tokens 테이블에서 `device_id` 컬럼이 unique NOT NULL로 설정됨

2. **Supabase를 단일 진실 소스(Single Source of Truth)로 사용**
   - 알림 설정은 Supabase `device_tokens` 테이블에 저장
   - SharedPreferences는 로컬 캐싱 용도로만 사용
   - `loadSettings()` 시 Supabase 우선 조회 → 없으면 기본값(off) 반환

3. **데이터 흐름**
   ```
   사용자 설정 변경
   → NotificationService.saveSettings()
   → Supabase device_tokens 테이블 upsert (onConflict: device_id)
   → SharedPreferences 동기화
   → flutter_local_notifications로 스케줄링
   ```

**기술 스택**
- `flutter_local_notifications` - 로컬 푸시 알림 스케줄링
- `timezone` - 한국 시간대(Asia/Seoul) 기반 스케줄링
- Supabase `device_tokens` 테이블 - 알림 설정 영구 저장

## 기술 스택

- **Flutter 3** + GetX 상태관리 (MVC 패턴)
- **Supabase** (PostgreSQL, Auth, Realtime)
- **flutter_svg** - SVG 이미지 렌더링으로 최적화된 UI 제공
- **Open-Meteo API** - 실시간 날씨 데이터 수집 (API 키 불필요)
- **Geolocator/Geocoding** - 위치 권한 및 역지오코딩 처리
- **flutter_dotenv** - 환경 변수 관리

## 개발 환경 설정

### 1. 환경 변수 설정
```bash
cp .env.example .env
```
`.env` 파일에 다음 값을 설정하세요:
- `SUPABASE_URL` - Supabase 프로젝트 URL
- `SUPABASE_ANON_KEY` - Supabase 익명 키

### 2. Flutter 의존성 설치
```bash
flutter pub get
```

### 3. Supabase 데이터베이스 정책 적용
```bash
psql -h <supabase-host> -U <user> -d <database> -f supabase/policies.sql
```

### 4. 앱 실행
```bash
# 기본 디바이스에서 실행
flutter run

# 특정 디바이스에서 실행
flutter devices  # 디바이스 목록 확인
flutter run -d <device-id>
```

### 5. 코드 품질 관리
```bash
# 린트 검사
flutter analyze

# 코드 포맷팅
flutter format .

# 테스트 실행
flutter test
```

## 프로젝트 구조

```
lib/
├── app/                    # 앱 레벨 설정
│   ├── routes/            # 라우팅 정의
│   └── themes/            # 테마 및 색상 시스템
├── core/                  # 공통 비즈니스 로직
│   ├── config/           # 환경 변수 관리
│   ├── models/           # 데이터 모델
│   └── services/         # 외부 API 서비스
└── features/             # 기능별 모듈
    ├── home/            # 홈 및 추천 화면
    └── submission/      # 착장 제출 플로우
```

## 회고

**📝 [프로젝트 회고 보기](RETROSPECTIVE.md)**

이 프로젝트는 Claude AI를 활용한 바이브코딩으로 진행되었습니다. 하루 만에 완성하는 다른 프로젝트들과 달리, **사용자 경험(UX)을 깊이 고민하며 시간을 들여 개발**했습니다.

### 주요 학습 내용

- **마이크로 인터랙션**: 착장 선택 시 0.3초 딜레이로 사용자 피드백 제공
- **UX 설계**: 시각적 위계를 통한 데이터 수집 유도 (FilledButton vs TextButton)
- **기술 선택**: 로컬 알림으로 간편함과 개인정보 보호 양립
- **아키텍처**: GetX MVC 패턴과 Service 레이어 분리로 유지보수성 확보

### 기술 스택 선택 이유

| 기술 | 선택 이유 |
|------|----------|
| Flutter + GetX | 크로스 플랫폼 개발, 간결한 상태 관리 |
| Supabase | PostgreSQL 기반 BaaS, RLS 보안, 무료 티어 |
| flutter_local_notifications | 원격 푸시 불필요, 개인정보 보호 |

더 자세한 내용은 [프로젝트 회고 문서](RETROSPECTIVE.md)를 참고하세요.

## 참고 문서

- **PRD (Product Requirements Document)**: `docs/PRD.md`
- **디자인 가이드**: `docs/DESIGN.md`
- **개발 가이드**: `CLAUDE.md` - Claude Code 사용 시 참고
- **프로젝트 회고**: `RETROSPECTIVE.md` - 프로젝트 개발 과정, 배운 점, 개선 사항 등을 정리한 회고 문서
