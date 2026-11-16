# Project overrides

## Tech Stack

- Python 3.12, FastAPI 0.115, Pydantic 2, SQLAlchemy 2.0, Alembic, PostgreSQL 16, pytest, uv

## Forbidden

- NEVER change the request or response shape of existing `/loans` endpoints (affirmed 2026-11-16)
- NEVER edit existing Alembic migration files; add a new revision instead (affirmed 2026-11-16)
- NEVER use SQLAlchemy 1.x `session.query()`; use `select()` (affirmed 2026-11-16)
