# LLM Responses — Round 001

Raw, verbatim responses from each LLM. NEVER edit these files. Aggregation happens in `../05_synthesis.md`.

## Files (filled during round)

| File | LLM | Status |
|---|---|---|
| `claude_sonnet_4.7.md` | Anthropic Claude Sonnet 4.7 (via claude.ai) | PENDING |
| `gpt_5.md` | OpenAI GPT-5 (via chatgpt.com) | PENDING |
| `gemini_2_pro.md` | Google Gemini 2 Pro (via gemini.google.com) | PENDING |

## File format

Every response file MUST start with a YAML frontmatter block:

```markdown
---
provider: anthropic | openai | google
model: <exact model name as the chat displayed>
model_date: YYYY-MM-DD (date the chat happened)
chat_url: <if the LLM persists shareable URLs>
prompt_version: round_001/00_brief.md (git sha: <8-char hash>)
prompt_hash_sha256: <hash of 00_brief.md at time of dispatch>
attachments_uploaded:
  - 00_brief.md
  - 01_context/app_overview.md
  - 01_context/design_system_summary.md
  - 01_context/reusability_audit_summary.md
  - 02_screenshots/01_lane_dashboard_kanban.png
  - ... (full list)
  - 03_code_samples/filter_panel.ex
  - ... (full list)
captured_at: YYYY-MM-DDTHH:MM:SSZ
captured_by: cc
notes: <any deviation, e.g. "model declined to download 02_screenshots/15_grok_demo.png; cc pasted it inline">
---

# Response

<verbatim LLM output — no edits, no truncation>

## Follow-up turns (if any)

### cc:
<follow-up question>

### LLM:
<follow-up response>
```

## Why provenance matters

Synthesis (`05_synthesis.md`) cites findings by file + section. If a response file is edited after capture, the citation chain breaks. Frontmatter + verbatim preservation = audit trail.

If the LLM produces something problematic (e.g. citation to nonexistent file, hallucinated screenshot reference), DO NOT edit the response. Note the issue in `05_synthesis.md` under "Discarded findings" with rationale.

## Capture protocol

1. Open new chat with the LLM
2. Upload all attachments (zip the round folder if supported; else one-by-one)
3. Paste `00_brief.md` content as the first message
4. Wait for response
5. Copy the response verbatim into the corresponding `*_response.md` file
6. Add the YAML frontmatter
7. Commit with message `iter 263 round 001: capture <llm> response`

## Anti-patterns

- ❌ Paraphrasing the LLM "for clarity" in the response file
- ❌ Skipping the YAML frontmatter to "save time"
- ❌ Combining multiple LLM responses into one file
- ❌ Editing the response to fix the LLM's typos
- ❌ Discarding "useless" parts of the response — they're useful for calibrating the LLM's reliability over rounds
