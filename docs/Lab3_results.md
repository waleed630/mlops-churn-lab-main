# Lab 3 — Results

## Quality gate (`src/check_gate.py`)
```
$ python -m src.check_gate            # min_f1: 0.55
QUALITY GATE PASSED: f1=0.62 >= min_f1=0.55     (exit code 0)

$ python -m src.check_gate            # min_f1: 0.90
QUALITY GATE FAILED: f1=0.62 < min_f1=0.9       (exit code 1)
```
`min_f1` set back to 0.55 afterwards.

## Workflow (`.github/workflows/ml-pipeline.yml`)
Moved from `workflow_templates/` with `git mv`.

| Job | What it does |
|---|---|
| `train` | install → `pytest tests/test_prepare.py` → `dvc repro` → quality gate → `pytest tests/test_api.py` → build `release/` → upload artifact `release` |
| `deploy-hf` | `needs: train`, runs only if `vars.HF_SPACE` is set; downloads the **same** `release` artifact and uploads it to the Space |

- Triggers: `push` and `workflow_dispatch` (manual run from the Actions tab).
- `HF_TOKEN` comes from `secrets.HF_TOKEN`, `HF_SPACE` from `vars.HF_SPACE`. No tokens in code.
- If the gate fails, `train` fails and `deploy-hf` is skipped, so the live Space keeps the old good model.

## Hugging Face setup
1. huggingface.co → New Space `churn-api`, SDK **Docker**, Public.
2. Create a **Write** access token.
3. GitHub repo → Settings → Secrets and variables → Actions:
   secret `HF_TOKEN`, variable `HF_SPACE = <hf-username>/churn-api`.
4. Push → Actions → `train` then `deploy-hf` green.
5. `python scripts/smoke_test.py https://<hf-username>-churn-api.hf.space`
