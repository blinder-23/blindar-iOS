# blindar-iOS

# 기술 스택 및 설계 요약

## 프로젝트 개요

**대상 사용자 및 기능:**  
- 전국 맹학교의 학사 일정과 식단 정보를 제공
- 메모 기능
- 달력 모드, 하루씩 보기 모드 지원

## 기술 스택

- **SwiftUI:** 접근성 중심의 UI 구축.
- **SwiftData:** 로컬 데이터 관리 및 오프라인 기능 지원.
- **Combine:** 비동기 작업 처리와 데이터 바인딩, 메모리 관리 최적화.
- **Firebase:** 인증, 실시간 데이터베이스, Crashlytics 등 백엔드 통합.
- **MVVM 아키텍처:** 유지보수 및 테스트 용이성 강화.

## Apple의 Human Interface Guidelines 준수

### 1. 접근성

- **SwiftUI 접근성 지원:** 시각 장애인을 위한 VoiceOver 최적화.
- **다이내믹 타입:** 사용자의 텍스트 크기 및 탐색 선호도에 맞춘 자동 조정.

### 2. 시각 디자인 및 상호작용

- **일관된 UI 디자인:** Apple 가이드라인에 따른 일관성과 직관성 유지.
- **콘텐츠 중심:** 중요한 정보에 집중, 불필요한 요소 최소화.
- **단순 내비게이션:** 캘린더 모드와 원데이 모드 간 명확한 구분.

### 3. 성능 및 반응성

- **효율성 최적화:** Combine으로 비동기 작업의 지연 최소화.
- **리소스 관리:** Combine의 Cancellable을 활용한 비동기 작업과 리소스 할당으로 배터리 수명 연장과 성능 향상.

### 4. 사용자 중심 설계

- **개인화:** 사용자 학교 정보 로컬 저장, 설정 개인화.
- **오류 처리:** 명확한 작업 실패 피드백 제공.

## 아키텍처 및 의존성 개요

**코어 모듈:**
- **Feature 모듈(UI/UX):** SwiftUI와 MVVM 기반 주요 기능 구현.
- **Data 모듈(로컬 저장소):** SwiftData로 로컬 데이터 저장 및 검색 관리.
- **Core 모듈(유틸리티):** Firebase 통합, Combine을 통한 비동기 작업 처리.

## 참고 가이드 라인

- [api-design-guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- [human-interface-guidelines](https://developer.apple.com/design/human-interface-guidelines)
