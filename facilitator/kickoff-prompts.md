# 참가자 안내문과 당일 명령어

## 1. 사전 안내 메일 (복사해서 사용)

```text
제목: [AI-DLC 워크샵] 사전 준비 안내 (약 45분)

안녕하세요. <날짜> AI-DLC 1일 워크샵 전에 아래 준비를 부탁드립니다.
워크샵은 자유 주제입니다. 각 팀이 만들고 싶은 것(신규) 또는 기존 코드에 추가할 기능을 가져오시면 됩니다.

1) AI 도구 준비: Claude Code 또는 Kiro(IDE 1.1.70 이상 / CLI 2.24.1 이상)
2) AI-DLC 설치
   macOS/Linux/WSL: curl -fsSL https://github.com/awslabs/aidlc-workflows/releases/latest/download/install.sh | sh
   Windows(일반 PowerShell): irm https://github.com/awslabs/aidlc-workflows/releases/latest/download/install.ps1 | iex
3) 실습 폴더에서: aidlc config --harness claude  (Kiro는 --harness kiro-ide)  →  aidlc doctor
4) 실습 폴더에 pre-work 키트를 받고 AI 도구로 진행:
   https://github.com/DrakeRHEE/aidlc-prework 의 README "참가자: 3단계로 시작하기"를 따라 주세요.
5) <회신 마감일>까지 아래를 회신해 주세요.
   - aidlc doctor 요약 줄
   - aidlc doctor --verbose 의 "Hooks last fired:" 줄
   - sh .aidlc-prework/scripts/check-prework.sh . 결과 (RESULT 줄)

비밀번호, 키, 고객 실데이터는 노트에 넣지 마세요.
```

## 2. 참가자가 AI 도구에 입력할 한 줄

```text
.aidlc-prework/PREWORK.md를 읽고, 그 지침대로 Step 1부터 끝까지 나와 상담하면서 진행해줘.
```

- Kiro IDE: 새 채팅 → **Default** 에이전트
- Kiro CLI: `kiro-cli --v3` → 필요하면 `/agent swap`으로 기본 에이전트 선택
- Claude Code: 실습 폴더에서 `claude` → 일반 채팅

## 3. 당일 워크플로 시작 (새 채팅)

- Kiro: 에이전트 선택기에서 **aidlc** 선택 (CLI는 `kiro-cli --v3`)

```text
/aidlc workshop --depth minimal --learnings off --summary-confirmation off ./vision.md를 읽고 거기 적힌 것을 만들어 주세요. 대화와 산출물은 한국어로 진행해 주세요.
```

## 4. 자주 쓰는 명령

| 상황 | 명령 |
|---|---|
| 현재 위치 확인 | `/aidlc --status` |
| 질문 수 줄이기 (진행 중) | `/aidlc --depth minimal` |
| 새 채팅에서 이어 하기 | `/aidlc --resume` |
| 작업 목록과 보관 | `/aidlc intent`, `/aidlc intent archive <이름>` |
| 진단 리포트 (본인 터미널) | `aidlc doctor --export` |
| Unit 하나씩 진행 | `aidlc engine state set-construction-iteration unit-major` |
