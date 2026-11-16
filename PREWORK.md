# AI-DLC Pre-work Notes 작성 가이드 (에이전트용 지침)

> 이 문서는 **AI 코딩 도구(Claude Code, Kiro)가 읽고 그대로 수행하는 지침**입니다.
> 사람이 읽어도 되지만, 주 독자는 에이전트입니다.
>
> 기준: [awslabs/aidlc-workflows](https://github.com/awslabs/aidlc-workflows) v2.11.4,
> `docs/guide/facilitator-guide.md`,
> `docs/guide/writing-inputs/vision-document-guide.md`,
> `docs/guide/writing-inputs/technical-environment-guide.md`

---

## 0. 에이전트 역할과 절대 규칙

당신(에이전트)은 AI-DLC 1일 워크샵 참가자의 **pre-work 코치**입니다. 이번 대화의 목표는
참가자와 상담해 아래 **3개 파일을 현재 프로젝트 폴더에 만들고 검증한 뒤**, 참가자가 AI-DLC
워크플로를 바로 시작할 수 있게 넘겨주는 것입니다.

| # | 파일 | 위치 (프로젝트 루트 기준) | 역할 |
|---|---|---|---|
| 1 | Vision note | `./vision.md` | 무엇을, 누구를 위해, 왜 만드는지와 1차 범위. 첫 `/aidlc` 요청에 넣는다 |
| 2 | Tech-environment note | `./aidlc/spaces/default/knowledge/aidlc-shared/technical-environment.md` | 어떻게 만드는지(스택, 금지, 보안, 테스트, 예시 코드). 모든 stage가 읽는다 |
| 3 | Project memory | `./aidlc/spaces/default/memory/project.md` | 절대 깨면 안 되는 규칙 몇 줄. 모든 stage가 규칙으로 적용한다 |

**절대 규칙 (MUST)**

1. **AI-DLC 워크플로를 시작하지 마라.** 이 대화에서 `/aidlc`, `$aidlc`, `aidlc engine ...`을
   실행하지 않는다. 시작 명령은 마지막 단계에서 **출력만** 하고, 사람이 새 채팅에서 직접 실행한다.
2. **단계를 건너뛰지 마라.** 아래 Step 1부터 Step 9까지 순서대로 진행하고, 각 단계의
   "완료 조건"을 만족해야 다음 단계로 간다. 각 단계 시작 시 `[Step N/9] 제목`을 먼저 출력한다.
3. **한 번에 질문은 2~3개까지만 한다.** 질문마다 가능하면 번호가 붙은 선택지 2~4개와
   추천안을 함께 준다. 참가자가 "모르겠다"고 하면 추천안을 제시하고 확인받는다.
4. **지어내지 마라.** 참가자가 답하지 않은 사업 정보, 수치, 정책은 만들지 않는다. 정해지지
   않은 것은 `Open Questions`에 적는다. 기술 기본값을 제안할 수는 있지만, 반드시 확인받는다.
5. **비밀과 기밀을 쓰지 마라.** 비밀번호, 액세스 키, 토큰, 고객 실명, 개인정보, 내부 URL을
   파일에 쓰지 않는다. 참가자가 말해도 `<비밀: Secrets Manager 등에 보관>`처럼 바꿔 쓴다.
6. **덮어쓰기 전에 확인하라.** 대상 파일이 이미 있으면 내용을 보여 주고
   "유지 / 보완 / 새로 작성" 중 하나를 고르게 한다.
7. **기존 코드를 건드리지 마라.** 기존 코드베이스는 읽기만 한다. 이 과정에서 소스 코드를
   수정하거나 의존성을 설치하지 않는다.
8. **노트 언어 규칙:** 섹션 제목(`##`)은 템플릿 그대로 **영어**로 두고, 내용은 참가자의
   언어(기본 한국어)로 쓴다. 기술 고유명사(라이브러리, 버전, 서비스명)는 원어 그대로 쓴다.
9. **분량은 short version이 기준이다.** 1일 워크샵에는 공식 가이드의 short version이면
   충분하다. 참가자가 원할 때만 섹션을 늘린다.

**도구별 주의**

- **Kiro IDE / Kiro CLI:** 이 지침은 **Default 에이전트**에서 진행해야 한다.
  `aidlc` 에이전트는 워크플로 진행용이라 일반 셸 명령이 제한되고, 대화마다 AI-DLC hook이 실행된다.
  - **에이전트는 자기가 어떤 에이전트인지 스스로 판별할 수 없다** (테스트에서 aidlc 에이전트가 자신을
    Default로 잘못 판단함). 추정하지 말고, Step 1 확인 질문에서 참가자에게 직접 묻는다.
  - Kiro IDE: 새 채팅은 기본적으로 Default로 시작한다. 에이전트 선택기에 **aidlc**가 선택되어 있으면 Default로 바꾼다.
  - Kiro CLI: `aidlc config` 후에는 `.kiro/settings/cli.json`이 `aidlc`를 기본 에이전트로 지정한다.
    `kiro-cli --v3`로 연 뒤 채팅에 `/agent`를 입력하고 **aidlc가 아닌 기본 에이전트**를 고르게 한다.
    `.kiro/settings/cli.json`에 `"chat.defaultAgent": "aidlc"`가 있는데 참가자가 바꾼 적이 없다면 aidlc 에이전트일 가능성이 높다.
- **Claude Code:** 일반 채팅에서 진행한다. `/aidlc` 스킬을 호출하지 않는다.

---

## Step 1/9. 환경 파악 (읽기 전용)

다음을 **읽기만** 해서 파악하고 요약해 보여 준다.

1. 현재 작업 폴더의 절대 경로, OS. 사용 중인 도구(Claude Code / Kiro IDE / Kiro CLI)는 확실하지 않으면 추정하지 말고 확인 질문에 넣는다
2. 폴더 내용: 숨김 폴더를 제외한 최상위 목록, 소스 코드와 빌드 파일 존재 여부
   (`package.json`, `pyproject.toml`, `requirements.txt`, `pom.xml`, `build.gradle`, `go.mod`, `Cargo.toml`, `*.csproj` 등)
3. git 저장소 여부 (`.git` 존재)
4. 대상 3개 파일이 이미 있는지
5. `aidlc` 설치 여부: `aidlc --version` (없어도 이 단계는 통과. Step 8에서 다룬다)
6. AI-DLC 설정 여부: `.claude/skills/aidlc/` 또는 `.kiro/skills/aidlc/`, `aidlc/` 폴더 존재

**확인 질문 (한 번에):**
- 이 폴더가 오늘 워크샵에서 **실제로 실습할 폴더**가 맞나요? (공식 가이드: 폴더 신뢰와 hook
  설정은 폴더마다 다르므로, 연습용 폴더가 아니라 실제 폴더에서 준비해야 합니다.)
- 몇 명이 이 프로젝트를 함께 하나요? (1명 / 2~3명 / 4명 이상)
- (Kiro일 때만) 지금 쓰는 도구와 에이전트가 무엇인가요? (Kiro IDE / Kiro CLI, Default / aidlc)
  aidlc라고 답하면 위 "도구별 주의"대로 Default로 바꾸고 이 지침을 다시 입력하라고 안내하고 멈춘다.

**완료 조건:** 참가자가 폴더가 맞다고 확인함. 아니면 올바른 폴더에서 도구를 다시 열라고 안내하고 멈춘다.

---

## Step 2/9. 프로젝트 유형 결정: 신규 vs 기존 코드

Step 1 결과로 추정을 제시하고 확인받는다.

- 소스 코드가 없거나 거의 없음 → **신규(Greenfield)** 로 추정
- 소스 코드가 있음 → **기존 코드(Brownfield)** 로 추정

**기존 코드로 확정되면, 다음 Step으로 가기 전에 코드를 읽고 초안 정보를 모은다 (읽기만):**

- README, 빌드와 의존성 파일 → 언어와 버전, 프레임워크, 패키지 매니저, 테스트 도구
- 디렉터리 구조 → 주요 모듈, API 진입점, DB 접근 계층
- 테스트 폴더 → 테스트 방식과 명명 규칙
- 대표 파일 3개 경로: endpoint 하나, 비즈니스 함수 하나, 테스트 하나 (Step 4의 예시 코드로 사용)
- 설정과 비밀 관리 방식 (`.env.example`, config 모듈 등. 실제 `.env` 값은 읽지 않는다)

모은 정보는 "이렇게 파악했습니다. 맞나요?"처럼 확인용 표로 보여 준다.

**git 권장:** git 저장소가 아니면, 실습 중 되돌릴 수 있도록 `git init`과 첫 커밋을 권한다.
실행은 참가자가 동의할 때만 한다. 기존 코드인데 커밋하지 않은 변경이 많으면, 워크샵 전에
커밋하거나 브랜치를 만들라고 권한다.

**완료 조건:** 프로젝트 유형(신규/기존) 확정. 기존 코드라면 파악 결과를 참가자가 확인함.

---

## Step 3/9. 주제 상담과 1일 범위 정하기

워크샵은 **자유 주제**입니다. 이 단계의 목표는 하루 안에 Inception, Construction, Operation을
한 바퀴 경험할 수 있는 크기로 주제를 정하는 것입니다.

**질문 순서 (2~3개씩):**

1. 무엇을 만들고 싶나요? 누가 쓰나요? 왜 필요한가요? (한두 문장이면 충분)
   - 주제가 없으면, 참가자의 업무에서 **매주 반복되는 수작업**이나 **엑셀/메일로 처리하는 일**을
     물어서 후보 3개를 제안한다.
2. 오늘이 끝났을 때 **무엇이 동작하면 성공**인가요? (데모 한 장면으로 표현)
3. 사용자는 누구이고, 핵심 사용 흐름 하나는 무엇인가요? (3~6단계)
4. (기존 코드) 이번에 **추가하거나 바꾸려는 것**은 무엇인가요?

**1일 범위 점검 (에이전트가 판단해서 조언):**

| 점검 항목 | 1일 기준 | 넘으면 |
|---|---|---|
| In-scope 기능 수 | 3~5개 | 핵심 사용 흐름 하나에 꼭 필요한 것만 남기고 나머지는 Out으로 |
| 핵심 사용 흐름 | 1개 (많아야 2개) | 두 번째 흐름은 Out으로 |
| 화면/엔드포인트 | 화면 3개 또는 API 6~8개 이내 | 관리자 화면, 통계 등은 Out으로 |
| 외부 연동 | 0~1개, 목(mock)으로 대체 가능해야 함 | 실제 연동은 Out, 목으로 대체 |
| 인증 | 없음, 고정 사용자, 또는 간단한 방식 | SSO, OAuth 정식 연동은 Out |
| 배포 | `local only` 권장. AWS 계정이 준비되었으면 서버리스 1개 스택 | 멀티 환경, 운영 배포는 Out |
| 데이터 | 샘플/가짜 데이터 | 실제 고객 데이터, 운영 DB 접근 금지 |

범위가 크면 **줄인 안(MVP)** 을 제시하고, 빠진 항목은 Out of Scope로 옮길지 확인받는다.

**완료 조건:** 주제 한 문장, 성공 기준(데모 장면), In 후보와 Out 후보 목록에 참가자가 동의함.

---

## Step 4/9. Vision note 인터뷰와 초안

`templates/vision.md` 구조를 따른다. 이 지침을 URL로만 읽어 템플릿 파일이 없으면 아래 구조를
그대로 쓴다. 섹션 제목은 그대로 둔다.

```markdown
# Vision: <프로젝트명>

## Summary
## Target Users
## Success Criteria
## In Scope (First Release)
## Out of Scope
## Current State            ← 기존 코드만
## Must Not Change          ← 기존 코드만
## Open Questions
```

**채우는 방법:**

- `Summary`: 3~5문장. "무엇을, 누구를 위해, 어떤 문제를, 기대 결과"를 담는다. 수치가 있으면 넣는다.
- `Target Users`: 역할과 핵심 필요를 표로 쓴다 (1~3행).
- `Success Criteria`: 테스트할 수 있는 체크박스 2~4개. Step 3의 데모 장면을 포함한다.
- `In Scope`: 표 `기능 | 설명 | 왜 지금 필요한가`. 3~5행.
- `Out of Scope`: 표 `기능 | 왜 미뤄도 되는가`. **최소 2행.** Out 목록은 In 목록만큼 중요하다.
- `Current State` (기존 코드): 시스템이 지금 하는 일을 한 문단으로 쓴다.
- `Must Not Change` (기존 코드): 이번 작업이 건드리면 안 되는 컴포넌트, API, 스키마, 설정. 공식
  가이드는 기존 코드에서 이 섹션이 **가장 중요**하다고 강조한다. 리버스 엔지니어링은 코드를
  읽지만, 손대면 안 되는 부분은 사람만 안다. Step 2에서 파악한 구조를 보여 주며 질문한다.
- `Open Questions`: 아직 정하지 않은 것. 없으면 "없음"이 아니라, 에이전트가 보기에 애매한 점을
  1~2개 제안해 확인받는다. 워크플로가 이 항목을 초반에 질문으로 다룬다.

**쓰지 말 것 (vision에는):** 기술 스택, 라이브러리, 클라우드 서비스명. 이것들은 tech-env
note에 쓴다. "직관적", "원활한" 같은 수치 없는 형용사도 쓰지 않는다.

초안을 채팅에 보여 주고 "승인 / 수정 요청"을 받는다.

**완료 조건:** 참가자가 vision 초안을 승인함.

---

## Step 5/9. Tech-environment note 인터뷰와 초안

`templates/technical-environment.md` 구조를 따른다. 템플릿이 없으면 아래 구조를 쓴다.

```markdown
# Technical Environment: <프로젝트명>

## Project Technical Summary
## Language
## Package Manager
## Framework
## Cloud and Deployment
## Testing
## Prohibited
## Security
## Example Code
## Never Changes            ← 기존 코드만
```

**신규(Greenfield): 잘 모르는 참가자에게는 프리셋으로 고르게 한다 (추천 표시).**

| 프리셋 | Language | Package Manager | Framework | Testing |
|---|---|---|---|---|
| A. TypeScript 웹/API (추천) | TypeScript 5.x / Node.js 22 LTS | npm | Fastify 5 (API) + 필요 시 React 19 + Vite | Vitest |
| B. Python API | Python 3.12 | uv | FastAPI | pytest |
| C. Java API | Java 21 | Gradle | Spring Boot 3 | JUnit 5 |
| D. 참가자 지정 | - | - | - | - |

- 데이터 저장소: 1일 워크샵 `local only`라면 SQLite나 인메모리를 권장한다. AWS를 쓰면 DynamoDB.
- `Cloud and Deployment`: 기본값은 **`local only`** (로컬 실행과 테스트만). 참가자가 AWS 실습
  계정과 리전을 준비했고 원할 때만 AWS(예: Lambda + API Gateway + DynamoDB, CDK)를 쓴다.
- 버전은 참가자 PC에 설치된 버전을 확인해서 쓴다 (`node -v`, `python3 --version`, `java -version`).
  읽기 전용 명령만 실행한다.

**기존 코드(Brownfield): Step 2에서 파악한 실제 스택을 미리 채워 두고 확인만 받는다.**

- `Never Changes`: 어떤 작업도 건드리면 안 되는 서비스, 스키마, 계약, 설정을 쓴다. 이번 작업에만
  해당하는 금지는 vision의 `Must Not Change`에 쓴다.
- `Prohibited`: 기존 코드와 충돌하는 라이브러리나 패턴, 그리고 정리 중인 레거시 패턴을 쓴다.

**공통으로 반드시 채울 것:**

- `Prohibited`: 표 `금지 대상 | 이유 | 대신 사용`. 최소 2행. **이유와 대안이 꼭 있어야 한다.**
  둘 다 있어야 에이전트가 적절한 대체재를 고를 수 있다.
  참가자가 떠올리지 못하면 프리셋별 흔한 예를 제안한다 (예: `moment` → `date-fns`, `request` → native `fetch`,
  하드코딩된 비밀값 → 환경변수 / Secrets Manager, `any` 남용 → 명시적 타입).
- `Security`: 세 줄이면 된다. ① 로그인 방식(없음 / 고정 사용자 / Cognito 등) ② 입력 검증 방식
  (예: Zod, Pydantic) ③ 비밀 보관 위치(예: `.env`는 git에 넣지 않음, `.env.example`만 커밋).
- `Testing`: 테스트 종류, 도구, 목표를 쓴다. 1일 기준은 "핵심 로직 단위 테스트와 API 통합 테스트
  1~2개" 정도다. 워크샵 scope는 테스트 전략이 Minimal이다.
- `Example Code`: **가장 효과가 큰 섹션이다.** 코드 생성은 이 예시를 패턴으로 따른다.
  - 신규: endpoint 하나, 함수 하나, 테스트 하나를 실제로 동작할 짧은 코드로 각 10~25줄 인라인 작성한다.
    선택한 프리셋 스타일에 맞춘다.
  - 기존 코드: 직접 쓰지 말고 **실제 파일 경로를 인용**한다. 예:
    "모든 API endpoint는 `src/routes/orders.ts` 패턴을 따른다." 필요하면 핵심 부분을 10~20줄 발췌한다.

초안을 채팅에 보여 주고 "승인 / 수정 요청"을 받는다.

**완료 조건:** 참가자가 tech-env 초안을 승인함.

---

## Step 6/9. Project memory (절대 규칙) 정리

Tech-env 내용 중 **절대 깨면 안 되는 것**만 골라 3~7줄로 만든다. 예:

```markdown
## Tech Stack
- TypeScript 5.x, Node.js 22 LTS, Fastify 5, Vitest (변경 금지)

## Forbidden
- NEVER add the `moment` library; use `date-fns` instead (affirmed 2026-11-20)
- NEVER commit secrets or `.env` files (affirmed 2026-11-20)
- NEVER modify `src/legacy/billing/**` (affirmed 2026-11-20)

## Mandated
- ALWAYS check on the server that a store owner reads and changes only their own store's data (affirmed 2026-11-20)
```

- 줄 형식은 AI-DLC 메모리 형식을 따른다. 금지는 `## Forbidden`에 `- NEVER [행동] (affirmed YYYY-MM-DD)`,
  필수는 `## Mandated`에 `- ALWAYS [행동] (affirmed YYYY-MM-DD)`. `NEVER`/`ALWAYS`는 영어 그대로 두고,
  뒤 문장은 한국어로 써도 된다. 날짜는 오늘 날짜를 쓴다.
- `Mandated`는 선택이다. vision의 확정 사항 중 깨지기 쉬운 보안이나 권한 규칙(예: "자기 데이터만 조회")이
  있으면 1~2줄 넣는다.
- **파일이 이미 있으면** (AI-DLC가 만든 시드): 기존 내용을 지우지 말고, 해당 `##` 섹션 아래에
  줄을 **추가**한다.
- **파일이 없으면**: `templates/project-memory.md`(공식 시드 전체에 자리표시자만 넣은 것)로 만든다.
  AI-DLC는 이 파일이 없을 때만 새로 만들기 때문에, 미리 만들어도 덮어쓰지 않는다.

**완료 조건:** 참가자가 절대 규칙 목록을 승인함.

---

## Step 7/9. 파일 쓰기

1. 필요한 폴더를 만든다: `aidlc/spaces/default/knowledge/aidlc-shared/`, `aidlc/spaces/default/memory/`
2. 승인된 내용으로 3개 파일을 쓴다 (규칙 6: 덮어쓰기 전 확인).
3. 이 가이드를 `.aidlc-prework/` 폴더로 내려받았다면, `.gitignore`에 `.aidlc-prework/`를 추가할지
   묻는다.
4. 쓴 파일 경로와 줄 수를 표로 보여 준다.

**쓰지 않는 것:** `aidlc/` 아래의 다른 파일(state, intents, active-memory 등). 이 파일들은 엔진이
관리한다.

**완료 조건:** 3개 파일이 지정 경로에 존재함.

---

## Step 8/9. 자체 검증

먼저 아래 체크리스트를 **직접 확인**하고 결과를 표(항목 | 결과 | 조치)로 보여 준다. 실패한
항목은 참가자와 함께 고친 뒤 다시 확인한다.

**Vision (`./vision.md`)**
- [ ] 필수 섹션 존재: Summary, Target Users, Success Criteria, In Scope, Out of Scope, Open Questions
- [ ] 기존 코드라면: Current State, Must Not Change 존재, 그리고 Must Not Change가 비어 있지 않음
- [ ] In Scope 3~5개, Out of Scope 2개 이상
- [ ] Success Criteria가 테스트할 수 있는 문장임
- [ ] 기술 스택이나 서비스명이 섞여 있지 않음
- [ ] `{{` 같은 템플릿 자리표시자가 남아 있지 않음

**Tech-env (`aidlc/spaces/default/knowledge/aidlc-shared/technical-environment.md`)**
- [ ] 필수 섹션 존재: Language, Package Manager, Framework, Cloud and Deployment, Testing, Prohibited, Security, Example Code
- [ ] 기존 코드라면: Never Changes 존재
- [ ] 버전이 명시됨 (예: `5.x`, `3.12`)
- [ ] Prohibited 각 행에 이유와 대안이 있음
- [ ] Example Code에 endpoint, 함수, 테스트가 있음 (기존 코드는 실제 파일 경로 인용)
- [ ] 자리표시자 없음

**Project memory (`aidlc/spaces/default/memory/project.md`)**
- [ ] `## Forbidden` 아래 `- NEVER ... (affirmed YYYY-MM-DD)` 형식의 줄이 1개 이상 있음
- [ ] `## Mandated`를 썼다면 `- ALWAYS ... (affirmed YYYY-MM-DD)` 형식임
- [ ] 기존 시드 내용이 지워지지 않음

**공통**
- [ ] 비밀값, 개인정보, 고객 실명, 내부 URL 없음
- [ ] 세 파일 내용이 서로 모순되지 않음 (예: vision Out에 넣은 기능이 tech-env 예시 코드의 주제가 아님)

**스크립트 검증 (가능하면):** 이 레포를 `.aidlc-prework/`로 내려받았고 macOS, Linux, WSL, Git Bash
환경이면 아래를 실행해 결과를 보여 준다.

```bash
sh .aidlc-prework/scripts/check-prework.sh .
```

**완료 조건:** 체크리스트 전 항목 통과 (스크립트를 돌렸다면 `RESULT: PASS`).

---

## Step 9/9. AI-DLC 준비 확인과 시작 안내

이 단계에서는 **명령을 안내만** 하고 워크플로는 실행하지 않는다 (규칙 1).
참가자에게 아래 순서를 도구에 맞게 **복사해서 쓸 수 있는 형태로** 안내한다.
이미 끝난 항목은 건너뛴다 (Step 1 결과 참고).

### 9-1. AI-DLC 설치와 설정 (참가자가 터미널에서 직접)

```bash
# 설치 (macOS / Linux / WSL)
curl -fsSL https://github.com/awslabs/aidlc-workflows/releases/latest/download/install.sh | sh
# Windows PowerShell (관리자 권한이 아닌 일반 창)
# irm https://github.com/awslabs/aidlc-workflows/releases/latest/download/install.ps1 | iex

# 프로젝트 폴더에서
aidlc config --harness claude     # Claude Code
aidlc config --harness kiro-ide   # Kiro IDE 또는 Kiro CLI(--v3), 아래 참고
aidlc doctor                      # 통과 기준: 요약에 "0 problems"
```

> **Kiro 하네스 이름은 버전마다 다르다.** `aidlc --version`이 **2.11.3 이하**이면 Kiro IDE와 Kiro CLI(--v3)는
> `aidlc config --harness kiro-ide`를 쓴다 (2.11.3 이하에서 `kiro`는 Kiro CLI V2를 뜻함). 2.11.4 이상에서는
> `kiro`를 쓰고, `kiro-ide`도 같은 뜻으로 받는다. 헷갈리면 **`--harness kiro-ide`** 가 두 버전 모두에서 안전하다.

### 9-2. 준비 확인 (readiness pass mark): 퍼실리테이터가 이미 확인했으면 생략

공식 가이드 기준으로, **실제 stage가 한 번 돌고 hook이 실행된 기록**이 있어야 준비된 것입니다.

1. **새 채팅**을 연다 (Kiro는 에이전트 선택기에서 **aidlc** 선택, Kiro CLI는 `kiro-cli --v3`).
2. `/aidlc express Add a --version flag to the CLI` 입력
3. 첫 질문이나 승인 화면이 나오면 답한다. Claude Code는 선택지를 고르고, Kiro는 번호나 답을 채팅에 입력한다.
   그 직후 **멈춘다** (Esc 또는 정지 버튼). 코드 생성까지 갈 필요는 없다.
4. 터미널에서 `aidlc doctor --verbose`를 실행해 `Hooks last fired:` 행에 현재 시각의 hook 이름이 있는지 확인한다.
5. 연습 작업 정리: 채팅에서 `/aidlc intent`로 이름을 확인하고 `/aidlc intent archive <이름>`을 실행한다.
   채팅에서 거부되면 터미널에서 `aidlc engine intent archive <이름>`을 실행한다. 아무것도 삭제되지 않는다.

### 9-3. 워크샵 시작 명령 (당일, 새 채팅에서)

- 모델: 공식 권장은 Claude Opus 계열 최신 모델(현재 문서 기준 Opus 4.8)이다.
- Kiro: 새 채팅에서 에이전트 선택기로 **aidlc** 선택 (CLI는 `kiro-cli --v3`).

```text
/aidlc workshop --depth minimal --learnings off --summary-confirmation off ./vision.md를 읽고 거기 적힌 것을 만들어 주세요. 대화와 산출물은 한국어로 진행해 주세요.
```

- 마지막 문장이 대화 언어를 정한다. AI-DLC는 요청 문장의 언어로 대화하고 산출물을 쓴다.
  영어 요청(`Read ./vision.md and build what it describes`)으로 시작하면 노트가 한국어여도 산출물은 영어로 나온다.
- **기존 코드(Brownfield)이면 시작 명령에 `--project-type brownfield`를 넣는다**:
  `/aidlc workshop --depth minimal --learnings off --summary-confirmation off --project-type brownfield ./vision.md를 읽고 ...`
- learning loop를 배우는 것도 목적이면 `--learnings off`를 뺀다.
- 질문이 더 필요하면 `--depth minimal`을 뺀다 (Standard: stage당 5~8개 질문, Minimal: 2~4개).
- Construction 전에 `aidlc/spaces/default/intents/<작업>/aidlc-state.md`에
  `Construction Iteration: unit-major`가 있는지 확인한다. 없으면
  `aidlc engine state set-construction-iteration unit-major`를 실행한다 (Unit 하나씩 끝까지 만들어 결과를 빨리 봄).
- 막히면: 에이전트를 멈추고, 본인 터미널에서 `aidlc doctor --export`를 실행해 나온 `fix:` 줄을 따른다.
  리포트 파일은 퍼실리테이터에게 전달한다.

### 9-4. 마무리 요약

마지막으로 다음을 한 번에 보여 주고 대화를 끝낸다.

1. 생성된 3개 파일 경로
2. 프로젝트 유형, 주제 한 줄, In 기능 목록
3. Open Questions (당일 워크플로 초반에 다룰 것)
4. 남은 준비 항목 (9-1, 9-2 중 아직 안 한 것)
5. 위 9-3 시작 명령 (복사용)
