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

## 참가자: 시작하기

순서: **① 키트 받기 → ② AI 도구와 상담(약 30분) → ③ AI-DLC 설정 → ④ 당일 시작 명령**

AI-DLC를 설정하기 **전에** 상담하는 것을 권합니다. AI-DLC를 설정하면 그 안내 파일이 모든 채팅에 자동으로 들어가서,
상담 중에 에이전트가 AI-DLC 이야기를 꺼내거나 Kiro CLI가 워크플로 전용 에이전트로 열립니다.
이미 설정한 폴더에서도 진행은 됩니다(아래 표의 에이전트 안내를 따르세요).

### ① 실습 폴더에 키트 내려받기

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

### ② AI 도구와 상담하기

| 도구 | 열기 | 에이전트 |
|---|---|---|
| Claude Code | 실습 폴더에서 `claude` | 일반 채팅 |
| Kiro IDE | 실습 폴더 열기 → 새 채팅 | **Default** (aidlc 아님) |
| Kiro CLI | 실습 폴더에서 `kiro-cli` | 기본값 그대로. AI-DLC를 이미 설정했다면 `/agent`로 aidlc가 아닌 에이전트 선택 |

채팅에 붙여 넣기:

```text
.aidlc-prework/PREWORK.md를 읽고, 그 지침대로 나와 상담하면서 진행해줘.
```

에이전트가 6단계로 진행합니다. 각 단계에서 답하거나 승인하면 다음으로 넘어갑니다.

1. 환경과 프로젝트 유형(신규 / 기존 코드) → 2. 주제와 1일 범위 → 3. Vision 초안 → 4. Tech-env 초안
→ 5. 절대 규칙, 파일 쓰기, 검증 → 6. 남은 준비와 시작 명령

> 에이전트가 `ls`, `python3 --version` 같은 **읽기 전용 명령**의 실행 허락을 구하면 허용하세요.
> 파일은 내용을 보여 주고 승인받은 뒤에만 씁니다.

### ③ AI-DLC 설치와 설정

```bash
# 설치 (macOS / Linux / WSL)
curl -fsSL https://github.com/awslabs/aidlc-workflows/releases/latest/download/install.sh | sh
# Windows PowerShell (관리자 권한이 아닌 일반 창)
irm https://github.com/awslabs/aidlc-workflows/releases/latest/download/install.ps1 | iex

# 실습 폴더에서
aidlc config --harness claude     # Claude Code
aidlc config --harness kiro-ide   # Kiro IDE, Kiro CLI
aidlc doctor                      # "0 problems"이면 통과
```

`aidlc config`는 이미 만든 노트를 덮어쓰지 않습니다. 퍼실리테이터가 요청하면 [checklists/readiness.md](checklists/readiness.md)의 준비 확인도 합니다.

> Kiro는 2.11.3 이하에서 `--harness kiro`가 Kiro CLI V2를 뜻합니다. `kiro-ide`는 2.11.3과 2.11.4 모두에서 Kiro IDE와 Kiro CLI(v3)를 뜻하므로 이것을 씁니다.

### ④ 당일 시작 명령

**새 채팅**에서 실행합니다. Kiro IDE는 에이전트 선택기에서 **aidlc**를 고르고, Kiro CLI는 `kiro-cli --v3`로 엽니다.

```text
/aidlc workshop --depth minimal --learnings off --summary-confirmation off ./vision.md를 읽고 거기 적힌 것을 만들어 주세요. 대화와 산출물은 한국어로 진행해 주세요.
```

기존 코드(Brownfield)이면 `--project-type brownfield`를 넣습니다.

```text
/aidlc workshop --depth minimal --learnings off --summary-confirmation off --project-type brownfield ./vision.md를 읽고 거기 적힌 것을 만들어 주세요. 대화와 산출물은 한국어로 진행해 주세요.
```

### 시작 명령 설명

