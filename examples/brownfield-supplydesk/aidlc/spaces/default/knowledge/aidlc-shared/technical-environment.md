# Technical Environment: SupplyDesk

## Project Technical Summary

SupplyDesk는 Express 4 기반의 Node.js/TypeScript REST API로, PostgreSQL 16에 데이터를 저장한다.
사내 게이트웨이 뒤에서만 동작하며 인증은 게이트웨이가 넣어 주는 헤더를 읽어 처리한다.
구조는 `routes/`(얇은 라우터, Zod 입력 검증) → `services/`(비즈니스 로직, `Result<T>` 반환) →
`repositories/`(SQL은 여기에만) 3계층이다. `src/legacy/erp/`는 재무팀 소유의 CommonJS 모듈로
어떤 작업도 건드리지 않는다. 배포는 이 워크샵 범위에 없고 로컬 실행과 테스트만 한다.

## Language

- TypeScript 5.6.x, `strict: true`, ESM (`"type": "module"`, `module: NodeNext`)
- 상대 import는 `.js` 확장자를 붙인다 (예: `from "../services/requestService.js"`)
- Node.js >= 20 (`package.json engines`). 개발 PC는 v26.13.0
- 실행은 `tsx` (`npm run dev`), 빌드는 `tsc` (`npm run build`)

## Package Manager

- npm 11.x. 락파일은 `package-lock.json`
- 새 런타임 의존성 추가는 이번 작업에서 **원칙적으로 없음**. 필요하면 이유를 적고 사람 승인을 받는다

## Framework

- Express 4.21.x. 라우터는 `src/routes/`에 `Router()`로 만들고 `src/app.ts`의 `createApp()`에서 마운트한다
- 입력 검증: Zod 3.x. 라우터에서 `safeParse` 후 실패 시 `400 { error: "INVALID_INPUT", details }`
- 로깅: pino 9.x (설치되어 있음. `console.log`를 새로 추가하지 않는다)
- DB 접근: `pg` 8.x `Pool` (`src/repositories/db.ts`). 파라미터 바인딩(`$1, $2`) 필수
- 스키마 변경: `migrations/NNN_*.sql` 파일 추가 + `npm run migrate`. 이번 작업은 `003_*.sql`부터 시작
- 오류 응답 형식: `{ error: "UPPER_SNAKE_CODE", ...추가 필드 }`. 서비스 계층은 `Result<T>`로 상태 코드와 오류 코드를 돌려주고 라우터가 그대로 응답한다
- **날짜/시간(KST 월 계산)**: 외부 라이브러리 없이 표준 `Date` + `Intl.DateTimeFormat`(`timeZone: "Asia/Seoul"`)로 처리한다.
  DB 컬럼은 `TIMESTAMPTZ`를 유지하고, "이번 달" 범위는 서비스 계층에서 KST 1일 00:00:00 ~ 다음 달 1일 00:00:00(미포함)의 UTC 시각으로 변환해 SQL에 넘긴다

## Cloud and Deployment

- `local only`. 로컬 실행(`npm run dev`, `http://127.0.0.1:3000`)과 테스트만 한다
- DB는 `docker compose up -d db` (postgres:16, `127.0.0.1:5432`에만 바인딩)
- 운영 배포, 운영 DB 접근, CI 변경은 이번 범위에 없다

## Testing

- Vitest 2.x + supertest 7.x. `npm test` (`vitest run`)
- 테스트 위치: `tests/` 아래에 `src/` 구조를 미러링 (`tests/routes/*.test.ts`, `tests/services/*.test.ts`)
- 방식: 레포지토리 모듈을 `vi.mock`으로 대체하고 `createApp()`을 supertest로 호출. 실제 DB 없이 돈다
- 테스트 이름은 한국어 문장으로 쓴다 (예: `it("팀장은 자기 팀 대기 건을 승인한다", ...)`)
- 이번 작업 목표(Minimal): 예산 검사 로직 단위 테스트(초과/이내/경계값 동일/반려 건 제외/지난달 제외),
  KST 월 경계 계산 단위 테스트, `POST /requests` 예산 초과 통합 테스트 1개, 팀장 잔액 조회 통합 테스트 1개.
  기존 `tests/routes/requests.test.ts`는 그대로 통과해야 한다

## Prohibited

| 금지 대상 | 이유 | 대신 사용 |
|---|---|---|
| `moment`, `dayjs`, `date-fns`, `luxon` 등 날짜 라이브러리 추가 | 레거시 ERP 모듈만 `moment`를 쓰며 그 패턴을 따라가면 안 됨. 새 의존성 없이 해결 가능 | 표준 `Date` + `Intl.DateTimeFormat({ timeZone: "Asia/Seoul" })` |
| ORM / 쿼리 빌더(Prisma, TypeORM, Knex, Drizzle) 도입 | 기존 코드가 `pg` + 수기 SQL이며 레포지토리 계층이 이미 그 역할을 함 | `pg` `Pool.query` + 파라미터 바인딩, SQL은 `src/repositories/`에만 |
| `routes/`나 `services/`에서 직접 SQL 실행 | 3계층 구조가 깨지고 테스트에서 `vi.mock`으로 대체할 수 없음 | `src/repositories/*Repository.ts`에 함수를 추가하고 서비스에서 호출 |
| `any` 타입, `// @ts-ignore` | `strict` 모드 유지. 타입이 흐려지면 금액 계산 실수를 못 잡음 | 명시적 인터페이스(`RequestRow`처럼) 또는 Zod 스키마에서 `z.infer` |
| 금액을 `float`/`NUMERIC` 소수로 다루기 | 기존 `items.unit_price`가 `INTEGER`(원 단위). 소수 연산은 합계 오차를 만듦 | 원 단위 `INTEGER`, TypeScript `number` 정수. 새 금액 컬럼도 `INTEGER` |
| 기존 마이그레이션 파일 수정, `ALTER COLUMN`, `DROP` | 001, 002는 운영 DB에 적용됨 | 새 `migrations/003_*.sql`에 `CREATE TABLE` / `ADD COLUMN`만 |
| `requests.status`에 새 값 추가 (예: `budget_rejected`) | ERP 배치가 `status='approved' AND erp_sent_at IS NULL`을 읽음 | 예산 초과는 신청을 **접수하지 않고** 4xx로 응답 |
| `console.log` 신규 추가 | pino가 이미 있음 | pino 로거 |

