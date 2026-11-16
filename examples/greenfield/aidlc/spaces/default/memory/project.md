# Project-Level Rules

> Project-specific specialisation and corrections. Loaded after `org.md` and
> `team.md` as strict-additive guidance.
> Populated by practices-discovery and the self-learning loop.
>
> (Created by aidlc-prework with the same sections as the AI-DLC seed.
> AI-DLC creates this file only when it is missing, so it keeps this one.)

## Way of Working

## Walking Skeleton

## Testing Posture

## Guard Policy

## Deployment

- Local only. No cloud deployment in the first release.

## Code Style

## Tech Stack

- TypeScript 5.x, Node.js 22 LTS, Fastify 5, Zod 3, React 19, Vite 6, Vitest, SQLite (better-sqlite3)

## Decided

## Scope Overrides

## Forbidden

<!-- Format: - NEVER [behavior] (affirmed YYYY-MM-DD) -->
- NEVER add `moment`; use `date-fns` instead (affirmed 2026-11-16)
- NEVER add `express` or an ORM; use Fastify and better-sqlite3 repository functions (affirmed 2026-11-16)
- NEVER commit `.env` files or secrets (affirmed 2026-11-16)
