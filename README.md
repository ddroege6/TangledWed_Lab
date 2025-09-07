<p align="center">
  <img width="666" height="1024" alt="Image" src="https://github.com/user-attachments/assets/c766d02c-4da5-4fab-989a-4d07c03e0618" />
</p>

# 🛡️ Tangled Web Lab — DevSecOps CI/CD on AWS (Juice Shop)

A compact, reproducible lab that demonstrates **secure CI/CD**, **Infrastructure-as-Code**, and **runtime security testing** using OWASP Juice Shop on **ECS Fargate** behind an **ALB (private subnets)**.

---

## ✨ What this shows (portfolio highlights)

- **CI/CD security gates:** Gitleaks (secrets), Semgrep (SAST), Trivy (image & SBOM), ZAP Baseline (DAST)
- **IaC to AWS:** Terraform → VPC + ALB + ECS/Fargate (+ CloudWatch logs; optional WAF)
- **OIDC to AWS:** GitHub Actions assumes an AWS role (no long-lived keys)
- **Tear-down friendly:** run, screenshot, destroy (typical demo cost: **<$2** if removed same day)

---

## 🗺️ Architecture (at a glance)

- **Networking:** VPC with **private** subnets for ECS tasks; ALB in public subnets
- **Compute:** ECS Fargate service (Juice Shop container)
- **Observability:** CloudWatch log groups + (optional) alarms
- **Security tools in CI:** Gitleaks, Semgrep, Trivy, ZAP (post-deploy)
- **Images:** pulls `bkimminich/juice-shop:latest`, optionally re-tags into ECR


---

## ✅ Prerequisites

- **AWS account** with admin (for the first run)
- **OIDC Role** in AWS IAM that trusts `token.actions.githubusercontent.com` (audience `sts.amazonaws.com`)
- **GitHub repo variables** (repository → Settings → Secrets and variables → *Variables*):
  - `AWS_ACCOUNT_ID`, `AWS_REGION`, `AWS_ROLE_ARN`
- (Optional) **Semgrep**: `SEMGREP_APP_TOKEN` as a *Secret*
- **Repo → Settings → Actions → Workflow permissions**: “Read and write” if you want ZAP to open GitHub Issues for findings (or keep read-only and we’ll just upload artifacts)

---

## 🧪 Local quickstart (smoke test)

```bash
git clone https://github.com/ddroege6/tangled-web-lab.git
cd tangled-web-lab
docker compose up --pull always
# open http://localhost:3000
````

Results are written to `reports/` (and are .gitignored).

---

## 🚦 CI/CD pipeline (GitHub Actions)

Trigger: on `push` / `pull_request` (and `workflow_dispatch` if you added it).

**Jobs (in order):**

1. **Security scans (matrix, runs in parallel)**

   * **Gitleaks** (fail-fast or “report only” depending on config)
     Artifacts: `gitleaks-reports.zip` (SARIF/JSON)
   * **Semgrep** (SAST) → SARIF + artifact `semgrep.json`
   * **Trivy** (image scan + SBOM) → `trivy.json`, `sbom-spdx.json`
2. **Build & Prepare**
   Pulls/verifies `bkimminich/juice-shop:latest`; prepares metadata/tags.
3. **Deploy Infrastructure (Terraform)**
   Creates/updates VPC, subnets, ALB, ECS/Fargate service; re-tags image to ECR as needed.
4. **Security Testing (ZAP Baseline)**
   Scans the live app via ALB DNS; uploads HTML or logs; optionally opens GitHub issues.
5. **Cleanup (light)**
   Leaves infra up; you can destroy it via Terraform when done.

> If ZAP shows *“Resource not accessible by integration”*, enable “Read & write” workflow permissions or set `allow_issue_writing: false` in the ZAP step to suppress issue creation attempts.

---

## 🌐 Deploying to AWS (from CI or locally)

**Terraform from CI is automatic.** To run locally:

```bash
cd infra
terraform init
terraform apply -var="region=<aws-region>" -var="image_uri=bkimminich/juice-shop:latest"
```

**Outputs you’ll use:**

* `alb_dns_name` → browse to `http://<alb-dns>` to see Juice Shop in the cloud
* ECR repo name (if re-tagging enabled)

---

## 🔍 Post-deploy verification (what to check)

1. **Open the app:** `http://<ALB DNS>` (CI prints this in the Deploy job)
2. **ECS service healthy:** ECS → Clusters → *your cluster* → Services → `tangled-web-lab-dev-svc`
3. **Target group healthy:** EC2 → Load Balancing → Target groups → `tangled-web-lab-dev-tg` → “healthy”
4. **Logs flowing:** CloudWatch Logs → `/ecs/tangled-web-lab-dev`
5. **ZAP ran:** download ZAP artifact; confirm count of WARNs/INFO/PASS

---

## 🧾 Evidence pack — Screenshots

### A. Local lab

<img width="2557" height="1405" alt="Image" src="https://github.com/user-attachments/assets/ff236a1a-0be4-4716-b7bb-1f344d8b6103" />
— Juice Shop on `http://localhost:3000`
<img width="2550" height="1402" alt="Image" src="https://github.com/user-attachments/assets/bb9fbf06-4559-4f65-afda-24b711ee4c58" />
— ZAP baseline report (HTML)

