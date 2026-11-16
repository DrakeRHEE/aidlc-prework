# Project-Level Rules

> Project-specific specialisation and corrections. Loaded after `org.md` and
> `team.md` as strict-additive guidance; contradictions with broader policy
> are rejected. Populated by practices-discovery and the self-learning loop.
>
> Use sparingly: most teams don't need a project layer. Reach for it
> only when this specific project needs stable, durable guidance beyond the
> team practice (for example, package-specific release checks or an additional
> regression suite for a legacy component).

## Way of Working

<!-- Project-specific specialisation. Example: -->
<!-- This monorepo requires package-scoped branch names and a package owner -->
<!-- review in addition to the team's normal merge policy. -->

## Walking Skeleton

<!-- Project-specific specialisation. Example: -->
<!-- The walking skeleton must exercise the legacy service adapter as well -->
<!-- as the new service boundary. -->

## Testing Posture

<!-- Project-specific specialisation. -->

## Guard Policy

<!-- Project-specific. Mode: strict, relaxed, or off. Strict here holds for every intent, whatever one person asks in chat; relaxed or off here applies to every intent whose policy came from its scope, unless the person sets another; changing this line changes it. A section under the retired Change Control heading, written by an earlier release, is still read. -->

## Deployment

<!-- Project-specific specialisation. -->

## Code Style

<!-- Project-specific specialisation. -->

## Tech Stack

<!-- Technology choices locked for this project. -->
- Python 3.12, uv, FastAPI, Jinja2 서버 렌더링 + HTML 폼, SQLAlchemy 2.0, SQLite, pytest (변경 금지)

## Decided

<!-- Decisions made in earlier stages that should not be re-asked. -->
<!-- Format: DECIDED: [decision] (Stage [slug], [date]) -->

## Scope Overrides

<!-- Custom scope rules for this project. -->

## Forbidden

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: NEVER [behavior] (affirmed [date]) -->
<!-- Example: NEVER throw exceptions across service layer boundaries (affirmed 2026-05-17) -->
- NEVER React, Vue 등 JavaScript 프레임워크나 npm 빌드 도구 추가 — Jinja2 템플릿과 HTML 폼 사용 (affirmed 2026-11-16)
- NEVER `pip install` 직접 실행이나 수동 `requirements.txt` 관리 — `uv add`와 `uv.lock` 사용 (affirmed 2026-11-16)
- NEVER 문자열로 조립한 SQL — SQLAlchemy `select()`와 바인드 파라미터 사용 (affirmed 2026-11-16)
- NEVER 코드에 비밀값 하드코딩 또는 `.env` 파일 커밋 — 환경변수와 `.env.example` 사용 (affirmed 2026-11-16)
- NEVER 외부 저장소나 외부 알림 API 호출 (S3, 알림톡 등) — local only, 로컬 `uploads/` 폴더 사용 (affirmed 2026-11-16)

## Mandated

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: ALWAYS [behavior] (affirmed [date]) -->
<!-- Example: ALWAYS use Result<T,E> for fallible operations in service layer (affirmed 2026-05-17) -->
- ALWAYS 점주 요청은 서버에서 `store_id`를 검사해 자기 매장 데이터만 조회하고 수정하게 함 (affirmed 2026-11-16)

## Corrections

<!-- Project-specific corrections from human feedback. -->
<!-- Format: NEVER/ALWAYS [behavior] (learned [date]) -->
