# Lab 4 — Results

## Workflow: `deploy-azure` job
Added at the bottom of `.github/workflows/ml-pipeline.yml`.

| Step | What it does |
|---|---|
| condition | runs only if variable `ACR_LOGIN_SERVER` is set; `needs: train` |
| Download release artifact | uses the **same** `release/` that passed the quality gate (same as Hugging Face) |
| Log in to ACR | `ACR_LOGIN_SERVER` (variable), `ACR_USERNAME` / `ACR_PASSWORD` (secrets) |
| Build and push | `docker build release/` → push tags `<git sha>` and `latest` |
| Optional auto-update | if `AZURE_APP_NAME` is set: `azure/login` with `AZURE_CREDENTIALS`, then `az containerapp update --image <sha>` |

Pipeline: `train` → (`deploy-hf`, `deploy-azure`) in parallel, both from one artifact.

## Azure setup (`scripts/azure_setup.sh`, run in Cloud Shell)
`YOURNAME=waleed630` → `RG=rg-mlops-waleed630`, `ACR=acrmlopswaleed630`, `APP=churn-api-waleed630`.

1. PART A — names, PART B — registry + Container Apps environment.
2. GitHub → Settings → Secrets and variables → Actions:
   variable `ACR_LOGIN_SERVER=acrmlopswaleed630.azurecr.io`, secrets `ACR_USERNAME`, `ACR_PASSWORD`.
3. Push → Actions: `train`, `deploy-hf`, `deploy-azure` green.
4. PART C — create the Container App (port 7860, external ingress) → prints the URL.
5. `python scripts/smoke_test.py https://<app-url>`

## Release and rollback
```bash
# new version
az containerapp update -n $APP -g $RG --image $ACR.azurecr.io/churn-api:<new-sha>
curl https://<app-url>/version         # -> new git_commit
# rollback
az containerapp update -n $APP -g $RG --image $ACR.azurecr.io/churn-api:<old-sha>
az containerapp revision list -n $APP -g $RG -o table
az containerapp logs show -n $APP -g $RG --tail 20
```
`/version` on Azure and on Hugging Face shows the same commit because both use the same artifact.

## Cleanup
`az group delete --name $RG --yes --no-wait`
