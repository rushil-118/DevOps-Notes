# Terraform & Infrastructure as Code — 

## 1. DevOps & Infrastructure as Code (IaC)

> IaC = Manage infrastructure using code instead of manual clicking.

Benefits:
- Repeatable
- Version controlled
- Auditable
- Fast
- Less human error

---

## 2. Categories of IaC Tools

### 1) Infrastructure Provisioning Tools (Create Infra)

Used to:
- Create servers
- Create networks
- Create load balancers

Examples:
- AWS CloudFormation
- Azure BICEPS
- Terraform (platform agnostic)

---

### 2) Configuration Management Tools (Configure Infra)

Used to:
- Install packages
- Configure software
- Maintain state

Examples:
- Ansible
- Puppet
- Chef

Important concept:
> Prevents configuration drift

---

### 3) Server Templating Tools

Used to:
- Create pre-baked machines / images

Examples:
- Vagrant
- Docker

---

## 3. Why Terraform?

- Platform agnostic
- Works with:
  - AWS
  - Azure
  - GCP
  - Kubernetes
- Uses declarative language
- Keeps state of infrastructure in:
  > terraform.tfstate file

---

## 4. Terraform State File

> terraform.tfstate = source of truth

- Stores:
  - What Terraform created
  - What exists in cloud
- Used to:
  - Detect changes
  - Calculate plan

---

## 5. Terraform Lifecycle Commands

### 1) terraform init

- Initializes working directory
- Downloads providers
- Sets up backend

---

### 2) terraform plan

- Shows:
  - What will be created
  - What will be changed
  - What will be destroyed
- Safe preview (no changes happen)

---

### 3) terraform apply

- Actually:
  - Creates resources
  - Updates resources
  - Deletes resources

---

### 4) terraform destroy

- Deletes everything created by Terraform

---

## 6. Typical Terraform Workflow

```text
Write .tf files
   ↓
terraform init
   ↓
terraform plan
   ↓
terraform apply
```

---

## 7. Example Use Case

> Create EC2 using Terraform

Steps:
- Write EC2 config in .tf file
- Run init → plan → apply
- Terraform creates VM
- State stored in tfstate file

---

## 8. Configuration Drift

> When actual infra ≠ expected infra

Terraform solves this by:
- Comparing state file with real infra
- Showing differences in terraform plan

---

## 9. How Terraform Fits in DevOps

- CI pipeline:
  - Terraform plan
  - Terraform apply
- CD pipeline:
  - Infra updates
  - Environment creation

---

## 10. My Mental Model

- Terraform = Infrastructure factory
- tf files = blueprint
- tfstate = memory
- plan = preview
- apply = execute

---

## 11. One Line Summary

> Terraform is a platform-agnostic Infrastructure as Code tool that creates, updates, and manages cloud resources using code and state tracking.