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

### Supabase 인증 및 RLS
- 익명 인증으로 간편한 사용자 경험 제공
- Row-Level Security 정책으로 사용자 데이터 보호

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

## 참고 문서

- **PRD (Product Requirements Document)**: `docs/PRD.md`
- **디자인 가이드**: `docs/DESIGN.md`
- **개발 가이드**: `CLAUDE.md` - Claude Code 사용 시 참고