| 부분 | 하는 일 | 왜 |
|---|---|---|
| `workshop` | 워크샵용 scope. Ideation을 건너뛰고 Inception부터 Operation까지 실행 | 주제와 범위는 pre-work에서 정했으므로 아이디어 발굴 단계가 필요 없습니다. 테스트 전략도 Minimal이라 하루 일정에 맞습니다 |
| `--depth minimal` | stage당 질문을 2~4개로 줄임 (Standard는 5~8개) | 노트에 답이 있으니 질문을 줄여 시간을 아낍니다. 시간이 남으면 빼도 됩니다 |
| `--learnings off` | 단계마다 묻는 "다음을 위해 기억할까요?" 질문을 끔 | 멈추는 횟수를 줄입니다. learning loop를 배우는 것이 목적이면 뺍니다 |
| `--summary-confirmation off` | 답변 요약 확인을 끔 | 질문과 승인 게이트는 그대로 남고, 잘못 읽은 답은 승인 게이트에서 잡습니다 |
| `--project-type brownfield` | 기존 코드로 시작하고 Reverse Engineering을 실행 | 신규 프로젝트로 잘못 인식하는 것을 막습니다. 코드 분석에 15분 안팎 걸립니다 |
| `./vision.md를 읽고 ...` | vision note를 첫 요청의 입력으로 지정 | 이 내용으로 계획을 세웁니다 |
| `한국어로 진행해 주세요` | 대화와 산출물 언어를 정함 | AI-DLC는 요청 문장의 언어를 따릅니다. 영어로 요청하면 산출물이 영어로 나옵니다 |

Construction에 들어가기 전에 `aidlc/spaces/default/intents/<작업>/aidlc-state.md`에 `Construction Iteration: unit-major`가 있는지 확인하세요.
없으면 `aidlc engine state set-construction-iteration unit-major`를 실행합니다. Unit 하나를 끝까지 만든 뒤 다음으로 가야 결과를 빨리 볼 수 있습니다.

노트를 직접 검증하려면 (macOS / Linux / WSL / Git Bash): `sh .aidlc-prework/scripts/check-prework.sh .`

---

## 왜 이렇게 하나요?

| 하는 일 | 이유 |
|---|---|
| 워크샵 전에 pre-work notes를 만든다 | 노트 없이 `/aidlc`를 시작하면 첫 1시간이 "무엇을, 어떤 기술로" 묻고 답하는 데 쓰입니다. 미리 정리해 두면 AI-DLC의 질문이 확인 수준으로 줄어 하루 안에 코드와 테스트까지 갈 수 있습니다. AI-DLC 공식 퍼실리테이터 가이드가 권하는 방식입니다 |
| 템플릿을 직접 채우지 않고 AI와 상담한다 | 빈 템플릿을 받으면 무엇을 얼마나 써야 할지 막히기 쉽습니다. AI가 2~3개씩 질문하고 추천안을 주면 30분 안팎이면 끝나고, 하루 분량을 넘는 범위는 그 자리에서 줄여 줍니다 |
| 파일을 정해진 3곳에 둔다 | AI-DLC는 위치에 따라 읽는 방식이 다릅니다. `vision.md`는 첫 요청의 입력이 되고, `aidlc-shared/` 아래 tech-env note는 모든 단계가 참고 자료로 읽고, `memory/project.md`는 모든 단계가 규칙으로 적용합니다 |
| 1차 범위에서 뺄 것(Out of Scope)을 꼭 쓴다 | 하루 워크샵의 가장 흔한 실패는 범위가 너무 커서 설계 단계에서 시간이 끝나는 것입니다. 뺄 것을 적어 두면 AI가 범위를 키우지 않습니다 |
| 기존 코드는 "바꾸면 안 되는 것"을 적는다 | AI는 코드를 읽을 수 있지만 레거시 모듈, 운영 DB에 이미 적용된 스키마, 다른 팀이 쓰는 API처럼 손대면 안 되는 부분은 사람만 압니다 |
| 금지 목록에 이유와 대안을 쓴다 | "쓰지 마라"만 있으면 AI가 따르기는 해도 무엇으로 대신할지 판단하지 못합니다 |
| 예시 코드(기존 코드는 실제 파일 경로)를 넣는다 | 코드 생성 단계가 이 예시를 패턴으로 따라서, 새 코드가 팀의 기존 스타일과 맞습니다 |
| 키트를 폴더에 내려받는다 (URL로 읽히지 않는다) | Kiro의 `aidlc` 에이전트는 웹을 읽을 수 없고, 내려받아야 템플릿과 검증 스크립트를 함께 쓸 수 있습니다 |
| AI-DLC 설정 전에 상담한다 | `aidlc config`를 하면 AI-DLC 안내 파일이 모든 채팅에 자동으로 들어가서, 상담 중에도 에이전트가 AI-DLC를 소개하거나 워크플로 규칙을 따르려 합니다. Kiro CLI는 기본 에이전트도 워크플로 전용 `aidlc`로 바뀝니다 |
| pre-work는 Default 에이전트에서, 워크플로는 aidlc 에이전트에서 한다 (Kiro) | `aidlc` 에이전트는 워크플로 진행용이라 일반 명령이 제한되고 AI-DLC hook이 대화마다 실행됩니다 |
| 준비 확인(연습 stage 한 번)을 한다 | AI-DLC는 hook으로 승인과 진행 순서를 지킵니다. hook이 안 도는 PC는 `aidlc doctor`만으로는 드러나지 않고, 당일 "승인이 기록되지 않음" 문제로 나타납니다 |
| 시작 명령을 한국어로 쓴다 | AI-DLC는 요청 문장의 언어로 대화하고 산출물을 씁니다. 영어로 요청하면 노트가 한국어여도 산출물이 영어로 나옵니다 |
| 시작 명령은 새 채팅에서 실행한다 | pre-work 상담 내용이 워크플로 대화에 섞이지 않게 하려는 것입니다. 워크플로는 디스크의 파일을 기준으로 진행합니다 |

