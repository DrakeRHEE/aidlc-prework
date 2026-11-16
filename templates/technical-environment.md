<!--
  AI-DLC Technical Environment note 템플릿 (short version 기반)
  저장 위치: aidlc/spaces/default/knowledge/aidlc-shared/technical-environment.md
  섹션 제목(##)은 영어 그대로 두고, 내용은 한국어로 작성합니다.
  이중 중괄호 자리표시자는 모두 채운 뒤 지웁니다.
  기존 코드(Brownfield)가 아니면 "Never Changes" 섹션을 삭제합니다.
-->
# Technical Environment: {{프로젝트명}}

## Project Technical Summary

- **Project type**: {{New / Existing codebase}}
- **Runtime environment**: {{Local only / Cloud}}
- **Team size and key skills**: {{인원, 관련 경험}}

## Language

| Language | Version | Purpose |
|----------|---------|---------|
| {{언어}} | {{버전}} | {{용도}} |

## Package Manager

- {{npm / pnpm / uv / pip / Gradle / Maven ...}} {{버전}}

## Framework

| Framework or library | Version | Area |
|----------------------|---------|------|
| {{프레임워크}} | {{버전}} | {{API / UI / Validation / Data}} |

- **Data store**: {{SQLite / In-memory / DynamoDB / PostgreSQL ...}}

## Cloud and Deployment

- {{local only: 로컬 실행과 테스트만 / AWS: 리전, 서비스, IaC 도구}}

## Testing

| Test type | Required | Target | Tooling |
|-----------|----------|--------|---------|
| Unit | Yes | {{핵심 비즈니스 로직}} | {{도구}} |
| Integration | {{Yes/No}} | {{API 1~2개 흐름}} | {{도구}} |

- **Test location**: {{소스 옆 / tests/ 폴더}}

## Prohibited

| Prohibited | Reason | Use instead |
|------------|--------|-------------|
| {{금지 대상}} | {{이유}} | {{대안}} |
| {{금지 대상}} | {{이유}} | {{대안}} |

## Security

- **Sign-in**: {{없음 / 고정 사용자 / Cognito / 기존 시스템 방식}}
- **Input validation**: {{예: 모든 외부 입력은 Zod / Pydantic 스키마로 검증}}
- **Secrets**: {{예: .env에 보관하고 git에는 .env.example만 커밋. 코드에 비밀값 금지}}

## Example Code

<!-- 신규: endpoint, 함수, 테스트를 각각 짧고 실제 동작하는 코드로 작성 -->
<!-- 기존 코드: "모든 API endpoint는 src/... 패턴을 따른다"처럼 실제 파일 경로를 인용하고 핵심만 발췌 -->

### Endpoint

```{{lang}}
{{코드}}
```

### Function

```{{lang}}
{{코드}}
```

### Test

```{{lang}}
{{코드}}
```

## Never Changes

- {{(기존 코드만) 어떤 작업도 건드리면 안 되는 서비스, 스키마, 계약, 설정}}
