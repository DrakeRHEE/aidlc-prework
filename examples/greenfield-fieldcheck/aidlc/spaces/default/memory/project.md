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
- Python 3.12 (uv), FastAPI, Jinja2 서버 렌더링 HTML, SQLAlchemy 2.0 + SQLite, pytest (변경 금지)

## Decided

<!-- Decisions made in earlier stages that should not be re-asked. -->
<!-- Format: DECIDED: [decision] (Stage [slug], [date]) -->

## Scope Overrides

<!-- Custom scope rules for this project. -->

## Forbidden

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: - NEVER [behavior] (affirmed [date]) -->
<!-- Example: - NEVER throw exceptions across service layer boundaries (affirmed 2026-05-17) -->
- NEVER add JavaScript frameworks or build tools (React, Vue, npm 등); 화면은 Jinja2 템플릿과 HTML 폼으로 만든다 (affirmed 2026-11-16)
- NEVER decide authorization from client-supplied `store_id` or `user_id` (폼, 쿼리, 경로 값); 서버의 현재 사용자에서 읽는다 (affirmed 2026-11-16)
- NEVER commit secrets, `.env`, or the SQLite DB file (`fieldcheck.db`) (affirmed 2026-11-16)
- NEVER call external messaging APIs (카카오 알림톡 등) in this release; 조치 요청은 DB 레코드로만 만든다 (affirmed 2026-11-16)

## Mandated

<!-- Populated by practices-discovery affirmation gate. -->
<!-- Format: - ALWAYS [behavior] (affirmed [date]) -->
<!-- Example: - ALWAYS use Result<T,E> for fallible operations in service layer (affirmed 2026-05-17) -->
- ALWAYS check on the server that an owner reads and completes only their own store's action requests; 다른 매장 요청은 403으로 거부한다 (affirmed 2026-11-16)

## Corrections

<!-- Project-specific corrections from human feedback. -->
<!-- Format: NEVER/ALWAYS [behavior] (learned [date]) -->
