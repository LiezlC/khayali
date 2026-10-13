# Surefire: AI Miracles Tracker

The mirror of [Failsafe](https://failsafe.developai.co.za/), Develop AI's AI crisis tracker. Failsafe asks you to plan for the AI crisis before it happens. Surefire asks you to plan for the AI miracle so it happens.

- `surefire.html` is a working prototype: a seed record of 14 rows, checking states, a stage ladder, an intake log, and a scenario engine that drafts three scenarios with Claude. Live: https://claude.ai/artifact/CD84BV7cEQd198Fpjk4zd3 (private until you share it).

## What was kept from each input (13 Oct 2026)

Four drafts went into this: Claude Code's *Surefire* review doc, ChatGPT's review, Gemini's "Utopia" HTML, and Gemini Notebook's spreadsheet, blueprint and deck.

| Source | Kept | Dropped |
|---|---|---|
| **Claude Code (Surefire doc)** | Backbone. Invert the content and keep the checking. The **Reached** and **Held for** fields. The stage ladder Announced → Piloted → Deployed → Proven → Faded. "Three ways it goes right". Six capacities scored dreamed / tried / repeated / proven. The companion-not-rival framing. | None |
| **ChatGPT** | A scenario builder that starts from the person ("What would you love to make possible, and what gets in the way?"). Separate **What the AI did** and **What people did** fields. A **first experiment** in every scenario. A **"Could this help me?"** button on each record. A **fit rating** for every precedent (direct / analogous / inspiration). A scenario you can see before signing up. | Teal-and-chocolate palette (used a different one) |
| **Gemini "Utopia" HTML** | The hero line in full. The idea of a free MCP key, which could be a "seed". | Glassmorphism and hype copy ("impenetrable safety", "abundance engine"). The made-up "Evolve AI" brand. The tab names (Harmonization, Liberation), which say nothing a record could be checked against. |
| **Gemini Notebook** | Real, checkable seed rows (rentosertib, Aidoc, AlphaProtein Novo). The "over-indexed on fear" framing for a pitch. | "Opportunity Score 98.4" (no method). "Trillion-dollar abundance sector". "Fully autonomous miracle tracking". An enterprise-first, "offensive" posture. |

## Gemini batch: spot-check results

Five claims were checked against primary or near-primary sources on 13 Oct 2026:

- **Confirmed:** rentosertib Phase III (NCT07687459, recruiting, start Sept 2026). Aidoc's FDA clearance for 14 abdominal CT indications (Jan 2026). AlphaProtein Novo (preprint and open code, 5 Oct 2026). The PPPL "heat first" ignition paper (Phys. Rev. Lett. 137, 115102).
- **Wrong:** "Stanford CRISPR-GPT led to the first personalised CRISPR treatment for a six-year-old". The patient was an infant (KJ), treated by CHOP and Penn Medicine in 2025.
- **Misleading:** the deck says PPPL "uses AI" to find the fusion shortcut. The coverage describes a theoretical physics result and doesn't mention AI. It also calls this "Limitless Clean Energy", although no experiment can test it yet.
- **Mis-dated:** the record for clinical genome diagnosis in under 8 hours dates from 2022, not 2025–26.

This is why the checking layer matters: the most polished of the four inputs had the most errors.

## Build order

1. **Record:** a Supabase `records` table with the fields the prototype uses (`tab, made_by, stage, check, ai, people, reached, held_for, scale, limits, first_step, sources, checked_by, checked_at`). Seed 100–150 rows, all marked unchecked, with a named person checking them in batches.
2. **Harvest:** RSS and other feeds go into a raw queue, a cheap model sorts them (match, propose or reject as hype), and a person reviews them. Publish a pipeline page whose counts add up, as Failsafe does.
3. **Scenarios:** retrieval over the record, then three scenarios that cite precedents with fit ratings. Open to everyone, no account needed. The prototype already does this inside a Claude artifact.
4. **Connect:** an MCP server over the same table. Free, and no tracking beyond the key.
5. **Training:** the AI Manifestation day, with a workbook and a facilitation pack.

## Open question

Failsafe is a Cape Town peer's project (Paul McNally, Develop AI). Surefire is stronger pitched as its companion: the two halves of planning for AI, cross-linked record by record.
