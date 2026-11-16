# Technical Environment: SupplyDesk

## Project Technical Summary

- **Project type**: Existing codebase (SupplyDesk 1.4.2, 사내 비품 신청 API)
- **Runtime environment**: Local only (로컬 실행과 테스트만. 운영 배포는 이번 범위 밖)
- **Team size and key skills**: 3명. TypeScript/Node.js API, PostgreSQL 경험

## Language

| Language | Version | Purpose |
|----------|---------|---------|
| TypeScript | 5.6.x (`strict`, ESM, `module: NodeNext`) | 애플리케이션 전체 (`src/`, `tests/`) |
| Node.js | >=20 (개발 PC: v26.13.0) | 런타임. 개발 실행은 `tsx` |
| SQL (PostgreSQL) | PostgreSQL 16 | `migrations/*.sql` 스키마 변경, `repositories/`의 쿼리 |
| JavaScript (CommonJS) | - | `src/legacy/erp/` 만. 새 코드에는 쓰지 않는다 |

## Package Manager

- npm 11.x (`package-lock.json` 기준). 새 런타임 의존성은 추가하지 않는다. 꼭 필요하면 이유를 산출물에 적고 사람의 승인을 받는다

## Framework

| Framework or library | Version | Area |
|----------------------|---------|------|
| Express | 4.21.x | HTTP API (`src/routes/`, `src/app.ts`) |
| Zod | 3.23.x | 요청 본문 검증 (라우터에서 `safeParse`) |
| pg | 8.13.x | PostgreSQL 접근. SQL은 `src/repositories/`에만 둔다 |
| pino | 9.5.x | 로깅 |
| tsx | 4.19.x | 개발 서버 (`npm run dev`) |

- **Data store**: PostgreSQL 16 (`docker compose up -d db`, 127.0.0.1:5432). ORM 없음. 스키마는 `migrations/NNN_name.sql` 번호 순서로 추가한다
- **계층 규칙**: `routes/`(얇게, Zod 파싱과 상태 코드 매핑만) → `services/`(비즈니스 로직, 실패는 `Result<T>`로 반환) → `repositories/`(SQL과 `pool.query`만)

## Cloud and Deployment

- local only. `npm run dev`로 http://127.0.0.1:3000 에서 실행하고 `npm test`로 검증한다. 클라우드 배포, IaC는 이번 범위에 없다
- 주의: `npm run migrate`가 가리키는 `scripts/migrate.js`가 현재 저장소에 없다. 새 마이그레이션(003) 적용 방법은 워크플로 초반에 정한다(예: `psql`로 직접 적용)
- 주의: `docker-compose.yml`은 `POSTGRES_PASSWORD`를 요구하지만 `.env.example`에는 없다. 로컬 `.env`에 직접 넣는다(커밋 금지)

## Testing

| Test type | Required | Target | Tooling |
|-----------|----------|--------|---------|
| Unit | Yes | `services/`의 예산 한도 계산 로직(합계, 비교, 남은 금액, KST 월 경계) | Vitest 2.1.x |
| Integration | Yes | 라우트 HTTP 흐름 1~2개: 예산 초과 거부, 팀장 잔액 조회 | Vitest + supertest 7, 리포지토리는 `vi.mock`으로 대체 |

- **Test location**: `tests/` 폴더, 소스 구조를 그대로 따른다 (`tests/routes/`, `tests/services/`)
- **Rules**: 테스트는 실제 DB 없이 돌아야 한다. 기존 테스트는 모두 통과를 유지한다. 테스트 이름은 기존처럼 한국어 문장으로 쓴다. 날짜 의존 로직은 "현재 시각"을 주입해서 테스트한다

## Prohibited

| Prohibited | Reason | Use instead |
|------------|--------|-------------|
| `moment` | 유지보수 종료된 라이브러리. `src/legacy/erp/`에만 남아 있는 레거시 패턴 | 표준 `Date` + `Intl.DateTimeFormat`(`timeZone: "Asia/Seoul"`)으로 KST 월 경계 계산. 날짜 라이브러리는 추가하지 않는다 |
| `routes/` 또는 `services/`에서 직접 SQL 작성, `pool` 임포트 | 계층 규칙 위반. SQL은 리포지토리에만 모아 테스트에서 `vi.mock`으로 대체할 수 있어야 한다 | `src/repositories/*.ts`에 함수를 추가하고 서비스에서 호출 |
| `requests.status`에 새 값 추가(예: `budget_rejected`) | ERP 야간 배치가 `status` 값을 읽으므로 재무팀 배치가 깨진다 | 예산 초과는 신청 행을 만들지 않고 HTTP 오류 응답으로만 처리 |
| 기존 마이그레이션 `001`, `002` 수정 | 운영 DB에 이미 적용됨 | 새 번호 `003_*.sql` 파일 추가 |
| CommonJS(`require`, `module.exports`)로 새 파일 작성 | 프로젝트는 ESM(`"type": "module"`). 혼용하면 임포트 오류 | `import`/`export`, 상대 경로는 `.js` 확장자 포함 |
| `any` 타입, `@ts-ignore` | `strict` 설정 우회. 도메인 타입이 깨진다 | 명시적 인터페이스(`RequestRow` 참고), `unknown` + 좁히기 |
| 코드나 테스트에 접속 문자열·비밀번호 하드코딩 | 비밀 유출 | `process.env.DATABASE_URL`, `.env`(gitignore), 커밋은 `.env.example`만 |

