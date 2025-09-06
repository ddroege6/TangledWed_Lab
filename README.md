# 🛡️ Tangled Web Lab

A DevSecOps lab project that demonstrates **secure CI/CD pipelines**, **infrastructure-as-code**, and **runtime security testing** using a deliberately vulnerable app (OWASP Juice Shop).


<img width="666" height="1024" alt="Image" src="https://github.com/user-attachments/assets/c766d02c-4da5-4fab-989a-4d07c03e0618" />

---

## 🚀 Project Overview

This lab is designed to **showcase security best practices** for cloud workloads:

- Dockerized OWASP Juice Shop (intentionally vulnerable app)
- CI/CD pipeline with **secret scanning, SAST, SCA, SBOM, DAST**
- Infrastructure-as-Code (Terraform) → **ECS Fargate + ALB + WAF**
- Automated **post-deploy security tests** (ZAP Baseline)
- Cloud observability (CloudWatch, alarms, logging)
- Tear-down friendly: <$2 per run if destroyed same day

---

## 🏗️ Architecture

![Architecture Diagram](docs/architecture.png) <!-- add later -->

---

## 📸 Screenshots (Evidence)

### Local Lab
<img width="2557" height="1405" alt="Image" src="https://github.com/user-attachments/assets/ff236a1a-0be4-4716-b7bb-1f344d8b6103" />

Juice Shop homepage (`localhost:3000`)

<img width="2550" height="1402" alt="Image" src="https://github.com/user-attachments/assets/bb9fbf06-4559-4f65-afda-24b711ee4c58" />

ZAP baseline report (HTML)

- [ ] Docker Desktop with containers

### GitHub Actions
- [ ] Workflow run with all jobs
- [ ] Gitleaks artifact
- [ ] Semgrep + Trivy artifacts

### AWS Cloud
- [ ] Terraform `apply` output
- [ ] ECS service screenshot
- [ ] ALB DNS → Juice Shop homepage (cloud)
- [ ] WAF metrics dashboard
- [ ] CloudWatch log snippet

### Security Reports
- [ ] Semgrep findings screenshot
- [ ] Trivy vulnerability summary
- [ ] SBOM package list
- [ ] ZAP post-deploy report (HTML)

---

## 🧰 Tech Stack

- **IaC**: Terraform
- **CI/CD**: GitHub Actions
- **Container Runtime**: ECS Fargate
- **Security Tools**:  
  - Gitleaks (secret scanning)  
  - Semgrep (SAST)  
  - Trivy (image scan + SBOM)  
  - ZAP Baseline (DAST)  
  - Checkov (Terraform IaC scan, optional)  
- **Cloud Services**:  
  - AWS VPC, ECS, ALB, WAF, CloudWatch, ECR

---

## 📝 How to Run Locally

```bash
git clone https://github.com/<you>/tangled-web-lab.git
cd tangled-web-lab
docker compose up --pull always
````

Then open: [http://localhost:3000](http://localhost:3000)

Reports will appear in `/reports`.

---

## 🌐 How to Deploy to AWS

> ⚠️ Costs: <\$2 per run if destroyed same day.
> Run `terraform destroy` after demos to avoid charges.

```bash
cd infra
terraform init
terraform apply
```

---

## 📊 CI/CD Pipeline

**Stages:**

1. Gitleaks (fail-fast)
2. Semgrep (SAST)
3. Trivy (SCA + SBOM)
4. Terraform plan/apply
5. ECS deploy
6. ZAP Baseline post-deploy

---

## 🎯 Portfolio Value

This lab demonstrates:

* Infrastructure-as-Code (Terraform)
* DevSecOps CI/CD
* Multi-layered security: SAST, SCA, DAST, WAF
* Cloud observability and hardening
* Secure tear-down practices

---

## 📚 References

* [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
* [OWASP ZAP](https://www.zaproxy.org/)
* [Semgrep](https://semgrep.dev/)
* [Trivy](https://aquasec.com/products/trivy/)
* [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

```
