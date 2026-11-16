# Technical Environment: RoomBook

## Project Technical Summary

- **Project type**: New
- **Runtime environment**: Local only
- **Team size and key skills**: 2명, JavaScript 경험 있음, TypeScript 입문

## Language

| Language | Version | Purpose |
|----------|---------|---------|
| TypeScript | 5.x | API 서버와 웹 UI |
| Node.js | 22 LTS | 런타임 |

## Package Manager

- npm 10.x (단일 `package.json`, 워크스페이스 사용 안 함)

## Framework

| Framework or library | Version | Area |
|----------------------|---------|------|
| Fastify | 5.x | REST API |
| Zod | 3.x | 입력 검증 |
| React | 19.x | 웹 UI |
| Vite | 6.x | UI 빌드와 개발 서버 |

- **Data store**: SQLite (`better-sqlite3`), 파일 `data/roombook.db`. 시작 시 회의실 시드 데이터 5건 생성

## Cloud and Deployment

- local only: `npm run dev`로 API(포트 3000)와 UI(포트 5173)를 로컬에서 실행. 배포 없음

## Testing

| Test type | Required | Target | Tooling |
|-----------|----------|--------|---------|
| Unit | Yes | 시간대 충돌 판정 등 예약 도메인 로직 | Vitest |
| Integration | Yes | 예약 생성 API의 성공/충돌 2개 흐름 | Vitest + Fastify `inject` |

- **Test location**: 소스 옆 `*.test.ts`

## Prohibited

| Prohibited | Reason | Use instead |
|------------|--------|-------------|
| `moment` | 유지보수 중단, 번들 크기 큼 | `date-fns` |
| `express` | 프레임워크 혼용 방지 | Fastify |
| `any` 타입 | 타입 안정성 상실 | 명시적 타입 또는 `unknown` + Zod 파싱 |
| ORM(Prisma, TypeORM 등) | 1일 범위에 비해 설정 비용 큼 | `better-sqlite3` + 저장소(repository) 함수 |

## Security

- **Sign-in**: 없음. 모든 요청은 고정 사용자 `demo-user`로 처리 (Out of Scope: SSO)
- **Input validation**: 모든 요청 body와 query는 Zod 스키마로 검증하고, 실패하면 400 응답
- **Secrets**: 사용하지 않음. 필요해지면 `.env`에 두고 `.env.example`만 커밋

## Example Code

### Endpoint

```ts
// src/api/routes/reservations.ts
import type { FastifyInstance } from "fastify";
import { z } from "zod";
import { createReservation } from "../../domain/reservations.js";

const Body = z.object({
  roomId: z.string().min(1),
  start: z.string().datetime(),
  end: z.string().datetime(),
  title: z.string().min(1).max(100),
});

export async function reservationRoutes(app: FastifyInstance) {
  app.post("/reservations", async (req, reply) => {
    const parsed = Body.safeParse(req.body);
    if (!parsed.success) return reply.code(400).send({ error: "INVALID_INPUT", details: parsed.error.issues });
    const result = createReservation({ ...parsed.data, userId: "demo-user" });
    if (!result.ok) return reply.code(409).send({ error: result.error });
    return reply.code(201).send(result.value);
  });
}
```

### Function

```ts
// src/domain/overlap.ts
export interface Slot { start: Date; end: Date }

/** 두 시간 구간이 겹치면 true. 끝 시각과 시작 시각이 같으면 겹치지 않음. */
export function overlaps(a: Slot, b: Slot): boolean {
  return a.start < b.end && b.start < a.end;
}
```

### Test

```ts
// src/domain/overlap.test.ts
import { describe, it, expect } from "vitest";
import { overlaps } from "./overlap.js";

const at = (h: number, m = 0) => new Date(Date.UTC(2026, 0, 5, h, m));

describe("overlaps", () => {
  it("겹치는 구간은 true", () => {
    expect(overlaps({ start: at(10), end: at(11) }, { start: at(10, 30), end: at(11, 30) })).toBe(true);
  });
  it("맞닿은 구간은 false", () => {
    expect(overlaps({ start: at(10), end: at(11) }, { start: at(11), end: at(12) })).toBe(false);
  });
});
```
