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
- TypeScript 5.6 (strict, ESM), Node.js >=20, Express 4, Zod 3, pg 8 + PostgreSQL 16, Vitest 2 + supertest (변경 금지. 새 런타임 의존성은 추가하지 않는다)

## Decided

<!-- Decisions made in earlier stages that should not be re-asked. -->
<!-- Format: DECIDED: [decision] (Stage [slug], [date]) -->

## Scope Overrides

<!-- Custom scope rules for this project. -->

## Forbidden

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: NEVER [behavior] (affirmed [date]) -->
<!-- Example: NEVER throw exceptions across service layer boundaries (affirmed 2026-05-17) -->
- NEVER `src/legacy/erp/**` 아래 파일을 수정한다. 재무팀 소유다 (affirmed 2026-11-16)
- NEVER `requests.status` 값 집합(`pending`/`approved`/`rejected`)에 새 값을 추가하거나 의미를 바꾸고, `erp_sent_at` 컬럼 의미를 바꾼다. ERP 야간 배치가 깨진다 (affirmed 2026-11-16)
- NEVER 이미 적용된 마이그레이션 `migrations/001_init.sql`, `002_erp_sent.sql`을 수정한다. 스키마 변경은 새 번호 파일로만 추가한다 (affirmed 2026-11-16)
- NEVER `src/middleware/auth.ts`와 게이트웨이 헤더 계약을 수정하거나 새 역할을 추가한다 (affirmed 2026-11-16)
- NEVER `routes/`나 `services/`에서 SQL을 쓰거나 `pool`을 임포트한다. SQL은 `src/repositories/`에만 둔다 (affirmed 2026-11-16)
- NEVER `moment`를 새 코드에 쓴다. 표준 `Date` + `Intl.DateTimeFormat`(`Asia/Seoul`)을 쓴다 (affirmed 2026-11-16)
- NEVER 비밀값이나 `.env` 파일을 커밋한다. `.env.example`만 커밋한다 (affirmed 2026-11-16)

## Mandated

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: ALWAYS [behavior] (affirmed [date]) -->
<!-- Example: ALWAYS use Result<T,E> for fallible operations in service layer (affirmed 2026-05-17) -->
- ALWAYS 예산 초과 거부는 신청 행을 만들지 않고 HTTP 오류 응답으로만 처리한다 (affirmed 2026-11-16)
- ALWAYS 팀 예산 조회와 한도 검사의 팀 ID는 요청 본문이나 쿼리가 아닌 `req.employee.teamId`에서 가져오고, 팀장은 자기 팀만 조회한다 (affirmed 2026-11-16)
- ALWAYS 예산 기준 월은 한국 시간(Asia/Seoul) 1일~말일로 계산한다 (affirmed 2026-11-16)

## Corrections

<!-- Project-specific corrections from human feedback. -->
<!-- Format: NEVER/ALWAYS [behavior] (learned [date]) -->
