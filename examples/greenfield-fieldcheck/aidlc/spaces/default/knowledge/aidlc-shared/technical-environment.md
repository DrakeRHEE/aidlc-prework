# Technical Environment: 그린마트 현장 점검 (fieldcheck)

## Project Technical Summary

- **Project type**: New (Greenfield)
- **Runtime environment**: Local only
- **Team size and key skills**: 2명. 둘 다 Python 경험 있음. JavaScript와 프런트엔드 프레임워크 경험은 적음

## Language

| Language | Version | Purpose |
|----------|---------|---------|
| Python | 3.12 (uv로 설치) | API, 화면 렌더링, 비즈니스 로직, 테스트 |
| HTML + Jinja2 템플릿 | Jinja2 3.x | 화면 (JavaScript 빌드 없음) |

## Package Manager

- uv 0.13.x: 의존성은 `uv add`로 추가하고, `pyproject.toml`과 `uv.lock`을 함께 커밋한다

## Framework

| Framework or library | Version | Area |
|----------------------|---------|------|
| FastAPI | 0.115 이상 (최신 안정판) | API와 화면 라우팅 |
| Uvicorn | 0.30 이상 | 로컬 실행 서버 |
| Jinja2 | 3.x | 서버 렌더링 화면 (HTML 폼) |
| python-multipart | 0.0.x (최신) | 폼 입력과 사진 업로드 처리 |
| Pydantic | 2.x | 입력 검증 |
| SQLAlchemy | 2.0.x | DB 접근 (ORM, 2.0 스타일 `select()`) |
| itsdangerous | 2.x | 세션 쿠키 서명 (Starlette `SessionMiddleware`) |

- **Data store**: SQLite 파일 (`data/fieldcheck.db`). 사진은 로컬 폴더 `uploads/`에 저장하고, DB에는 파일 경로만 저장한다
- **Layout**: `app/` (`main.py`, `routes/`, `models.py`, `db.py`, `auth.py`, `scoring.py`, `templates/`), `tests/`, `uploads/`, `data/`

## Cloud and Deployment

- local only: `uv run uvicorn app.main:app --reload`로 실행하고, `uv run pytest`로 테스트한다. 클라우드 배포는 하지 않는다

## Testing

| Test type | Required | Target | Tooling |
|-----------|----------|--------|---------|
| Unit | Yes | 점수 계산 (위생 2배, 70점 기준), 미흡 항목의 조치 요청 생성 | pytest 8.x |
| Integration | Yes | ① 점검 제출 → 점수와 조치 요청 생성 ② 점주가 다른 매장 조치 요청에 접근하면 403 | pytest + FastAPI `TestClient` (httpx) |

- **Test location**: `tests/` 폴더, 파일명은 `test_*.py`
- **Strategy**: Minimal. 핵심 로직 단위 테스트와 API 통합 테스트 1~2개. 통합 테스트는 임시 SQLite와 임시 업로드 폴더를 쓴다

## Prohibited

| Prohibited | Reason | Use instead |
|------------|--------|-------------|
| `pip install` 직접 실행, `requirements.txt` 수동 관리 | 두 사람 PC의 의존성 버전이 어긋남 | `uv add <패키지>`, `uv.lock` 커밋 |
| React, Vue 등 JavaScript 프레임워크와 npm 빌드 | 팀이 JavaScript에 익숙하지 않고 하루 범위를 넘음 | Jinja2 템플릿 + HTML 폼 |
| f-string이나 문자열 연결로 만든 SQL | SQL 인젝션 위험 | SQLAlchemy `select()`와 바인드 파라미터 |
| 코드에 하드코딩한 비밀값 (세션 서명 키 등) | git을 통해 유출됨 | `.env`의 환경변수 (`SESSION_SECRET`), `.env.example`만 커밋 |
| 업로드한 파일명을 그대로 저장 경로로 사용 | 경로 조작, 파일 덮어쓰기 위험 | 서버에서 UUID 파일명 생성, 확장자 허용 목록 (`.jpg`, `.jpeg`, `.png`) |
| 외부 저장소나 외부 알림 API 호출 (S3, 알림톡 등) | local only 범위이고, 알림톡은 Out of Scope | 로컬 `uploads/` 폴더, 화면에서 상태 표시 |

