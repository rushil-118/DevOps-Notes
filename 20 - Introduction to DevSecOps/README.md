# GitHub Actions + Docker DevSecOps Pipeline (Java Maven) — Revision Notes

## Big Picture

> We are building an industry-style CI pipeline that:

- Builds Java app
- Runs tests
- Runs security scans (code + dependencies + container)
- Builds Docker image
- Tests container
- Pushes trusted image to DockerHub

Pipeline Flow:

Developer Push → GitHub Actions Runner →  
Checkout → Build → Test → Security Scan →  
Docker Build → Image Scan → Container Test → Push to Registry

---

## Prerequisites

- Java Maven project
- Working Dockerfile
- App running on port 8080
- DockerHub account

---

## GitHub Secrets (Mandatory)

Create in:

GitHub Repo → Settings → Secrets and Variables → Actions

- DOCKERHUB_USERNAME
- DOCKERHUB_TOKEN

> Never hardcode credentials in YAML.

---

## Pipeline Trigger

- Runs on:
  - Push to main/master
  - Manual trigger (workflow_dispatch)

---

## Where Pipeline Runs

- On: ubuntu-latest GitHub runner
- Fresh VM is created every time

---

## Pipeline Stages (In Order)

### 1. Checkout Code

- Downloads repo to runner

---

### 2. Setup Java + Maven

- Installs Java
- Caches dependencies
- Ensures consistent build environment

---

### 3. Linting (Code Quality)

- Tool: Checkstyle
- Purpose:
  - Enforce coding standards
  - Catch bad practices early

---

### 4. SAST (Static Code Scan)

- Tool: CodeQL
- Finds:
  - SQL injection
  - Command injection
  - OWASP Top 10 issues

---

### 5. SCA (Dependency Scan)

- Tool: OWASP Dependency Check
- Finds:
  - Vulnerable open-source libraries
- Protects from:
  - Supply chain attacks

---

### 6. Unit Testing

- Command: mvn test
- If tests fail → pipeline fails

---

### 7. Build Application

- Command: mvn clean package -DskipTests
- Produces:
  - JAR / WAR file

---

### 8. Build Docker Image

- Command: docker build
- Creates:
  - Immutable application image

---

### 9. Container Image Scan

- Tool: Trivy
- Scans:
  - OS packages
  - Java libs
  - CVEs
- If critical/high found → pipeline fails

---

### 10. Upload Scan Results

- Uploads report to:
  - GitHub Security tab

---

### 11. Container Runtime Test

- Runs container
- Calls:
  - http://localhost:8080
- Confirms:
  - App starts
  - No crash

---

### 12. Login to DockerHub

- Uses GitHub Secrets
- Secure authentication

---

### 13. Push Docker Image

- Pushes:
  - Only if ALL checks pass

---

## What Happens When Code is Pushed?

1. Runner VM starts
2. Code is built
3. Tests run
4. Security scans run
5. Image is built
6. Image is scanned
7. Container is tested
8. Image is pushed if safe