### B. GitHub Actions

<img width="2167" height="649" alt="Image" src="https://github.com/user-attachments/assets/76b2da94-bf51-43bf-b787-5da41b4c1037" />
— overall successful run with all jobs green
<img width="2172" height="372" alt="Image" src="https://github.com/user-attachments/assets/41d9c89e-f355-488c-b557-5cf44c873029" />
— artifacts panel showing `gitleaks-reports`, `semgrep.json`, `trivy.json`, `zap-results`

### C. AWS Console

<img width="2245" height="209" alt="Image" src="https://github.com/user-attachments/assets/cda4b07f-d63f-4bf9-9e32-4f11b16bd1bb" />
— ECS service with 1/1 running task
<img width="2289" height="240" alt="Image" src="https://github.com/user-attachments/assets/74435029-9656-4060-8667-af746bff3313" />
— ALB
<img width="1652" height="447" alt="Image" src="https://github.com/user-attachments/assets/4f5cee04-70ec-403d-94b3-f2cbd2490ecf" />
— Target group Health checks = healthy
<img width="2266" height="957" alt="Image" src="https://github.com/user-attachments/assets/c9337ab0-7a3a-4c71-be74-cb3d533e140c" />
<img width="2263" height="690" alt="Image" src="https://github.com/user-attachments/assets/467ce174-67b7-49a5-8d0d-d9f3f8dc85cd" />
— Recent app logs
<img width="2247" height="215" alt="Image" src="https://github.com/user-attachments/assets/63692394-a394-49f6-95a2-b5fcf79892fa" />
— ECR repo
<img width="1654" height="763" alt="Image" src="https://github.com/user-attachments/assets/ff731639-e6ca-456d-a3df-82902085fdfb" />
— IAM Role trust policy

### D. Security reports

<img width="2533" height="1316" alt="Image" src="https://github.com/user-attachments/assets/4130d3b1-ba88-4f36-bb3b-66aeb01f9231" />
— ZAP Baseline report after cloud deploy


---

## 🧰 Repo layout (key bits)

```
/app/                         # (submodule or folder) Juice Shop
/infra/                       # Terraform (VPC, ALB, ECS, ECR, logs)
/.github/workflows/ci.yml     # CI/CD pipeline
/zap/                         # ZAP automation files (optional)
/reports/                     # local-only reports (gitignored)
```

---

## 🧪 Troubleshooting (battle-tested)

* **ECS service “Creation was not idempotent”**
  A prior service with the same name exists or is still deleting.
  → ECS → Clusters → your cluster (e.g. tangled-web-lab-dev-cluster)
    ECS → Cluster → Services: delete `tangled-web-lab-dev-svc` (wait until **INACTIVE**)
    EC2 → Load Balancers: delete tangled-web-lab-dev-alb
    EC2 → Target Groups: delete tangled-web-lab-dev-tg
    CloudWatch Logs → Log groups: delete /ecs/tangled-web-lab-dev
    IAM → Roles: delete tangled-web-lab-dev-task-exec
    IAM → Roles: delete tangled-web-lab-dev-task-role
    ECR → Repositories: delete tangled-web-lab-dev-app
  
  **Re-run**.

* **Terraform “ResourceAlreadyExists” (ALB, target group, log group, ECR, IAM role)**
  Stray resources exist from a previous attempt.
  → Manually delete the named resources (ALB, TG, log group `/ecs/tangled-web-lab-dev`, IAM role `*-task-exec`, ECR repo), then re-run.

* **ZAP error “Resource not accessible by integration”**
  Enable repo **Actions → Workflow permissions → Read and write**, or set ZAP action input `allow_issue_writing: false`.

* **gitleaks artifact missing / empty**
  Ensure the step writes `gitleaks.sarif`/`gitleaks.json` to the expected path *before* uploading; confirm `paths:` in upload-artifact.

* **Re-run without push**
  Add `workflow_dispatch:` to `on:` in `ci.yml` or use **Actions → the run → Re-run all jobs**.

---

## 🧹 Cleanup / Cost control

From CI: add a “Destroy” workflow, or locally:

```bash
cd infra
terraform destroy -auto-approve
```

**Sanity checklist (what should be gone) if you experimented:**

* VPC, subnets, route tables, NAT (if any)
* ALB + target groups + listeners
* ECS cluster + service + task definitions
* ECR repository (may remain empty if you prefer)
* Security groups
* CloudWatch log groups
* IAM roles created by TF

> Typical demo run is **well under \$2** if destroyed the same day.

---

## 📚 References

* OWASP Juice Shop — [https://owasp.org/www-project-juice-shop/](https://owasp.org/www-project-juice-shop/)
* OWASP ZAP — [https://www.zaproxy.org/](https://www.zaproxy.org/)
* Semgrep — [https://semgrep.dev/](https://semgrep.dev/)
* Trivy — [https://aquasec.com/products/trivy/](https://aquasec.com/products/trivy/)
* Terraform AWS Provider — [https://registry.terraform.io/providers/hashicorp/aws/latest](https://registry.terraform.io/providers/hashicorp/aws/latest)
