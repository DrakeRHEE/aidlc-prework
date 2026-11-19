# 참가자 PC 준비 확인 체크리스트

공식 [facilitator-guide.md](https://github.com/awslabs/aidlc-workflows/blob/main/docs/guide/facilitator-guide.md)의
*readiness pass mark* 기준입니다. **실제 실습 폴더에서** 확인합니다. 폴더 신뢰와 hook 설정은 폴더마다 다릅니다.

## A. 도구

- [ ] Claude Code 최신 버전, 또는 Kiro IDE 1.1.70 이상 / Kiro CLI 2.24.1 이상 (`kiro-cli --version`)
- [ ] 로그인 완료, 모델은 Claude Opus 계열 최신 모델 선택 (공식 권장)
- [ ] Windows는 일반 PowerShell 창(관리자 권한 아님)에서 설치. 설치 후 도구와 터미널 재시작

## B. Pre-work notes (AI-DLC 설정 전에 만드는 것을 권장)

- [ ] `./vision.md`
- [ ] `./aidlc/spaces/default/knowledge/aidlc-shared/technical-environment.md`
- [ ] `./aidlc/spaces/default/memory/project.md`
- [ ] `sh .aidlc-prework/scripts/check-prework.sh .` → `RESULT: PASS`

## C. AI-DLC 설치와 설정

- [ ] `aidlc --version` 출력됨
- [ ] 실습 폴더에서 `aidlc config --harness claude` 또는 `aidlc config --harness kiro-ide` 실행 (Kiro IDE, Kiro CLI --v3 모두. 2.11.3 이하에서 `kiro`는 Kiro CLI V2를 뜻하므로 `kiro-ide`가 안전)
  - 통과: `Runtime` 행 `[ok]`와 `hook PATH ready`, `Trust` 행 `[ok]`
- [ ] `aidlc doctor`의 요약이 `0 problems`
  - `Runtime hook PATH` 경고가 있으면 먼저 해결

## D. 실제 stage 한 번 돌려 보기

> 왜: `aidlc doctor`는 새로 설치한 상태에서 hook이 한 번도 실행되지 않았어도 통과합니다. hook이 안 도는 PC는
> 당일 "승인이 기록되지 않음" 문제로 나타나므로, 실제 stage를 한 번 돌려 hook 실행 기록을 확인합니다.

- [ ] 새 채팅(Kiro는 **aidlc** 에이전트, CLI는 `kiro-cli --v3`)에서 `/aidlc express Add a --version flag to the CLI`
- [ ] 첫 질문이나 승인 화면에 답함 (Claude Code는 선택지 선택, Kiro는 번호 입력) → 바로 멈춤
- [ ] 터미널에서 `aidlc doctor --verbose`를 실행해 **`Hooks last fired:`** 행에 현재 시각의 hook 이름 확인
  - 실패: `Hooks have never executed...` → 폴더 신뢰, PATH, 에이전트 선택 확인 후 재시도
  - 미준비: `Your replies are not being recorded` → 해당 fix 줄 수행
- [ ] `/aidlc intent archive <이름>`으로 연습 작업 정리 (거부되면 터미널에서 `aidlc engine intent archive <이름>`)

## 사전 제출물 (워크샵 1주 전 권장)

> 왜: 퍼실리테이터가 당일 전에 설치 문제와 범위 문제를 찾아 미리 도울 수 있습니다. 확인하는 데 몇 분이면 됩니다.

1. B의 검증 스크립트 결과(`RESULT` 줄) 또는 3개 파일
2. C의 `aidlc config` 결과표와 `aidlc doctor` 요약
3. D의 `aidlc doctor --verbose` 중 `Hooks last fired:` 행

> 비밀값이나 고객 기밀이 들어 있지 않은지 확인한 뒤 제출하세요.
