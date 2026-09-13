#!/usr/bin/env bash
# Docs lint: verify every topic markdown file contains the required sections.
#
# Topic files  = all *.md in the content directories below, excluding README.md
# Required H2s = "Table of Contents", "Trade-offs", "Interview Tips"
#
# Exits non-zero and emits GitHub error annotations for every violation.

set -euo pipefail

# Content directories holding topic files
DIRS=(
  system-basics
  scalability
  architecture
  data-engineering
  cloud-native
  observability
  security
  testing
  modern-architectures
  compliance
  case-studies
  best-practices
)

# Required H2 sections, matched case-insensitively
REQUIRED=(
  "Table of Contents"
  "Trade-offs"
  "Interview Tips"
)

failed=0
summary=""

for dir in "${DIRS[@]}"; do
  for file in "$dir"/*.md; do
    [ -e "$file" ] || continue
    base="$(basename "$file")"
    [ "$base" = "README.md" ] && continue

    missing=()
    for section in "${REQUIRED[@]}"; do
      if ! grep -qiE "^##[[:space:]]+${section}[[:space:]]*$" "$file"; then
        missing+=("$section")
      fi
    done

    if [ "${#missing[@]}" -gt 0 ]; then
      failed=1
      echo "::error file=${file}::Missing required section(s): ${missing[*]}"
      summary="${summary}- \`${file}\`: missing ${missing[*]}"$'\n'
    fi
  done
done

if [ "$failed" -eq 1 ]; then
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    {
      echo "### ❌ Topic files missing required sections"
      echo
      printf '%s' "$summary"
    } >> "$GITHUB_STEP_SUMMARY"
  fi
  echo "Docs lint failed: see errors above."
  exit 1
fi

echo "✅ All topic files contain the required sections: ${REQUIRED[*]}"
