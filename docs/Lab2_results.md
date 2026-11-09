# Lab 2 — Results

## API (`api/main.py`)
- Model pipeline (`models/model.joblib`) is loaded once at startup.
- `GET /health` → `{"status": "ok", "model_loaded": true}`
- `GET /version` → `{"release": "local-dev"}` (filled in by CI later)
- `POST /predict` with the example customer → `{"churn": true, "churn_probability": 0.8929}`

## Validation
- `Contract = "Ten years"` → **422**
- Missing `tenure` → **422**

## Tests
`pytest -q` → **7 passed** (3 prepare + 4 API).

## Docker
`Dockerfile` installs `requirements-serving.txt`, then copies `api/` and `models/`.
```bash
docker build -t churn-api .
docker run -p 7860:7860 churn-api
python scripts/smoke_test.py http://127.0.0.1:7860
```

## Release
`bash scripts/build_release.sh` creates `release/` with only `api/`, `models/`
(+ `release.json`), `Dockerfile`, `requirements-serving.txt` and `README.md`.
