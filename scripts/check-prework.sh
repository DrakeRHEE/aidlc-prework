#!/bin/sh
# AI-DLC pre-work notes checker.
# Usage: sh check-prework.sh [project-root]
# Read-only: it never modifies files.
set -u

ROOT="${1:-.}"
VISION="$ROOT/vision.md"
TECH="$ROOT/aidlc/spaces/default/knowledge/aidlc-shared/technical-environment.md"
MEMORY="$ROOT/aidlc/spaces/default/memory/project.md"

FAIL=0
WARN=0
pass() { printf '  [ok]   %s\n' "$1"; }
fail() { printf '  [FAIL] %s\n' "$1"; FAIL=$((FAIL + 1)); }
warn() { printf '  [warn] %s\n' "$1"; WARN=$((WARN + 1)); }

# Count table data rows under a "## Heading" (excluding header and separator rows).
table_rows() {
  awk -v h="## $2" '
    $0 == h || index($0, h " ") == 1 { inside = 1; next }
    inside && /^## / { inside = 0 }
    inside && /^\|/ { n++ }
    END { print (n > 2 ? n - 2 : 0) }
  ' "$1"
}

# Non-empty, non-comment content lines under a "## Heading".
section_lines() {
  awk -v h="## $2" '
    $0 == h || index($0, h " ") == 1 { inside = 1; next }
    inside && /^## / { inside = 0 }
    inside && /<!--/ { c = 1 }
    inside && !c && NF > 0 { n++ }
    inside && /-->/ { c = 0 }
    END { print n + 0 }
  ' "$1"
}

has_heading() { grep -Eq "^## $2( |\$)" "$1"; }

check_headings() {
  file="$1"; shift
  for h in "$@"; do
    if has_heading "$file" "$h"; then pass "section: $h"; else fail "missing section: ## $h"; fi
  done
}

check_common() {
  file="$1"
  if grep -n '{{' "$file" >/dev/null 2>&1; then
    fail "template placeholders left: $(grep -c '{{' "$file") line(s) with '{{'"
  else
    pass "no template placeholders"
  fi
  if grep -Eqi '(AKIA[0-9A-Z]{16}|aws_secret_access_key|-----BEGIN [A-Z ]*PRIVATE KEY|ghp_[A-Za-z0-9]{20,}|xox[bp]-[A-Za-z0-9-]+|password[[:space:]]*[:=][[:space:]]*[^[:space:]<{]+)' "$file"; then
    fail "possible secret found (remove it)"
  else
    pass "no obvious secrets"
  fi
}

BROWNFIELD=0
echo "== Vision note: $VISION"
if [ -f "$VISION" ]; then
  check_headings "$VISION" "Summary" "Target Users" "Success Criteria" "In Scope" "Out of Scope" "Open Questions"
  if has_heading "$VISION" "Current State" || has_heading "$VISION" "Must Not Change"; then
    BROWNFIELD=1
    echo "  (existing codebase detected)"
    check_headings "$VISION" "Current State" "Must Not Change"
    if [ "$(section_lines "$VISION" "Must Not Change")" -ge 1 ]; then pass "Must Not Change has content"; else fail "Must Not Change is empty"; fi
  fi
  n=$(table_rows "$VISION" "In Scope")
  if [ "$n" -ge 1 ] && [ "$n" -le 5 ]; then pass "In Scope features: $n"
  elif [ "$n" -gt 5 ]; then warn "In Scope has $n features (1-day target is 3-5)"
  else fail "In Scope table has no rows"; fi
  n=$(table_rows "$VISION" "Out of Scope")
  if [ "$n" -ge 2 ]; then pass "Out of Scope features: $n"; else fail "Out of Scope needs at least 2 rows (has $n)"; fi
  if grep -Eq '^- \[ \]|^- \[x\]' "$VISION"; then pass "checkbox criteria present"; else warn "Success Criteria has no checkboxes"; fi
  check_common "$VISION"
else
  fail "file not found"
fi

echo "== Tech-environment note: $TECH"
if [ -f "$TECH" ]; then
  check_headings "$TECH" "Language" "Package Manager" "Framework" "Cloud and Deployment" "Testing" "Prohibited" "Security" "Example Code"
  [ "$BROWNFIELD" -eq 1 ] && check_headings "$TECH" "Never Changes"
  n=$(table_rows "$TECH" "Prohibited")
  if [ "$n" -ge 2 ]; then pass "Prohibited rows: $n"; else fail "Prohibited needs at least 2 rows with reason and alternative (has $n)"; fi
  # Every Prohibited data row must have 3 non-empty cells.
  bad=$(awk '
    $0 == "## Prohibited" { inside = 1; next }
    inside && /^## / { inside = 0 }
    inside && /^\|/ { r++; if (r <= 2) next
      n = split($0, c, "|"); empty = 0
      for (i = 2; i <= 4; i++) { gsub(/^[ \t]+|[ \t]+$/, "", c[i]); if (c[i] == "" || c[i] == "-") empty = 1 }
      if (n < 5 || empty) bad++ }
    END { print bad + 0 }' "$TECH")
  if [ "$bad" -eq 0 ]; then pass "every Prohibited row has reason and alternative"; else fail "$bad Prohibited row(s) missing reason or alternative"; fi
  if grep -Eq '[0-9]+\.(x|[0-9]+)' "$TECH"; then pass "versions stated"; else warn "no version numbers found (e.g. 5.x, 3.12)"; fi
  if grep -q '^```' "$TECH" || grep -Eq '`[^`]+/[^`]+`' "$TECH"; then pass "Example Code has code or file references"; else fail "Example Code has no code block or file path"; fi
  check_common "$TECH"
else
  fail "file not found"
fi

echo "== Project memory: $MEMORY"
if [ -f "$MEMORY" ]; then
  if grep -Eq '^- NEVER .+\(affirmed [0-9]{4}-[0-9]{2}-[0-9]{2}\)' "$MEMORY"; then
    pass "Forbidden rule(s): $(grep -Ec '^- NEVER .+\(affirmed [0-9]{4}-[0-9]{2}-[0-9]{2}\)' "$MEMORY")"
  else
    fail "no '- NEVER ... (affirmed YYYY-MM-DD)' rule"
  fi
  check_common "$MEMORY"
else
  fail "file not found"
fi

echo
if [ "$FAIL" -eq 0 ]; then
  echo "RESULT: PASS ($WARN warning(s))"
  exit 0
fi
echo "RESULT: FAIL ($FAIL problem(s), $WARN warning(s))"
exit 1