## Security

- **Sign-in**: 고정 사용자. 첫 화면에서 샘플 사용자(슈퍼바이저 또는 매장별 점주)를 고르면 서명된 세션 쿠키(`SessionMiddleware`)에 저장한다. 비밀번호는 없다. 점주 접근 권한은 매 요청마다 서버에서 `store_id`로 검사한다
- **Input validation**: 모든 폼 입력은 FastAPI `Form` 타입과 Pydantic v2로 검증한다. 업로드는 확장자 허용 목록과 크기 상한(파일당 10MB)으로 제한한다
- **Secrets**: `.env`에 보관하고 git에는 `.env.example`만 커밋한다. `.env`, `data/*.db`, `uploads/`는 `.gitignore`에 넣는다

## Example Code

### Endpoint

```python
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from app.auth import current_user
from app.db import get_db
from app.models import ActionRequest, User

router = APIRouter()


@router.post("/action-requests/{request_id}/complete")
def complete_action_request(
    request_id: int,
    user: User = Depends(current_user),
    db: Session = Depends(get_db),
):
    ar = db.get(ActionRequest, request_id)
    if ar is None:
        raise HTTPException(status_code=404, detail="조치 요청을 찾을 수 없습니다")
    if user.role != "owner" or ar.store_id != user.store_id:
        raise HTTPException(status_code=403, detail="자기 매장의 조치 요청만 처리할 수 있습니다")
    if ar.status == "requested":
        ar.status = "done"
        db.commit()
    return RedirectResponse(url="/owner/action-requests", status_code=303)
```

### Function

```python
from dataclasses import dataclass

# 위생 2배, 70점 미만 재점검은 확정 규칙. 100점 만점 환산은 임시안 (vision Open Questions)
CATEGORY_WEIGHTS = {"hygiene": 2, "display": 1, "expiry": 1}
RECHECK_THRESHOLD = 70


@dataclass(frozen=True)
class ItemResult:
    category: str  # "hygiene" | "display" | "expiry"
    passed: bool


def calculate_score(items: list[ItemResult]) -> tuple[int, bool]:
    """(점수, 재점검 대상 여부)를 돌려준다."""
    if not items:
        raise ValueError("점검 항목이 비어 있습니다")
    total = sum(CATEGORY_WEIGHTS[i.category] for i in items)
    earned = sum(CATEGORY_WEIGHTS[i.category] for i in items if i.passed)
    score = round(earned * 100 / total)
    return score, score < RECHECK_THRESHOLD
```

### Test

```python
import pytest

from app.scoring import ItemResult, calculate_score


def test_all_passed_is_100_and_not_recheck():
    items = [ItemResult("hygiene", True), ItemResult("display", True)]
    assert calculate_score(items) == (100, False)


def test_hygiene_failure_counts_double():
    # 위생(2) 미흡, 진열(1)과 유통기한(1) 적합 → 2/4 = 50점
    items = [ItemResult("hygiene", False), ItemResult("display", True), ItemResult("expiry", True)]
    assert calculate_score(items) == (50, True)


def test_exactly_70_is_not_recheck():
    # 위생 3개 적합(6) + 진열 1개 적합(1), 진열과 유통기한 3개 미흡 → 7/10 = 70점
    items = [ItemResult("hygiene", True)] * 3 + [ItemResult("display", True)] + [
        ItemResult("display", False), ItemResult("expiry", False), ItemResult("expiry", False)]
    assert calculate_score(items) == (70, False)


def test_empty_items_raises():
    with pytest.raises(ValueError):
        calculate_score([])
```
