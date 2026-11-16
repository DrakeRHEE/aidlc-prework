# AI-DLC 1일 워크샵 진행안 (자유 주제)

pre-work는 **사전 과제** 또는 **당일 오전** 중 어느 쪽으로 해도 됩니다. 결과물(3개 파일)은 같습니다.

## 운영 방식 비교

| | A. 사전 과제형 (권장) | B. 당일 오전형 |
|---|---|---|
| pre-work 시점 | 워크샵 3~7일 전, 각자 30~45분 | 당일 첫 세션 60분 |
| 준비 확인 | 사전 제출물로 미리 확인 | 당일 설치 문제로 지연될 수 있음 |
| 당일 AI-DLC 실습 시간 | 약 5시간 | 약 4시간 |
| 적합한 경우 | 고객사, 파트너사 정식 워크샵 | 사전 연락이 어렵거나 즉석 진행 |

## A. 사전 과제형

**D-7 ~ D-3**
1. [kickoff-prompts.md](kickoff-prompts.md)의 "사전 안내 메일"을 발송
2. 참가자: 설치와 설정 → 키트 내려받기 → AI 도구로 pre-work 진행 → [readiness.md](../checklists/readiness.md) 제출물 회신
3. 퍼실리테이터: 제출물 확인. 특히 `Hooks last fired:`와 `RESULT: PASS`. 문제가 있는 팀은 D-1까지 해결
4. 팀별 vision을 훑어보고 1일 범위를 넘는 팀에 피드백 (In 3~5개, 흐름 1개)

**당일**

| 시간 | 내용 |
|---|---|
| 09:00-09:30 | 오프닝: AI-DLC 개념("엔진이 순서를 정하고, 사람은 게이트를 연다"), 오늘 흐름, 규칙 안내 |
| 09:30-09:45 | 팀별 vision 1분 발표, Open Questions 공유 |
| 09:45-12:00 | `/aidlc workshop ...` 시작 → Inception (요구사항, Unit 분해, 계획) |
| 12:00-13:00 | 점심 |
| 13:00-16:00 | Construction (Unit 하나씩 설계, 코드, 테스트) |
| 16:00-16:45 | Operation 단계 체험, 산출물(`aidlc/` 폴더, audit) 둘러보기 |
| 16:45-17:30 | 팀별 데모 (vision의 Success Criteria 기준), 회고 |

## B. 당일 오전형

| 시간 | 내용 |
|---|---|
| 09:00-09:20 | 오프닝, 설치 상태 점검 |
| 09:20-10:20 | pre-work 세션: 키트 내려받기 → AI 도구로 pre-work 진행 (퍼실리테이터 순회) |
| 10:20-10:40 | 준비 확인(readiness C), 막힌 팀 지원 |
| 10:40-12:00 | `/aidlc workshop ...` 시작 → Inception |
| 13:00-16:30 | Construction |
| 16:30-17:30 | 데모, 회고 (Operation은 시연으로 대체 가능) |

## 진행 팁 (공식 가이드 기반)

- **Kiro는 에이전트를 구분합니다.** pre-work는 **Default**, 워크플로는 **aidlc** 에이전트에서 진행합니다.
- **질문 수 줄이기:** `--depth minimal` (stage당 2~4개). 시간이 남는 팀은 빼고 Standard로 진행합니다.
- **멈춤 줄이기:** `--learnings off --summary-confirmation off`. 질문과 승인 게이트는 그대로 남습니다.
  learning loop를 가르칠 때는 `--learnings off`를 뺍니다.
- **Unit 하나씩:** Construction 전에 `aidlc-state.md`의 `Construction Iteration: unit-major`를 확인합니다.
  없으면 `aidlc engine state set-construction-iteration unit-major`를 실행합니다.
- **곁가지 작업**은 기본값으로 시작하지 말고 `/aidlc bugfix ...`(6 stage)나 `/aidlc express ...`(7 stage)로,
  별도 폴더에서 진행합니다.
- **막힘 대응:** 에이전트 정지 → 본인 터미널에서 `aidlc doctor --export` → `fix:` 줄 수행 →
  같은 실패가 두 번 반복되면 미리 정한 대체 도구(예: Kiro ↔ Claude Code)로 전환합니다.
- **대화가 길어지거나 꼬이면:** 새 채팅에서 `/aidlc --resume`. 워크플로는 디스크의 파일에서 이어집니다.
- **기존 코드 팀:** 브랜치를 따로 만들고 시작합니다. 첫 단계인 Reverse Engineering이 코드를 읽느라 15분 안팎 걸립니다(소스 파일 20개 규모 테스트 기준). 그동안 팀은 vision을 다시 확인하게 하세요. 시작 명령에 `--project-type brownfield`를 넣습니다.
