# CI/CD with Kubernetes — Personal Class Revision Notes


## Big Picture

> This class was mainly about **building CI/CD pipelines and deploying to Kubernetes using VMs and GitHub Actions**.

Main focus:

- CI (Continuous Integration)
- CD (Continuous Delivery / Deployment)
- Kubernetes deployment
- Multi-stage testing environments

---

## What is CI/CD?

### Continuous Integration (CI)

- Developers push code frequently
- Pipeline automatically:
  - Builds code
  - Runs tests
  - Runs scans
- Goal:
  > Keep main branch always deployable

---

### Continuous Deployment (CD)

- Extends CI
- Automatically deploys app to environment (or prod)
- No downtime deployment

Difference:

- CI = build + test
- CD = deploy

---

## Environment Setup

### Using Virtual Machines

- Kubernetes cluster is running on VM
- Tools used:
  - VirtualBox
  - Vagrant
- Vagrant helps:
  - Create VM using script
  - Preconfigure Kubernetes

---

### Prebuilt Images

- Instead of manual install:
  - Use AMI or prebuilt VM with Kubernetes

---

## GitHub Actions in This Setup

- Used as:
  - CI/CD engine
- Can use:
  - GitHub-hosted runners
  - Self-hosted runners (custom runners)

---

## Custom GitHub Runners (Important)

> Instead of GitHub VM, we used our own machine.

Steps:

1. Create VM (Linux preferred)
2. Install runner
3. Run:

```bash
./config.sh
```

4. Register with GitHub repo
5. Add labels & security config
6. Start runner

Now:

> GitHub sends jobs to YOUR VM

---

## Artifact Flow (From Your Diagram)

```text
Artifactory → SIT → Performance Testing → Security Testing → UAT/Prod
```

---

## Testing Stages Explained

### 1. SIT (System Integration Testing)

- Deploy app
- Run integration tests
- Validate all services work together

---

### 2. Performance Testing

- Deploy app
- Run:
  - Load test
  - Stress test
- Check:
  - Speed
  - Stability

---

### 3. Security Testing

- Deploy app in security test env
- Run:
  - DAST scans
- Find:
  - Runtime vulnerabilities

---

### 4. UAT (User Acceptance Testing)

- Business validates app
- Final signoff before production

---

## Where Artifacts Come From

- Docker images / build outputs stored in:
  - Nexus
  - Artifactory
  - ECR / ACR

---

## How This Pipeline Works 

```text
Code Push
  ↓
CI (Build + Test + Scan)
  ↓
Build Artifact / Docker Image
  ↓
Store in Artifact Repo
  ↓
Deploy to SIT → Test
  ↓
Deploy to Performance → Test
  ↓
Deploy to Security → Test
  ↓
Deploy to UAT / Prod
```

---

## Important Class Notes

- CI and CD are usually **separate pipelines**
- CD is more dangerous → needs approvals sometimes
- Custom runners are used when:
  - Need access to private network
  - Need Kubernetes access
  - Need special tools

---

## My Mental Model

- CI = factory
- Artifact repo = warehouse
- CD = delivery pipeline
- SIT/Perf/Security = quality gates
- Prod = final destination

---

## One Line Summary

> This class was about building a full CI/CD pipeline using GitHub Actions and Kubernetes with multi-stage testing environments running on VMs.