## Security

- 로그인: 없음. 사내 게이트웨이가 검증한 헤더(`X-Employee-Id`, `X-Employee-Role`, `X-Team-Id`)를 `src/middleware/auth.ts`가 읽는다. 이 미들웨어와 헤더 계약은 변경 금지
- 권한: 팀 단위 데이터는 **항상 `req.employee.teamId`로 서버에서 범위를 제한**한다. 클라이언트가 보낸 팀 ID를 믿지 않는다. 팀장 잔액 조회도 자기 팀만. 예산 설정 API는 만들지 않는다(재무팀 권한, 이번엔 SQL 시드)
- 입력 검증: 모든 요청 본문과 경로 파라미터는 라우터에서 Zod로 검증한다
- 비밀: `.env`는 git에 넣지 않고 `.env.example`만 커밋한다. `DATABASE_URL`, `PORT`는 `process.env`로 읽는다. 코드와 노트에 비밀값을 쓰지 않는다
- 서버는 `127.0.0.1`에만 바인딩한다 (`src/server.ts`). 변경하지 않는다

## Example Code

코드 생성은 아래 실제 파일의 패턴을 따른다.

- **API endpoint**: `src/routes/requests.ts`. Zod `safeParse` → 400, 서비스 호출, `Result`의 `ok`가 false면 `res.status(result.status).json({ error: result.error })`, 예외는 `next(e)`로 넘긴다.
  새 라우터(예: 잔액 조회)는 같은 형태로 만들어 `src/app.ts`의 `createApp()`에 `app.use("/budgets", budgetsRouter)`처럼 마운트한다
- **비즈니스 함수**: `src/services/requestService.ts`의 `decide()`. 권한·존재·상태를 순서대로 검사하고 `{ ok: false, status, error }` 또는 `{ ok: true, value }`를 돌려준다. 예산 검사도 같은 `Result<T>` 형태로 `createRequest()` 안에서 수행하고, 초과 시 `{ ok: false, status: 4xx, error: "BUDGET_EXCEEDED", ... }`를 돌려준다(응답에 남은 금액 포함 방식은 설계에서 정함)
- **레포지토리**: `src/repositories/requestRepository.ts`. `pool.query<Row>(sql, [params])`, `RETURNING *`, 행 타입은 `interface *Row`. 새 예산 레포지토리는 `src/repositories/budgetRepository.ts`로 같은 형태
- **테스트**: `tests/routes/requests.test.ts`. 레포지토리를 `vi.mock`으로 대체, `request(createApp()).post(...).set(헤더)`, 한국어 테스트 이름. 발췌:

  ```ts
  vi.mock("../../src/repositories/requestRepository.js", () => ({ findById: vi.fn(), updateStatus: vi.fn(), insertRequest: vi.fn(), findByEmployee: vi.fn() }));
  const manager = { "X-Employee-Id": "m1", "X-Employee-Role": "manager", "X-Team-Id": "t1" };
  it("다른 팀 건은 403", async () => {
    vi.mocked(repo.findById).mockResolvedValue({ id: 2, team_id: "t9", status: "pending" } as never);
    const res = await request(createApp()).post("/requests/2/approve").set(manager);
    expect(res.status).toBe(403);
  });
  ```

- **마이그레이션**: `migrations/002_erp_sent.sql` 형태의 순수 SQL 파일. 새 파일은 `migrations/003_team_budgets.sql`처럼 번호를 이어 간다

## Never Changes

어떤 작업에서도 건드리지 않는다 (이번 작업에만 해당하는 금지는 `vision.md`의 Must Not Change에 있다).

- `src/legacy/erp/**`: 재무팀 소유. 내용, 의존성(`moment`, CommonJS), 호출 방식 모두 변경 금지. 변경이 필요하면 재무팀에 연락
- `src/middleware/auth.ts`와 게이트웨이 헤더 계약 (`X-Employee-Id`, `X-Employee-Role`, `X-Team-Id`)
- 운영 DB에 적용된 마이그레이션 파일 (`migrations/001_init.sql`, `migrations/002_erp_sent.sql`)과 `requests`, `items` 테이블의 기존 컬럼
- `requests.status` 값 집합 (`pending` / `approved` / `rejected`)과 `erp_sent_at` 컬럼의 의미 (ERP 배치 계약)
- 기존 5개 API의 요청/응답 형식 (필드 추가가 아닌 변경·삭제)
