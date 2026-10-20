# Mythara AI Team

[![ci](https://github.com/herbievelezjr/Mythara_AI_Team/actions/workflows/ci.yml/badge.svg)](https://github.com/herbievelezjr/Mythara_AI_Team/actions/workflows/ci.yml)

**An orchestrated back-office team for small organizations** — specialized
bots for grants, research, accounting, association management, and quality,
coordinated by a central orchestrator API and gated by a 45-framework
compliance engine. Built by Herb Velez, Mythara Labs LLC.

Extracted from [herbievelezjr/Mythara_Archive](https://github.com/herbievelezjr/Mythara_Archive)
(`core/source_proprietary/`), where the original copies remain.

## The team

| Bot | Job |
|---|---|
| **Grant Writer** | Searches the live Grants.gov API, dedupes and fit-scores opportunities, tracks infrastructure needs, analyzes winning grants |
| **Researcher** | Company research and POC validation for outreach |
| **Accounting VP** | Double-entry bookkeeping (balanced-entry enforced), AP/AR invoices, grant fund tracking, balance sheet & income statement |
| **SBGA Bot** | Small-business association membership and compliance records |
| **Sigma Six Blackbelt** | Process quality: defect tracking, process metrics, FMEA, DPMO/sigma calculations |
| **System Optimizer** | Host/process monitoring for the suite |

Bots register with the orchestrator on startup (`POST /register`;
Sigma Six uses the token-authenticated `POST /register_bot`) and degrade
gracefully to standalone mode when it is unreachable.

## The compliance engine

`unified_compliance_framework.py` (implementation:
`universal_governance_lattice.py`) validates data against **45 regulatory
frameworks** — PCI DSS, HIPAA, GDPR, SOC 2, SOX, FLSA, TCPA, FERPA, COPPA,
and 36 more — returning per-framework violations, a risk assessment, and a
tamper-evident audit trail with integrity hashes. Every framework has a
real validator and the dispatcher **fails closed**: an unimplemented or
crashing check reports a violation, never a pass. Exposed over HTTP at
`/v1/compliance/validate` and `/v1/compliance/report`.

## Quickstart

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# 1. Start the orchestrator (bots expect it on :5000)
export MYTHARA_API_KEYS='{"dev-key": {"name": "Dev", "roles": ["read", "invoke", "admin"]}}'
export VP_MASTER_TOKEN='choose-a-master-token'   # optional; enables Sigma Six registration
uvicorn main:app --port 5000

# 2. In another shell, run a bot against it
python3 -c "
from mythara_grant_writer_bot import MytharaGrantWriterBot
bot = MytharaGrantWriterBot()                    # registers with the orchestrator
for g in bot.search_grants(keywords=['solar']):  # live Grants.gov data
    print(g.get('name'), '|', g.get('grantor'))
"
```

Configuration is by environment: `MYTHARA_ORCHESTRATOR_URL` (default
`http://localhost:5000`), `MYTHARA_API_KEYS` (JSON map for API auth),
`VP_MASTER_TOKEN` (bot-registration master token).

## Tests

```bash
pytest test_compliance.py test_ai_team_bots.py -q
```

48 tests: full-module import health, bot instantiation, double-entry
rules, grant dedupe/fit scoring, DPMO math, and a coverage sweep proving
all 45 compliance frameworks have working validators.

## Honest status (repaired 2026-10-19)

This suite was extracted, audited, and repaired before being offered:
the compliance module the system imports was missing from the tree,
bot registration routes did not exist server-side, the compliance API
rejected every framework string, and 32 of 45 frameworks silently passed
unimplemented. All fixed and verified end-to-end; the repair history is
in the commit log and test files.

Known limits, stated plainly:

- The validators check that required compliance *evidence* is present
  and well-formed in a submission. They are engineering controls, **not
  legal determinations** of compliance.
- Four frameworks (NLRA, union contracts, ACLU standards, Section 508)
  are conduct scanners: they flag prohibited patterns in presented data
  rather than requiring evidence fields.
- The SBGA bot seeds a clearly labeled demo membership record;
  replace it with real details before relying on it.
- Bots are deterministic systems plus live public APIs; language-model
  work routes through the orchestrator's chat endpoints.

## License

Source-available — see [LICENSE.md](LICENSE.md). Copyright © 2025
Herbert Velez Jr. / Mythara Labs LLC (Colorado domestic LLC, filed
2026-10-04; CO SOS ID #20268239831). Production use requires a signed
written agreement — see [COMMERCIAL.md](COMMERCIAL.md).
