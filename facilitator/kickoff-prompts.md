# 참가자 안내문과 당일 명령어

## 1. 사전 안내 메일 (복사해서 사용)

```text
제목: [AI-DLC 워크샵] 사전 준비 안내 (약 45분)

안녕하세요. <날짜> AI-DLC 1일 워크샵 전에 아래 준비를 부탁드립니다.
워크샵은 자유 주제입니다. 만들고 싶은 것(신규) 또는 기존 코드에 추가할 기능을 정해 오시면 됩니다.
AI 도구와 상담하면서 노트를 만드니, 아직 정하지 않았어도 괜찮습니다.

1) AI 도구 준비: Claude Code 또는 Kiro(IDE 1.1.70 이상 / CLI 2.24.1 이상)
2) 노트 만들기 (약 30분): https://github.com/DrakeRHEE/aidlc-prework 의 README
   "참가자: 시작하기" ①, ②를 따라 주세요. 실습할 폴더에서 AI 도구와 상담하면 노트 3개가 만들어집니다.
3) AI-DLC 설치와 설정 (README ③):
   macOS/Linux/WSL: curl -fsSL https://github.com/awslabs/aidlc-workflows/releases/latest/download/install.sh | sh
   Windows(일반 PowerShell): irm https://github.com/awslabs/aidlc-workflows/releases/latest/download/install.ps1 | iex
   실습 폴더에서: aidlc config --harness claude  (Kiro는 --harness kiro-ide)  →  aidlc doctor
4) 준비 확인: 키트의 checklists/readiness.md D항목 (연습 stage 1회)
5) <회신 마감일>까지 아래 3줄을 회신해 주세요.
   - aidlc doctor 요약 줄
   - aidlc doctor --verbose 의 "Hooks last fired:" 줄
   - sh .aidlc-prework/scripts/check-prework.sh . 결과 (RESULT 줄)

노트를 먼저 만들고 AI-DLC를 나중에 설정하는 이유: AI-DLC를 설정하면 그 안내가 모든 채팅에 들어가서
상담이 길어집니다. 비밀번호, 키, 고객 실데이터는 노트에 넣지 마세요.
```

## 2. 참가자가 AI 도구에 입력할 한 줄

```text
.aidlc-prework/PREWORK.md를 읽고, 그 지침대로 나와 상담하면서 진행해줘.
```

- Kiro IDE: 새 채팅 → **Default** 에이전트
- Kiro CLI: `kiro-cli` (AI-DLC를 이미 설정했다면 `/agent`로 aidlc가 아닌 에이전트 선택)
- Claude Code: 실습 폴더에서 `claude` → 일반 채팅

## 3. 당일 워크플로 시작 (새 채팅)

- Kiro IDE: 에이전트 선택기에서 **aidlc** 선택 / Kiro CLI: `kiro-cli --v3`
- 옵션 설명: README의 "시작 명령 설명"

```text
/aidlc workshop --depth minimal --learnings off --summary-confirmation off ./vision.md를 읽고 거기 적힌 것을 만들어 주세요. 대화와 산출물은 한국어로 진행해 주세요.
```

기존 코드(Brownfield)이면 `--project-type brownfield`를 넣습니다.

```text
/aidlc workshop --depth minimal --learnings off --summary-confirmation off --project-type brownfield ./vision.md를 읽고 거기 적힌 것을 만들어 주세요. 대화와 산출물은 한국어로 진행해 주세요.
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