## 퍼실리테이터

- [facilitator/agenda-1day.md](facilitator/agenda-1day.md): 사전 과제형과 당일 오전형 일정, 사전 제출물
- [facilitator/kickoff-prompts.md](facilitator/kickoff-prompts.md): 참가자에게 그대로 보낼 안내문과 당일 명령어
- [checklists/readiness.md](checklists/readiness.md): 참가자 PC 준비 확인 체크리스트 (공식 readiness pass mark 기반)
- [examples/](examples/): 완성 예시 4종 (그중 2종은 실제 Claude Code, Kiro CLI 상담 결과물)

## 레포 구성

```
PREWORK.md                  # ★ 에이전트가 읽고 따르는 진행 지침
templates/                  # vision, technical-environment, project-memory 템플릿
examples/                   # 완성 예시 4종 (실습 폴더와 같은 경로 구조)
scripts/check-prework.sh    # 읽기 전용 검증 스크립트
checklists/readiness.md     # 준비 확인 체크리스트
facilitator/                # 퍼실리테이터 자료
```

## 기준 버전과 출처

- AI-DLC [awslabs/aidlc-workflows](https://github.com/awslabs/aidlc-workflows) v2.11.4 (2026-11 기준)
- 검증: 2026-11-16, aidlc 2.11.4에서 Claude Code(신규 프로젝트)와 Kiro CLI 3.3.0(기존 코드)으로 상담부터 `/aidlc workshop` 시작까지 실제로 실행. 결과물은 `examples/greenfield-fieldcheck`, `examples/brownfield-supplydesk`
- 노트 구조: [vision-document-guide.md](https://github.com/awslabs/aidlc-workflows/blob/main/docs/guide/writing-inputs/vision-document-guide.md),
  [technical-environment-guide.md](https://github.com/awslabs/aidlc-workflows/blob/main/docs/guide/writing-inputs/technical-environment-guide.md)의 short version
- AI-DLC가 버전업되면 파일 위치와 시작 명령이 바뀔 수 있습니다. 워크샵 전에 공식 문서와 대조하세요.

> 생성형 AI는 실수할 수 있습니다. 생성된 노트는 사람이 검토한 뒤 사용하세요.
