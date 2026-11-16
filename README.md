# aidlc-prework

[AI-DLC](https://github.com/awslabs/aidlc-workflows) 1일 워크샵(자유 주제)을 위한 **pre-work notes 작성 키트**입니다.
참가자는 자기 AI 코딩 도구(**Claude Code** 또는 **Kiro**)에 이 레포의 지침을 읽히기만 하면 됩니다.
도구가 참가자와 상담해 실습 폴더에 pre-work notes를 만들고, 검증한 뒤, AI-DLC 워크플로 시작 직전까지 안내합니다.

> AI-DLC 공식 퍼실리테이터 가이드는 워크샵 전에 각 팀이 **vision note**와 **tech-environment note**,
> 두 개의 *pre-work notes*를 가져오도록 권합니다. 그러면 첫 1시간이 질문에 답하는 시간이 아니라
> 이미 적은 답을 확인하는 시간이 됩니다.
> ([facilitator-guide.md](https://github.com/awslabs/aidlc-workflows/blob/main/docs/guide/facilitator-guide.md))

## 만들어지는 파일

| 파일 | 위치 (실습 폴더 기준) | 용도 |
|---|---|---|
| Vision note | `./vision.md` | 무엇을, 누구를 위해, 왜, 1차 범위(In/Out). 첫 요청에 사용 |
| Tech-environment note | `./aidlc/spaces/default/knowledge/aidlc-shared/technical-environment.md` | 스택, 금지 목록, 보안, 테스트, 예시 코드. 모든 stage가 읽음 |
| Project memory | `./aidlc/spaces/default/memory/project.md` | 절대 깨면 안 되는 규칙 몇 줄 |

신규 프로젝트(Greenfield)와 **기존 코드(Brownfield)** 를 모두 지원합니다.
기존 코드는 에이전트가 코드를 먼저 읽고 초안을 채운 뒤 확인만 받습니다.

---

## 참가자: 3단계로 시작하기

### 1) 실습 폴더에 키트 내려받기

터미널에서 **실습할 프로젝트 폴더**로 이동한 뒤 실행합니다.

macOS / Linux / WSL:

```bash
mkdir -p .aidlc-prework && curl -fsSL https://github.com/DrakeRHEE/aidlc-prework/archive/refs/heads/main.tar.gz | tar -xz --strip-components=1 -C .aidlc-prework
```

Windows PowerShell:

```powershell
$z="$env:TEMP\aidlc-prework.zip"; Invoke-WebRequest https://github.com/DrakeRHEE/aidlc-prework/archive/refs/heads/main.zip -OutFile $z; Expand-Archive $z -DestinationPath "$env:TEMP\aidlc-prework" -Force; Copy-Item "$env:TEMP\aidlc-prework\aidlc-prework-main" .aidlc-prework -Recurse -Force
```

> 레포가 비공개인 동안에는 GitHub CLI로 받습니다 (접근 권한 필요):
> `gh repo clone DrakeRHEE/aidlc-prework .aidlc-prework -- --depth 1`

### 2) AI 도구를 열고 한 줄 입력하기

| 도구 | 열기 | 에이전트 |
|---|---|---|
| Claude Code | 실습 폴더에서 `claude` | 일반 채팅 (`/aidlc` 아님) |
| Kiro IDE | 실습 폴더 열기 → 새 채팅 | 에이전트 선택기에서 **Default** (aidlc 아님) |
| Kiro CLI | 실습 폴더에서 `kiro-cli --v3` | aidlc가 기본이면 `/agent swap`으로 기본 에이전트 선택 |

채팅에 붙여 넣기:

```text
.aidlc-prework/PREWORK.md를 읽고, 그 지침대로 Step 1부터 끝까지 나와 상담하면서 진행해줘.
```

> 레포가 공개된 뒤 Claude Code에서는 내려받지 않고 URL만 줘도 됩니다:
> `https://raw.githubusercontent.com/DrakeRHEE/aidlc-prework/main/PREWORK.md 를 읽고 그 지침대로 진행해줘.`
> 다만 이 경우 템플릿과 검증 스크립트는 쓰지 않습니다.

### 3) 상담하며 답하기 (약 30~45분)

> 에이전트가 `ls`, `aidlc --version`, `python3 --version` 같은 **읽기 전용 명령**의 실행 허락을 구하면 허용하세요.
> 파일을 쓰기 전에는 항상 내용을 먼저 보여 주고 승인을 받습니다.

에이전트가 9단계로 진행합니다. 각 단계에서 승인해야 다음 단계로 넘어갑니다.

1. 환경 파악 → 2. 신규/기존 코드 판정 → 3. 주제와 1일 범위 → 4. Vision 초안 → 5. Tech-env 초안
→ 6. 절대 규칙 → 7. 파일 쓰기 → 8. 자체 검증 → 9. AI-DLC 준비 확인과 시작 명령 안내

끝나면 에이전트가 **워크샵 시작 명령**을 알려 줍니다. 당일 **새 채팅**(Kiro는 **aidlc** 에이전트)에서 실행하세요.

```text
/aidlc workshop --depth minimal --learnings off --summary-confirmation off ./vision.md를 읽고 거기 적힌 것을 만들어 주세요. 대화와 산출물은 한국어로 진행해 주세요.
```

직접 검증하려면 (macOS / Linux / WSL / Git Bash):

```bash
sh .aidlc-prework/scripts/check-prework.sh .
```

---

## 퍼실리테이터

- [facilitator/agenda-1day.md](facilitator/agenda-1day.md): 사전 과제형과 당일 오전형 일정, 사전 제출물
- [facilitator/kickoff-prompts.md](facilitator/kickoff-prompts.md): 참가자에게 그대로 보낼 안내문과 당일 명령어
- [checklists/readiness.md](checklists/readiness.md): 참가자 PC 준비 확인 체크리스트 (공식 readiness pass mark 기반)
- [examples/](examples/): 완성 예시 (신규: 회의실 예약 / 기존 코드: 도서 대여 API에 예약 기능 추가)

## 레포 구성

```
PREWORK.md                  # ★ 에이전트가 읽고 따르는 진행 지침
templates/                  # vision, technical-environment, project-memory 템플릿
examples/greenfield/        # 신규 프로젝트 완성 예시 (실습 폴더와 같은 경로 구조)
examples/brownfield/        # 기존 코드 완성 예시
scripts/check-prework.sh    # 읽기 전용 검증 스크립트
checklists/readiness.md     # 준비 확인 체크리스트
facilitator/                # 퍼실리테이터 자료
```

## 기준 버전과 출처

- AI-DLC [awslabs/aidlc-workflows](https://github.com/awslabs/aidlc-workflows) v2.11.4 (2026-11 기준)
- 노트 구조: [vision-document-guide.md](https://github.com/awslabs/aidlc-workflows/blob/main/docs/guide/writing-inputs/vision-document-guide.md),
  [technical-environment-guide.md](https://github.com/awslabs/aidlc-workflows/blob/main/docs/guide/writing-inputs/technical-environment-guide.md)의 short version
- AI-DLC가 버전업되면 파일 위치와 시작 명령이 바뀔 수 있습니다. 워크샵 전에 공식 문서와 대조하세요.

> 생성형 AI는 실수할 수 있습니다. 생성된 노트는 사람이 검토한 뒤 사용하세요.
