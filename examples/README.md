# 완성 예시

각 폴더는 **실습 폴더와 같은 경로 구조**입니다.

| 예시 | 유형 | 주제 | 볼 점 |
|---|---|---|---|
| [greenfield/](greenfield/) | 신규 | 사내 회의실 예약 웹앱 (local only, TypeScript) | 1일 범위 줄이기(Out 4개), 인라인 예시 코드 |
| [brownfield/](brownfield/) | 기존 코드 | 사내 도서 대여 API에 예약(대기열) 기능 추가 (FastAPI) | `Must Not Change`, `Never Changes`, 실제 파일 경로 인용, 기존 `project.md`에 덧붙이기 |

```bash
sh scripts/check-prework.sh examples/greenfield
sh scripts/check-prework.sh examples/brownfield
```
