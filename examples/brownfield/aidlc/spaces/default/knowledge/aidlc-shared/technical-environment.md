# Technical Environment: LibraryHub

## Project Technical Summary

- **Project type**: Existing codebase
- **Runtime environment**: Local only (워크샵에서는 docker compose로 PostgreSQL 실행)
- **Team size and key skills**: 3명, Python과 FastAPI 실무 경험

## Language

| Language | Version | Purpose |
|----------|---------|---------|
| Python | 3.12 | API 서비스 전체 |

## Package Manager

- uv 0.5.x (`pyproject.toml`, `uv.lock` 커밋됨)

## Framework

| Framework or library | Version | Area |
|----------------------|---------|------|
| FastAPI | 0.115.x | REST API |
| Pydantic | 2.x | 요청/응답 스키마, 입력 검증 |
| SQLAlchemy | 2.0.x | DB 접근 (2.0 스타일 `select()`) |
| Alembic | 1.13.x | 스키마 마이그레이션 |

- **Data store**: PostgreSQL 16 (`docker-compose.yml`의 `db` 서비스)

## Cloud and Deployment

- local only: `docker compose up -d db` 후 `uv run uvicorn app.main:app --reload`. 운영 배포는 이번 범위 밖

## Testing

| Test type | Required | Target | Tooling |
|-----------|----------|--------|---------|
| Unit | Yes | 예약 순번과 우선권 판정 로직 | pytest |
| Integration | Yes | 예약 API와 반납 후 우선권 흐름 | pytest + `httpx.AsyncClient` + 테스트용 DB |

- **Test location**: `tests/` (모듈 구조를 그대로 따름, 예: `tests/routers/test_loans.py`)
- 기존 테스트 실행: `uv run pytest`

## Prohibited

| Prohibited | Reason | Use instead |
|------------|--------|-------------|
| SQLAlchemy 1.x 스타일 `session.query()` | 2.0으로 이전 완료, 혼용 금지 | `session.execute(select(...))` |
| 라우터에서 직접 SQL 실행 | 계층 분리 규칙 위반 | `app/repositories/`의 저장소 함수 |
| `requests` | 동기 클라이언트, 이벤트 루프 차단 | `httpx.AsyncClient` |
| 기존 마이그레이션 파일 수정 | 운영 DB 이력 불일치 | 새 Alembic revision 추가 |

## Security

- **Sign-in**: 사내 게이트웨이가 넣는 `X-Employee-Id` 헤더를 `app/auth/deps.py`의 `get_current_employee`로 읽음. 새 엔드포인트도 이 의존성을 사용
- **Input validation**: 모든 요청 body는 Pydantic 모델로 검증
- **Secrets**: DB 접속 정보는 환경변수 `DATABASE_URL`. `.env`는 git 제외, `.env.example`만 커밋

## Example Code

기존 코드의 실제 파일을 패턴으로 따른다.

- **Endpoint**: 모든 API 엔드포인트는 `app/routers/loans.py` 패턴을 따른다 (라우터는 얇게, 로직은 서비스에)
- **Function**: 비즈니스 로직은 `app/services/loan_service.py` 패턴을 따른다
- **DB access**: 저장소 함수는 `app/repositories/loan_repository.py` 패턴을 따른다
- **Test**: API 테스트는 `tests/routers/test_loans.py` 패턴을 따른다 (fixture `client`, `db_session` 재사용)

`app/routers/loans.py` 발췌:

```python
@router.post("/loans", response_model=LoanOut, status_code=201)
async def create_loan(
    body: LoanCreate,
    employee: Employee = Depends(get_current_employee),
    service: LoanService = Depends(get_loan_service),
) -> LoanOut:
    return await service.borrow(book_id=body.book_id, employee_id=employee.id)
```

## Never Changes

- `app/auth/` 사용자 식별 방식과 `X-Employee-Id` 헤더 계약
- `/loans` API 계약 (다른 사내 시스템이 호출 중)
- 기존 Alembic 마이그레이션 파일
