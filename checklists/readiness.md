# 참가자 PC 준비 확인 체크리스트

공식 [facilitator-guide.md](https://github.com/awslabs/aidlc-workflows/blob/main/docs/guide/facilitator-guide.md)의
*readiness pass mark* 기준입니다. **실제 실습 폴더에서** 확인합니다. 폴더 신뢰와 hook 설정은 폴더마다 다릅니다.

## A. 도구

- [ ] Claude Code 최신 버전, 또는 Kiro IDE 1.1.70 이상 / Kiro CLI 2.24.1 이상 (`kiro-cli --version`)
- [ ] 로그인 완료, 모델은 Claude Opus 계열 최신 모델 선택 (공식 권장)
- [ ] Windows는 일반 PowerShell 창(관리자 권한 아님)에서 설치. 설치 후 도구와 터미널 재시작

## B. AI-DLC 설치와 설정

- [ ] `aidlc --version` 출력됨
- [ ] 실습 폴더에서 `aidlc config --harness claude` 또는 `aidlc config --harness kiro` 실행
  - 통과: `Runtime` 행 `[ok]`와 `hook PATH ready`, `Trust` 행 `[ok]`
- [ ] `aidlc doctor`의 요약이 `0 problems`
  - `Runtime hook PATH` 경고가 있으면 먼저 해결

## C. 실제 stage 한 번 돌려 보기

- [ ] 새 채팅(Kiro는 **aidlc** 에이전트, CLI는 `kiro-cli --v3`)에서 `/aidlc express Add a --version flag to the CLI`
- [ ] 첫 질문이나 승인 화면에 답함 (Claude Code는 선택지 선택, Kiro는 번호 입력) → 바로 멈춤
- [ ] 터미널에서 `aidlc doctor --verbose`를 실행해 **`Hooks last fired:`** 행에 현재 시각의 hook 이름 확인
  - 실패: `Hooks have never executed...` → 폴더 신뢰, PATH, 에이전트 선택 확인 후 재시도
  - 미준비: `Your replies are not being recorded` → 해당 fix 줄 수행
- [ ] `/aidlc intent archive <이름>`으로 연습 작업 정리 (거부되면 터미널에서 `aidlc engine intent archive <이름>`)

## D. Pre-work notes

- [ ] `./vision.md`
- [ ] `./aidlc/spaces/default/knowledge/aidlc-shared/technical-environment.md`
- [ ] `./aidlc/spaces/default/memory/project.md`
- [ ] `sh .aidlc-prework/scripts/check-prework.sh .` → `RESULT: PASS`

## 사전 제출물 (워크샵 1주 전 권장)

1. B의 `aidlc config` 결과표와 `aidlc doctor` 요약
2. C의 `aidlc doctor --verbose` 중 `Hooks last fired:` 행
3. D의 3개 파일 또는 검증 스크립트 결과

> 비밀값이나 고객 기밀이 들어 있지 않은지 확인한 뒤 제출하세요.
