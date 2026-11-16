# Technical Environment: FieldCheck

## Project Technical Summary

- **Project type**: New (신규, 기존 코드 없음)
- **Runtime environment**: Local only (로컬 실행과 테스트만)
- **Team size and key skills**: 2명. 둘 다 Python 경험만 있음 (JavaScript 프레임워크 경험 없음)

## Language

| Language | Version | Purpose |
|----------|---------|---------|
| Python | 3.12 (uv로 지정. macOS 기본 `python3` 3.9는 쓰지 않음) | 백엔드, 화면 렌더링, 테스트 |
| HTML (Jinja2 템플릿) | - | 화면 3개 (점검표, 결과, 점주 조치 목록) + 첫 화면(사용자 선택) |

## Package Manager

- uv 0.13.x. 의존성은 `uv add`로 추가하고 `pyproject.toml`과 `uv.lock`을 커밋한다. 실행은 `uv run ...`으로 한다

## Framework

| Framework or library | Version | Area |
|----------------------|---------|------|
| FastAPI | 0.115 이상 | API, 라우팅 |
| Jinja2 | 3.1.x | 서버 렌더링 HTML 화면 |
| python-multipart | 0.0.9 이상 | HTML 폼 제출 처리 |
| Pydantic | 2.x | 입력 검증 |
| SQLAlchemy | 2.0.x (2.0 스타일 `select()`, `Session`) | 데이터 접근 |
| Uvicorn | 0.30 이상 | 로컬 개발 서버 |

- **Data store**: SQLite 파일 (`fieldcheck.db`, git에 넣지 않음). 테스트는 인메모리 SQLite를 쓴다
- **Structure**: `app/main.py`(앱 생성), `app/routers/`(화면과 엔드포인트), `app/services/`(점수 계산과 조치 요청 생성 같은 비즈니스 로직, 순수 함수), `app/models.py`(SQLAlchemy 모델), `app/db.py`(세션), `app/templates/`(Jinja2), `tests/`
- **Seed data**: 시작 시 샘플 매장 몇 곳, 슈퍼바이저 1명, 매장별 점주 사용자, 점검 항목을 넣는다

## Cloud and Deployment

- local only: `uv run uvicorn app.main:app --reload`로 실행하고 `uv run pytest`로 테스트한다. 클라우드 배포는 하지 않는다

## Testing

| Test type | Required | Target | Tooling |
|-----------|----------|--------|---------|
| Unit | Yes | `app/services/`의 점수 계산, 재점검 판정(70점 경계), 미흡 항목별 조치 요청 생성 | pytest 8.x |
| Integration | Yes | 1~2개 흐름: 점검표 제출 → 점수와 조치 요청 생성, 점주가 다른 매장 조치 요청 완료 시도 → 거부 | pytest + FastAPI `TestClient` (httpx) |

- **Test location**: `tests/` 폴더, 파일명 `test_<대상>.py`
- **Strategy**: Minimal. 요구사항마다 테스트 하나, 경계값(70점)과 권한 거부는 반드시 포함

## Prohibited

| Prohibited | Reason | Use instead |
|------------|--------|-------------|
| React, Vue, npm 등 JavaScript 프레임워크와 빌드 도구 | 팀이 Python만 다룰 수 있고, 하루 일정에 JS 빌드 설정을 넣을 여유가 없음 | Jinja2 템플릿 + 일반 HTML 폼 |
| `pip install` 직접 실행, `requirements.txt` 수동 관리 | 두 사람의 환경이 달라지고 lock이 없어 재현이 안 됨 | `uv add` + `uv.lock` 커밋, `uv run`으로 실행 |
| f-string 등 문자열 조합으로 만든 SQL | SQL 인젝션 위험 | SQLAlchemy `select()`와 바인딩 파라미터 |
| 폼이나 쿼리로 받은 `store_id`, `user_id`로 권한 판단 | 점주가 값을 바꿔 다른 매장 데이터를 볼 수 있음 | 서버가 현재 사용자(`get_current_user`)에서 `store_id`를 읽어 비교 |
| 라우터나 템플릿 안에 점수 계산 로직 작성 | 테스트하기 어렵고 규칙이 여러 곳에 흩어짐 | `app/services/`의 순수 함수로 두고 라우터는 호출만 |
| 카카오 알림톡 등 외부 API 호출 코드 | 1차 범위 밖이고 local only | 조치 요청은 DB 레코드로만 생성 |
| 코드에 비밀값 하드코딩 | 유출 위험 | 환경변수 (`.env`, git에는 `.env.example`만) |

## Security

- **Sign-in**: 정식 로그인 없음. 첫 화면에서 고정 사용자(슈퍼바이저 1명 또는 매장별 점주)를 고르면, 서버가 사용자 ID를 서명된 세션 쿠키(Starlette `SessionMiddleware`)에 저장한다. 모든 요청은 `get_current_user`로 사용자와 역할, 매장을 확인한다. 점주는 자기 매장의 조치 요청만 조회하고 완료할 수 있다
- **Input validation**: 모든 폼과 경로 입력은 FastAPI 타입 선언과 Pydantic 모델로 검증한다. 잘못된 항목 ID나 판정 값은 400/422로 거부한다
- **Secrets**: 세션 서명 키는 환경변수 `SESSION_SECRET`(`.env`)로 받는다. `.env`와 `fieldcheck.db`는 `.gitignore`에 넣고 `.env.example`만 커밋한다

## Example Code

### Endpoint

```python
# app/routers/actions.py
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from app.db import get_db
from app.deps import get_current_user
from app.models import ActionRequest, User

router = APIRouter()


@router.post("/actions/{action_id}/complete")
def complete_action(
    action_id: int,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    action = db.get(ActionRequest, action_id)
    if action is None:
        raise HTTPException(status_code=404, detail="조치 요청을 찾을 수 없습니다")
    if user.role != "owner" or action.store_id != user.store_id:
        raise HTTPException(status_code=403, detail="자기 매장의 조치 요청만 처리할 수 있습니다")
    action.status = "done"
    db.commit()
    return RedirectResponse("/actions", status_code=303)
```

### Function

```python
# app/services/inspection.py
from dataclasses import dataclass

RECHECK_THRESHOLD = 70


@dataclass(frozen=True)
class ItemResult:
    item_id: int
    category: str  # "hygiene" | "display" | "expiry"
    passed: bool


def is_recheck_target(score: float) -> bool:
    """총점이 70점 미만이면 재점검 대상이다."""
    return score < RECHECK_THRESHOLD


def deficient_items(results: list[ItemResult]) -> list[ItemResult]:
    """미흡 항목만 돌려준다. 항목 하나당 조치 요청 1건을 만든다."""
    return [r for r in results if not r.passed]
```

### Test

```python
# tests/test_inspection.py
import pytest

from app.services.inspection import ItemResult, deficient_items, is_recheck_target


@pytest.mark.parametrize("score, expected", [(69.9, True), (70, False), (100, False)])
def test_is_recheck_target_boundary(score, expected):
    assert is_recheck_target(score) is expected


def test_deficient_items_returns_only_failed():
    results = [
        ItemResult(1, "hygiene", False),
        ItemResult(2, "display", True),
        ItemResult(3, "expiry", False),
    ]
    assert [r.item_id for r in deficient_items(results)] == [1, 3]


def test_deficient_items_empty_when_all_passed():
    assert deficient_items([ItemResult(1, "hygiene", True)]) == []
```
