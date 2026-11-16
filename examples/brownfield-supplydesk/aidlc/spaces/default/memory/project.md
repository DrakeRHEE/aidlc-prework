# Project-Level Rules

> Project-specific specialisation and corrections. Loaded after `org.md` and
> `team.md` as strict-additive guidance.
> Populated by practices-discovery and the self-learning loop.
>
> Use sparingly: most teams don't need a project layer. Reach for it
> only when this specific project needs stable, durable guidance beyond the
> team practice (for example, package-specific release checks or an additional
> regression suite for a legacy component).

## Way of Working

<!-- Project-specific specialisation. Example: -->
<!-- This monorepo requires package-scoped branch names and a package owner -->
<!-- review in addition to the team's normal merge policy. -->
<!-- A project that merges into another branch than team.md names says so on its own line, read before team.md's: -->
<!-- - **Integration branch**: develop -->

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
- TypeScript 5.6 (strict, ESM), Node.js >= 20, Express 4, Zod 3, pg 8 (수기 SQL), Vitest 2 + supertest (변경 금지)
- 날짜/시간은 외부 라이브러리 없이 표준 `Date` + `Intl.DateTimeFormat`(`Asia/Seoul`)만 사용

## Decided

<!-- Decisions made in earlier stages that should not be re-asked. -->
<!-- Format: DECIDED: [decision] (Stage [slug], [date]) -->

## Scope Overrides

<!-- Custom scope rules for this project. -->

## Forbidden

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: - NEVER [behavior] (affirmed [date]) -->
<!-- Example: - NEVER throw exceptions across service layer boundaries (affirmed 2026-05-17) -->
- NEVER `src/legacy/erp/**`를 수정하지 않는다. 재무팀 소유이며 변경은 재무팀에 요청한다 (affirmed 2026-11-16)
- NEVER `requests.status` 값 집합(`pending`/`approved`/`rejected`)을 바꾸거나 새 상태를 추가하지 않는다. ERP 야간 배치가 `status='approved' AND erp_sent_at IS NULL`을 읽으므로 깨진다 (affirmed 2026-11-16)
- NEVER `migrations/001_init.sql`, `migrations/002_erp_sent.sql`과 `requests`, `items`의 기존 컬럼을 변경·삭제하지 않는다. 운영 DB에 적용됨. 새 `migrations/003_*.sql`로 추가만 한다 (affirmed 2026-11-16)
- NEVER `src/middleware/auth.ts`와 게이트웨이 헤더 계약(`X-Employee-Id`, `X-Employee-Role`, `X-Team-Id`)을 변경하지 않는다 (affirmed 2026-11-16)
- NEVER 기존 5개 API의 요청/응답 형식을 변경·삭제하지 않는다. `POST /requests`에 예산 초과 오류 코드 하나를 추가하는 것만 허용 (affirmed 2026-11-16)

## Mandated

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: - ALWAYS [behavior] (affirmed [date]) -->
<!-- Example: - ALWAYS use Result<T,E> for fallible operations in service layer (affirmed 2026-05-17) -->
- ALWAYS 팀 단위 데이터(예산, 잔액, 신청)는 서버에서 `req.employee.teamId`로 범위를 제한하고, 클라이언트가 보낸 팀 ID는 믿지 않는다 (affirmed 2026-11-16)
- ALWAYS 금액은 원 단위 `INTEGER`/정수 `number`로 다루고, 예산 초과는 신청을 접수하지 않고 4xx로 응답한다. 합계가 한도와 같으면 접수한다 (affirmed 2026-11-16)

## Corrections

<!-- Project-specific corrections from human feedback. -->
<!-- Format: NEVER/ALWAYS [behavior] (learned [date]) -->