## Security

- **Sign-in**: 없음. 사내 게이트웨이가 검증해 넣어 주는 헤더 `X-Employee-Id`, `X-Employee-Role`(employee/manager), `X-Team-Id`를 `src/middleware/auth.ts`가 해석한다. 이 서비스는 게이트웨이 뒤에서만 동작하며, 새 역할 추가는 금지
- **Authorization**: 팀장 잔액 조회는 `role === "manager"`이고 `req.employee.teamId`의 팀만 조회한다. 팀 ID는 요청 본문이나 쿼리가 아니라 항상 `req.employee.teamId`에서 가져온다
- **Input validation**: 모든 요청 본문은 라우터에서 Zod 스키마로 `safeParse`하고 실패 시 `400 { error: "INVALID_INPUT", details }`
- **Secrets**: `DATABASE_URL` 등은 `.env`에 보관(gitignore). 저장소에는 `.env.example`만 커밋. 코드, 테스트, 문서에 실제 비밀값 금지
- **Errors**: 클라이언트 오류는 `{ error: "UPPER_SNAKE_CODE", ...추가 필드 }` 형식. 예산 초과 응답도 같은 형식에 남은 금액 필드를 더한다

## Example Code

### Endpoint

모든 API endpoint는 `src/routes/requests.ts` 패턴을 따른다: Zod `safeParse` → 서비스 호출 → `Result`의 `status`/`error`를 그대로 HTTP로 매핑, 예외는 `next(e)`.

```ts
// src/routes/requests.ts (발췌)
requestsRouter.post("/:id/approve", async (req, res, next) => {
  try {
    const result = await service.decide(req.employee!, Number(req.params.id), "approved");
    if (!result.ok) return res.status(result.status).json({ error: result.error });
    res.json(result.value);
  } catch (e) { next(e); }
});
```

### Function

비즈니스 로직은 `src/services/requestService.ts` 패턴을 따른다: 권한·상태 검사를 먼저 하고 실패는 `Result<T>`로 반환, DB 접근은 리포지토리 함수 호출.

```ts
// src/services/requestService.ts (발췌)
export type Result<T> = { ok: true; value: T } | { ok: false; status: number; error: string };

export async function decide(emp: Employee, id: number, decision: "approved" | "rejected"): Promise<Result<repo.RequestRow>> {
  if (emp.role !== "manager") return { ok: false, status: 403, error: "MANAGER_ONLY" };
  const row = await repo.findById(id);
  if (!row) return { ok: false, status: 404, error: "NOT_FOUND" };
  if (row.team_id !== emp.teamId) return { ok: false, status: 403, error: "OTHER_TEAM" };
  if (row.status !== "pending") return { ok: false, status: 409, error: "ALREADY_DECIDED" };
  return { ok: true, value: await repo.updateStatus(id, decision, emp.id) };
}
```

DB 접근은 `src/repositories/requestRepository.ts` 패턴(파라미터 바인딩 `$1`, 결과 타입 `pool.query<Row>`)을 따른다.

### Test

테스트는 `tests/routes/requests.test.ts` 패턴을 따른다: 리포지토리 모듈을 `vi.mock`으로 대체하고 `supertest`로 `createApp()`을 호출, 헤더로 역할을 지정.

```ts
// tests/routes/requests.test.ts (발췌)
vi.mock("../../src/repositories/requestRepository.js", () => ({
  findById: vi.fn(), updateStatus: vi.fn(), insertRequest: vi.fn(), findByEmployee: vi.fn(),
}));
const manager = { "X-Employee-Id": "m1", "X-Employee-Role": "manager", "X-Team-Id": "t1" };

it("다른 팀 건은 403", async () => {
  vi.mocked(repo.findById).mockResolvedValue({ id: 2, team_id: "t9", status: "pending" } as never);
  const res = await request(createApp()).post("/requests/2/approve").set(manager);
  expect(res.status).toBe(403);
});
```

## Never Changes

- `src/legacy/erp/**` — 재무팀 소유. 읽기만 가능. 변경은 finance-platform과 협의 후 재무팀이 한다
- `requests` 테이블의 `status` 값 집합(`pending` / `approved` / `rejected`)과 의미, `erp_sent_at` 컬럼 의미 — ERP 야간 배치 계약
- 적용된 마이그레이션 파일(`migrations/001_init.sql`, `002_erp_sent.sql`) — 운영 DB 적용 완료
- `src/middleware/auth.ts`와 게이트웨이 헤더 계약 — 인증은 게이트웨이 책임
- 기존 5개 API의 경로와 응답 형식
- 계층 구조 `routes → services → repositories`와 "SQL은 repositories에만" 규칙
